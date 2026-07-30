#!/usr/bin/env python3
"""Deduplicate per-template Spectral output and emit GitHub annotations."""

from __future__ import annotations

import argparse
import json
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any

import yaml

Finding = dict[str, Any]

SPECTRAL_LEVELS = {
    0: ("error", "error"),
    1: ("warning", "warning"),
    2: ("info", "notice"),
    3: ("hint", "notice"),
}
S_313_ID = "S-313"
S_313_METADATA_URL = (
    "https://github.com/camaraproject/tooling/blob/v1-rc/"
    "validation/rules/spectral-rules.yaml"
)


def _start(finding: Finding) -> dict[str, Any]:
    value = finding.get("range", {}).get("start", {})
    return value if isinstance(value, dict) else {}


def finding_line(finding: Finding) -> int:
    return int(_start(finding).get("line", 0)) + 1


def finding_column(finding: Finding) -> int | None:
    character = _start(finding).get("character")
    return int(character) + 1 if character is not None else None


def schema_path(finding: Finding) -> str:
    value = finding.get("path")
    if not isinstance(value, list):
        return ""
    return ".".join(str(segment) for segment in value)


def normalize_source(source: object, repo_root: Path) -> str:
    if not isinstance(source, str) or not source:
        raise ValueError("Spectral finding is missing source attribution")

    path = Path(source)
    if path.is_absolute():
        try:
            path = path.resolve().relative_to(repo_root.resolve())
        except ValueError as exc:
            raise ValueError(f"Spectral source is outside the repository: {source}") from exc
    return path.as_posix()


def load_findings(result_paths: list[Path], repo_root: Path) -> list[Finding]:
    """Load, normalize, and deduplicate findings by file, line, and rule."""
    findings: list[Finding] = []
    seen: set[tuple[str, int, str]] = set()

    for result_path in result_paths:
        data = json.loads(result_path.read_text(encoding="utf-8"))
        if not isinstance(data, list):
            raise ValueError(f"Spectral output is not an array: {result_path}")

        for raw in data:
            if not isinstance(raw, dict):
                raise ValueError(f"Spectral output contains a non-object: {result_path}")
            finding = dict(raw)
            finding["source"] = normalize_source(finding.get("source"), repo_root)
            key = (
                finding["source"],
                finding_line(finding),
                str(finding.get("code", "")),
            )
            if key in seen:
                continue
            seen.add(key)
            findings.append(finding)

    return sorted(
        findings,
        key=lambda finding: (
            finding["source"],
            finding_line(finding),
            str(finding.get("code", "")),
        ),
    )


def load_s_313_allowlist(metadata_path: Path) -> tuple[str, set[str]]:
    metadata = yaml.safe_load(metadata_path.read_text(encoding="utf-8"))
    if not isinstance(metadata, list):
        raise ValueError("Spectral rule metadata is not a list")

    rule = next(
        (item for item in metadata if isinstance(item, dict) and item.get("id") == S_313_ID),
        None,
    )
    if rule is None:
        raise ValueError(f"{S_313_ID} is missing from Spectral rule metadata")

    engine_rule = rule.get("engine_rule")
    allowlist = rule.get("suppress_schema_paths")
    if not isinstance(engine_rule, str) or not isinstance(allowlist, list):
        raise ValueError(f"{S_313_ID} metadata is missing its engine rule or allowlist")
    return engine_rule, {str(path) for path in allowlist}


def partition_allowlisted_findings(
    findings: list[Finding],
    engine_rule: str,
    allowlist: set[str],
) -> tuple[dict[str, list[Finding]], list[Finding]]:
    grouped: dict[str, list[Finding]] = defaultdict(list)
    individual: list[Finding] = []

    for finding in findings:
        if finding.get("code") == engine_rule and schema_path(finding) in allowlist:
            grouped[finding["source"]].append(finding)
        else:
            individual.append(finding)
    return dict(grouped), individual


def _escape_data(value: object) -> str:
    return str(value).replace("%", "%25").replace("\r", "%0D").replace("\n", "%0A")


def _escape_property(value: object) -> str:
    return _escape_data(value).replace(":", "%3A").replace(",", "%2C")


def _count_label(count: int, singular: str, plural: str | None = None) -> str:
    return f"{count} {singular if count == 1 else plural or singular + 's'}"


def emit_annotation(
    level: str,
    finding: Finding,
    title: str,
    message: str,
) -> None:
    properties = [
        f"file={_escape_property(finding['source'])}",
        f"line={finding_line(finding)}",
        f"title={_escape_property(title)}",
    ]
    column = finding_column(finding)
    if column is not None:
        properties.insert(2, f"col={column}")
    print(f"::{level} {','.join(properties)}::{_escape_data(message)}")


def render_report(
    findings: list[Finding],
    grouped: dict[str, list[Finding]],
    individual: list[Finding],
    input_count: int,
) -> None:
    for finding in findings:
        severity = int(finding.get("severity", 1))
        label = SPECTRAL_LEVELS.get(severity, ("warning", "warning"))[0]
        column = finding_column(finding)
        location = f"{finding['source']}:{finding_line(finding)}"
        if column is not None:
            location += f":{column}"
        print(
            f"{location} {label} {finding.get('message', '')} "
            f"{finding.get('code', 'unknown')}"
        )

    counts = Counter(int(finding.get("severity", 1)) for finding in findings)
    print(
        f"\nX {len(findings)} problems "
        f"({_count_label(counts[0], 'error')}, "
        f"{_count_label(counts[1], 'warning')}, "
        f"{_count_label(counts[2], 'info', 'infos')}, "
        f"{_count_label(counts[3], 'hint')})"
    )

    collapsed_count = 0
    for source, source_findings in sorted(grouped.items()):
        collapsed_count += len(source_findings)
        first = min(source_findings, key=finding_line)
        emit_annotation(
            "notice",
            first,
            f"{S_313_ID} documented baseline",
            (
                f"{len(source_findings)} expected {S_313_ID} findings match "
                f"suppress_schema_paths and are collapsed here. {S_313_METADATA_URL}"
            ),
        )

    for finding in individual:
        severity = int(finding.get("severity", 1))
        annotation_level = SPECTRAL_LEVELS.get(severity, ("warning", "warning"))[1]
        emit_annotation(
            annotation_level,
            finding,
            str(finding.get("code", "Spectral")),
            str(finding.get("message", "")),
        )

    print(
        f"Spectral reported {len(findings)} unique findings across {input_count} templates: "
        f"{len(individual)} individual annotations and {len(grouped)} notices "
        f"covering {collapsed_count} documented baseline findings."
    )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--metadata", type=Path, required=True)
    parser.add_argument("--repo-root", type=Path, default=Path.cwd())
    parser.add_argument("results", type=Path, nargs="+")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    findings = load_findings(args.results, args.repo_root)
    engine_rule, allowlist = load_s_313_allowlist(args.metadata)
    grouped, individual = partition_allowlisted_findings(findings, engine_rule, allowlist)
    render_report(findings, grouped, individual, len(args.results))


if __name__ == "__main__":
    main()
