#!/usr/bin/env python3
"""Turn per-file Spectral JSON output into check-run annotations and a report.

Used by .github/workflows/artifacts-lint.yml.  The Spectral step lints each
template in its own invocation (see the workflow header for why) and drops one
JSON result file per template into a directory; this script merges them into
the single view a reviewer should see.

What it does, in order:

1. Merge every ``*.json`` result file and deduplicate on
   ``(source file, line, rule)``.  Findings in ``artifacts/common/**`` are
   reported once per template that ``$ref``s them, so the raw count is several
   times the number of real findings.
2. Split the unique findings into *documented as expected* and *to review*.
   A finding is expected when its Spectral JSON path matches an entry in the
   ``suppress_schema_paths`` allowlist of the matching rule in the tooling rule
   metadata -- the same allowlist, read from the same file, that CAMARA
   Validation applies in API repositories.
3. Emit annotations: one per finding to review at its native Spectral severity,
   plus one ``notice`` per source file summarising that file's expected
   findings.  GitHub renders at most 10 annotations per level per step, so
   collapsing the expected baseline keeps the warning level free for findings a
   pull request actually introduces.
4. Print a reconciliation report -- raw versus unique counts, per-source-file
   totals, and every finding to review -- to stdout and to the step summary, so
   the numbers in the log, in the annotations and on the run page agree.

Exit status is 0 unless the arguments themselves are unusable; the lint outcome
is the Spectral exit status, which the workflow tracks separately.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path

import yaml

# Spectral DiagnosticSeverity -> GitHub annotation level.  Mirrors OUTPUT_TYPES
# in @stoplight/spectral-formatters' github-actions formatter, so individually
# annotated findings keep the level they had before this script existed.
SEVERITY_TO_LEVEL = {0: "error", 1: "warning", 2: "notice", 3: "notice"}

# Where the expected findings are explained.  Referenced from the aggregate
# annotations, which name no rule themselves.
EXPECTED_FINDINGS_DOC = "artifacts/linting_rules/README.md"

# GitHub renders at most this many annotations per level per step.
ANNOTATION_LIMIT_PER_LEVEL = 10


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--findings-dir",
        required=True,
        type=Path,
        help="directory holding one Spectral JSON result file per linted template",
    )
    parser.add_argument(
        "--rules",
        required=True,
        type=Path,
        help="tooling validation/rules/spectral-rules.yaml (source of the allowlist)",
    )
    parser.add_argument(
        "--repo-root",
        default=Path.cwd(),
        type=Path,
        help="repository root, used to make Spectral's absolute paths relative",
    )
    parser.add_argument(
        "--status-file",
        type=Path,
        help="optional TSV of '<exit status>\\t<template>' lines, one per invocation",
    )
    parser.add_argument(
        "--summary-file",
        type=Path,
        help="optional file to append the report to (normally $GITHUB_STEP_SUMMARY)",
    )
    return parser.parse_args(argv)


def load_allowlist(rules_path: Path) -> dict[str, tuple[str, ...]]:
    """Map Spectral rule code -> allowlisted schema paths from rule metadata."""
    entries = yaml.safe_load(rules_path.read_text(encoding="utf-8")) or []
    allowlist: dict[str, tuple[str, ...]] = {}
    for entry in entries:
        if not isinstance(entry, dict) or entry.get("engine") != "spectral":
            continue
        paths = entry.get("suppress_schema_paths") or []
        rule = entry.get("engine_rule")
        if rule and paths:
            allowlist[str(rule)] = tuple(str(p) for p in paths)
    return allowlist


def is_expected(schema_path: str, allowed: tuple[str, ...]) -> bool:
    """Match a schema path against an allowlist the way the post-filter does.

    Exact equality or a prefix ending at a dot boundary, so an entry for
    ``components.schemas.ErrorInfo`` does not also match a sibling schema named
    ``ErrorInfoExtended``.
    """
    return any(
        schema_path == entry or schema_path.startswith(entry + ".")
        for entry in allowed
    )


def relative_to_repo(source: str, repo_root: Path) -> str:
    """Make an absolute Spectral source path repo-relative, or leave it alone."""
    if not source:
        return ""
    prefix = str(repo_root).rstrip("/") + "/"
    return source[len(prefix):] if source.startswith(prefix) else source


def read_findings(findings_dir: Path, repo_root: Path) -> tuple[list[dict], int]:
    """Merge the per-invocation JSON files into deduplicated findings.

    Returns the unique findings, ordered by source file then line, and the raw
    count before deduplication.
    """
    raw_count = 0
    unique: dict[tuple[str, int, str], dict] = {}

    for result_file in sorted(findings_dir.glob("*.json")):
        text = result_file.read_text(encoding="utf-8").strip()
        if not text:
            continue
        try:
            results = json.loads(text)
        except json.JSONDecodeError as exc:
            print(f"::error::Could not parse {result_file.name}: {exc}")
            continue
        if not isinstance(results, list):
            print(f"::error::Expected a JSON array in {result_file.name}")
            continue

        for result in results:
            raw_count += 1
            start = result.get("range", {}).get("start", {})
            end = result.get("range", {}).get("end", {})
            schema_path = ".".join(
                str(segment) for segment in result.get("path") or []
            )
            finding = {
                "file": relative_to_repo(result.get("source", ""), repo_root),
                "line": start.get("line", 0) + 1,
                "column": start.get("character", 0) + 1,
                "end_line": end.get("line", 0) + 1,
                "end_column": end.get("character", 0) + 1,
                "rule": str(result.get("code", "unknown")),
                "message": result.get("message", ""),
                "severity": result.get("severity", 1),
                "schema_path": schema_path,
            }
            # Keep the first occurrence: the same common-file finding surfaces
            # once per template that resolves it.
            unique.setdefault(
                (finding["file"], finding["line"], finding["rule"]), finding
            )

    findings = sorted(unique.values(), key=lambda f: (f["file"], f["line"]))
    return findings, raw_count


def read_failures(status_file: Path | None) -> list[tuple[str, int]]:
    """Read the templates whose Spectral invocation failed to produce results.

    Exit status 0 (clean) and 1 (findings at or above the fail severity) are
    both normal; 2 and above is a Spectral runtime error and means that
    template contributed no findings at all.
    """
    if status_file is None or not status_file.is_file():
        return []
    failures = []
    for line in status_file.read_text(encoding="utf-8").splitlines():
        status, _, template = line.partition("\t")
        if not template:
            continue
        try:
            code = int(status)
        except ValueError:
            continue
        if code >= 2:
            failures.append((template, code))
    return failures


def escape_property(value: str) -> str:
    """Escape a workflow-command property value."""
    return (
        value.replace("%", "%25")
        .replace("\r", "%0D")
        .replace("\n", "%0A")
        .replace(":", "%3A")
        .replace(",", "%2C")
    )


def escape_message(value: str) -> str:
    """Escape a workflow-command message body."""
    return value.replace("%", "%25").replace("\r", "%0D").replace("\n", "%0A")


def emit_annotations(
    to_review: list[dict],
    expected_by_file: dict[str, int],
    failures: list[tuple[str, int]],
) -> None:
    """Write the workflow commands that become check-run annotations.

    Findings to review come first so they are the ones that survive the
    per-level cap if a pull request introduces a large number of them.
    """
    for finding in to_review:
        level = SEVERITY_TO_LEVEL.get(finding["severity"], "warning")
        params = ",".join(
            [
                f"title={escape_property(finding['rule'])}",
                f"file={escape_property(finding['file'])}",
                f"col={finding['column']}",
                f"endColumn={finding['end_column']}",
                f"line={finding['line']}",
                f"endLine={finding['end_line']}",
            ]
        )
        print(f"::{level} {params}::{escape_message(finding['message'])}")

    for source_file, count in sorted(expected_by_file.items()):
        params = ",".join(
            [
                "title=Expected lint findings",
                f"file={escape_property(source_file)}",
                "line=1",
            ]
        )
        plural = "finding" if count == 1 else "findings"
        message = (
            f"{count} {plural} in this file are documented as expected "
            f"- see {EXPECTED_FINDINGS_DOC}"
        )
        print(f"::notice {params}::{escape_message(message)}")

    for template, code in failures:
        params = ",".join(
            [
                "title=Spectral run failed",
                f"file={escape_property(template)}",
                "line=1",
            ]
        )
        message = (
            f"Spectral exited with status {code} for this template, so it "
            "contributed no findings to the report below."
        )
        print(f"::error {params}::{escape_message(message)}")


def build_report(
    findings: list[dict],
    raw_count: int,
    expected_keys: set[tuple[str, int, str]],
    failures: list[tuple[str, int]],
) -> str:
    """Render the reconciliation report as Markdown."""
    to_review = [
        f for f in findings if (f["file"], f["line"], f["rule"]) not in expected_keys
    ]
    expected_count = len(findings) - len(to_review)

    per_file: dict[str, dict[str, int]] = {}
    for finding in findings:
        counts = per_file.setdefault(finding["file"], {"expected": 0, "review": 0})
        key = (finding["file"], finding["line"], finding["rule"])
        counts["expected" if key in expected_keys else "review"] += 1

    lines = ["## Spectral findings", ""]

    if failures:
        subject = (
            "1 template could not be linted"
            if len(failures) == 1
            else f"{len(failures)} templates could not be linted"
        )
        lines.append(
            f"**{subject}** - their findings are missing from the counts below:"
        )
        lines.append("")
        for template, code in failures:
            lines.append(f"- `{template}` (Spectral exit status {code})")
        lines.append("")

    if not findings:
        lines.append("No findings.")
        lines.append("")
        return "\n".join(lines)

    lines.append(
        f"{raw_count} raw findings across the per-template runs reduce to "
        f"**{len(findings)} unique** findings: **{expected_count} documented as "
        f"expected**, **{len(to_review)} to review**."
    )
    lines.append("")
    lines.append(
        "Each template is linted in its own Spectral invocation, so a finding in "
        "`artifacts/common/**` is reported once per template that `$ref`s it. The "
        "table below counts each one once, against the file it lives in."
    )
    lines.append("")
    lines.append(
        "| Source file | Unique findings | Documented as expected | To review |"
    )
    lines.append("| --- | --: | --: | --: |")
    for source_file in sorted(per_file):
        counts = per_file[source_file]
        total = counts["expected"] + counts["review"]
        lines.append(
            f"| `{source_file}` | {total} | {counts['expected']} | {counts['review']} |"
        )
    lines.append(
        f"| **Total** | **{len(findings)}** | **{expected_count}** | "
        f"**{len(to_review)}** |"
    )
    lines.append("")
    lines.append(
        f"Findings documented as expected are explained in "
        f"`{EXPECTED_FINDINGS_DOC}`; each file above contributing any of them "
        "carries one `notice` annotation with its count."
    )
    lines.append("")

    if to_review:
        lines.append("### Findings to review")
        lines.append("")
        lines.append("| Location | Level | Rule | Message |")
        lines.append("| --- | --- | --- | --- |")
        for finding in to_review:
            level = SEVERITY_TO_LEVEL.get(finding["severity"], "warning")
            location = f"{finding['file']}:{finding['line']}:{finding['column']}"
            lines.append(
                f"| `{location}` | {level} | `{finding['rule']}` | "
                f"{finding['message']} |"
            )
        lines.append("")

        # Say so rather than letting a truncated annotation list read as the
        # whole result.
        for level in ("error", "warning"):
            at_level = sum(
                1
                for f in to_review
                if SEVERITY_TO_LEVEL.get(f["severity"], "warning") == level
            )
            if at_level > ANNOTATION_LIMIT_PER_LEVEL:
                unannotated = at_level - ANNOTATION_LIMIT_PER_LEVEL
                lines.append(
                    f"GitHub renders at most {ANNOTATION_LIMIT_PER_LEVEL} "
                    f"`{level}` annotations per step, so {unannotated} of the "
                    f"{at_level} `{level}` findings above have no annotation. "
                    "The table is complete."
                )
                lines.append("")
    else:
        lines.append("No findings to review.")
        lines.append("")

    return "\n".join(lines)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)

    if not args.findings_dir.is_dir():
        print(f"::error::Findings directory not found: {args.findings_dir}")
        return 1
    if not args.rules.is_file():
        print(f"::error::Rule metadata not found: {args.rules}")
        return 1

    allowlist = load_allowlist(args.rules)
    findings, raw_count = read_findings(args.findings_dir, args.repo_root)
    failures = read_failures(args.status_file)

    expected_keys = {
        (f["file"], f["line"], f["rule"])
        for f in findings
        if f["schema_path"]
        and is_expected(f["schema_path"], allowlist.get(f["rule"], ()))
    }
    expected_by_file: dict[str, int] = {}
    to_review = []
    for finding in findings:
        if (finding["file"], finding["line"], finding["rule"]) in expected_keys:
            expected_by_file[finding["file"]] = (
                expected_by_file.get(finding["file"], 0) + 1
            )
        else:
            to_review.append(finding)

    emit_annotations(to_review, expected_by_file, failures)

    report = build_report(findings, raw_count, expected_keys, failures)
    print()
    print(report)

    summary_file = args.summary_file or os.environ.get("GITHUB_STEP_SUMMARY")
    if summary_file:
        with open(summary_file, "a", encoding="utf-8") as handle:
            handle.write(report)
            handle.write("\n")

    return 0


if __name__ == "__main__":
    sys.exit(main())
