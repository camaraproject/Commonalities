#!/usr/bin/env python3
"""Tests for the Spectral annotation formatter."""

from __future__ import annotations

import io
import json
import tempfile
import unittest
from contextlib import redirect_stdout
from pathlib import Path

from report_spectral_findings import (
    load_findings,
    load_s_313_allowlist,
    partition_allowlisted_findings,
    render_report,
)


def finding(
    source: Path | None,
    line: int,
    schema_path: list[str],
    *,
    code: str = "owasp:api4:2023-string-restricted",
    severity: int = 1,
) -> dict[str, object]:
    value: dict[str, object] = {
        "code": code,
        "severity": severity,
        "message": "Constrain this string.",
        "path": schema_path,
        "range": {"start": {"line": line - 1, "character": 3}},
    }
    if source is not None:
        value["source"] = str(source)
    return value


class SpectralReportTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temp_dir = tempfile.TemporaryDirectory()
        self.root = Path(self.temp_dir.name)
        self.metadata = self.root / "spectral-rules.yaml"
        self.metadata.write_text(
            """
- id: S-313
  engine_rule: "owasp:api4:2023-string-restricted"
  suppress_schema_paths:
    - components.schemas.ErrorInfo.properties.code
""".lstrip(),
            encoding="utf-8",
        )

    def tearDown(self) -> None:
        self.temp_dir.cleanup()

    def write_results(self, name: str, values: list[dict[str, object]]) -> Path:
        path = self.root / name
        path.write_text(json.dumps(values), encoding="utf-8")
        return path

    def test_load_findings_normalizes_and_deduplicates(self) -> None:
        source = self.root / "artifacts/common/CAMARA_common.yaml"
        duplicate = finding(
            source,
            10,
            ["components", "schemas", "ErrorInfo", "properties", "code"],
        )
        first = self.write_results("first.json", [duplicate])
        second = self.write_results("second.json", [duplicate])

        findings = load_findings([first, second], self.root)

        self.assertEqual(len(findings), 1)
        self.assertEqual(findings[0]["source"], "artifacts/common/CAMARA_common.yaml")

    def test_load_findings_rejects_missing_source(self) -> None:
        result = self.write_results(
            "missing-source.json",
            [finding(None, 1, ["components", "schemas", "Example"])],
        )

        with self.assertRaisesRegex(ValueError, "missing source attribution"):
            load_findings([result], self.root)

    def test_render_groups_only_allowlisted_schema_paths(self) -> None:
        common_source = self.root / "artifacts/common/CAMARA_common.yaml"
        template_source = self.root / "artifacts/api-templates/sample-service.yaml"
        result = self.write_results(
            "results.json",
            [
                finding(
                    common_source,
                    10,
                    ["components", "schemas", "ErrorInfo", "properties", "code"],
                ),
                finding(
                    common_source,
                    20,
                    ["components", "headers", "link", "schema"],
                ),
                finding(
                    template_source,
                    30,
                    ["components", "schemas", "Resource", "properties", "name"],
                ),
                finding(
                    template_source,
                    40,
                    ["openapi"],
                    code="oas3-schema",
                    severity=0,
                ),
            ],
        )
        findings = load_findings([result], self.root)
        engine_rule, allowlist = load_s_313_allowlist(self.metadata)
        grouped, individual = partition_allowlisted_findings(
            findings,
            engine_rule,
            allowlist,
        )

        output = io.StringIO()
        with redirect_stdout(output):
            render_report(findings, grouped, individual, input_count=1)
        rendered = output.getvalue()

        self.assertEqual(sum(map(len, grouped.values())), 1)
        self.assertEqual(len(individual), 3)
        self.assertEqual(rendered.count("::notice "), 1)
        self.assertEqual(rendered.count("::warning "), 2)
        self.assertEqual(rendered.count("::error "), 1)
        self.assertIn("title=owasp%3Aapi4%3A2023-string-restricted", rendered)
        self.assertIn("X 4 problems (1 error, 3 warnings, 0 infos, 0 hints)", rendered)
        self.assertIn("3 individual annotations and 1 notices covering 1", rendered)


if __name__ == "__main__":
    unittest.main()
