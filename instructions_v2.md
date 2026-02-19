# Regression Governance Manual v2

> Version: 2.0  
> Effective Date: 2026-02-19  
> Scope: 4-repository regression operations  
> Status: Governing standard for all new regression runs

---

## 1. Purpose and Scope

### 1.1 Objective
Maintain a repeatable regression suite that detects:
- functional regressions
- cross-repository integration regressions
- security regressions

This manual defines how the team creates, stores, executes, reports, compiles, and delivers regression work.

### 1.2 In-Scope Repositories (Exactly 4)

| repo_key | Repository | Purpose |
|---|---|---|
| `repo1_jkyog_2_0` | `1_JKYog_2.0` | Main frontend |
| `repo2_radhakrishnatemple2_0` | `2_radhakrishnatemple2.0` | Temple frontend |
| `repo3_jkyog_2_0_backend` | `3_JKYog_2.0_backend` | Backend API |
| `repo4_jkyog_strapi` | `4_JKYog_Strapi` | CMS |

### 1.3 Out of Scope

The following is explicitly out of scope for this version:
- `5_jkyog_auth_backend`
- any repository not listed in section 1.2

---

## 2. Canonical Workspace Structure

All testing artifacts must be stored in this central workspace structure:

```text
testing/
  instructions.md
  instructions_v2.md
  docs/
  assignments/
  repos/
    repo1_jkyog_2_0/
      testplan/
      tests/
      reports/
      results/
    repo2_radhakrishnatemple2_0/
      testplan/
      tests/
      reports/
      results/
    repo3_jkyog_2_0_backend/
      testplan/
      tests/
      reports/
      results/
    repo4_jkyog_strapi/
      testplan/
      tests/
      reports/
      results/
  regression_compiled/
    latest/
    history/
```

### 2.1 Mandatory Storage Rules
- No flat shared pool for all test files.
- Every artifact must live under its repository folder (`repos/<repo_key>/...`).
- Cross-repository compiled outputs must go only in `regression_compiled/`.
- `instructions.md` is legacy; `instructions_v2.md` is the governing standard for new runs.

---

## 3. Naming Conventions (Strict `snake_case`)

### 3.1 Test Files
- Pattern: `tcNN_<feature>_<scenario>_<target>.py`
- Example: `tc01_valid_token_valid_token_acceptance_supabase_guard.py`

### 3.2 Test Plan Files
- Pattern: `testsprite_<repo-key>_testplan.json`
- Example: `testsprite_repo3_jkyog_2_0_backend_testplan.json`

### 3.3 Report and Result Files
- Raw report (required): `raw_report.md`
- Execution result (required): `test_results.json`

### 3.4 Legacy Compatibility Rule
- Mixed-case legacy names are accepted for one transition cycle only.
- Before merge, legacy files must be renamed to canonical `snake_case`.
- Canonical name for result files is always `test_results.json` (never `test_result.json`).

---

## 4. Artifact Contracts (Required Interfaces)

## 4.1 `testsprite_<repo-key>_testplan.json`

Each test case entry must include required keys:
1. `id` (example: `tc01_valid_token`)
2. `title`
3. `description`
4. `repo_key`
5. `service_or_module`
6. `priority` (`p0` | `p1` | `p2`)
7. `tags` (must include `security` when applicable, as needed)

Optional keys:
1. `method`
2. `endpoint`
3. `expected_status`
4. `notes`

Example:

```json
[
  {
    "id": "tc01_valid_token",
    "title": "valid token acceptance",
    "description": "verify supabase guard accepts a valid jwt",
    "repo_key": "repo3_jkyog_2_0_backend",
    "service_or_module": "supabase.guard",
    "priority": "p0",
    "tags": ["auth", "security"]
  }
]
```

## 4.2 `test_results.json`

Each execution record must include:
1. `test_id`
2. `repo_key`
3. `title`
4. `description`
5. `status` (`passed` | `failed` | `skipped` | `blocked`)
6. `failure_category` (`security_issue` | `code_issue` | `env_issue` | `test_data_issue` | `flake` | `unknown`)
7. `failure_reason`
8. `test_type` (`backend` | `frontend` | `e2e` | `integration` | `unit`)
9. `created_at` (ISO-8601 UTC)
10. `modified_at` (ISO-8601 UTC)

Optional keys:
1. `project_id`
2. `user_id`
3. `code`
4. `artifact_links`
5. `run_id`
6. `commit_sha`
7. `created_from`

Example:

```json
[
  {
    "test_id": "tc01_valid_token",
    "repo_key": "repo3_jkyog_2_0_backend",
    "title": "tc01 valid token acceptance",
    "description": "verify supabase guard accepts a valid jwt token",
    "status": "passed",
    "failure_category": "unknown",
    "failure_reason": "",
    "test_type": "backend",
    "created_at": "2026-02-19T20:49:21Z",
    "modified_at": "2026-02-19T20:49:31Z",
    "artifact_links": {
      "log": "repos/repo3_jkyog_2_0_backend/results/logs/run_20260219_2049.log",
      "report": "repos/repo3_jkyog_2_0_backend/reports/raw_report.md"
    },
    "commit_sha": "abc123def456",
    "run_id": "repo3_20260219_2049_pr_182"
  }
]
```

## 4.3 Markdown Report Interfaces (`.md`)

### 4.3.1 `raw_report.md` Required Section Names
Use these exact headings (same order):
1. `# Regression Raw Report`
2. `## Metadata`
3. `## Execution Summary`
4. `## Requirement Validation Summary`
5. `## Failure Triage`
6. `## Risks and Release Recommendation`
7. `## Action Items`

### 4.3.2 `compiled_report.md` Required Section Names
Use these exact headings (same order):
1. `# Compiled Regression Report`
2. `## Metadata`
3. `## Repository Contribution Summary`
4. `## Global Failure Distribution`
5. `## Critical Findings`
6. `## Regression Risk Posture`
7. `## Follow-up Tracker`

### 4.3.3 Placeholder Ban (Final Reports)
The following are not allowed in final reports:
1. `{{TODO...}}`
2. `TBD`
3. `...` filler rows or unresolved placeholder text
4. empty analysis blocks under required sections

`release_recommendation` values in reports must be one of:
- `go`
- `go_with_risks`
- `no_go`

## 4.4 Python Test Script Interface (`.py`)

### 4.4.1 Filename Rule
- Pattern: `tcNN_<feature>_<scenario>_<target>.py`

### 4.4.2 Required Script Structure
Each test file must include:
1. imports (`requests`, optional `os`, optional `json`)
2. one primary function named `test_tcNN_<short_name>()`
3. explicit request setup (`base_url`, `endpoint`, headers/params/payload as needed)
4. request execution in `try/except requests.RequestException`
5. status assertion using an allowed tuple/list
6. optional response-shape assertion for success scenarios

### 4.4.3 Execution Footer Rule
Use this pattern:

```python
if __name__ == "__main__":
    test_tcNN_<short_name>()
```

Do not use unconditional bottom-level execution calls such as `test_x()` outside `if __name__ == "__main__":`.

### 4.4.4 Security Rule for `.py`
1. Do not hardcode secrets or real tokens in committed test files.
2. Use environment variables or explicit placeholders for secrets.

---

## 5. Delivery Workflow and GitHub Push Rules

## 5.1 Branch, Commit, and PR Naming Rules
- Branch: `test/<engineer>-<repo-key>-regression`
- Commit message: `test(<repo-key>): add/update regression cases for <feature>`
- PR title: `test(<repo-key>): regression coverage for <feature>`

## 5.2 Required PR Body Content
Every PR must include:
1. changed test files list
2. impacted repository list
3. executed suite list
4. pass/fail counts
5. unresolved risks and follow-ups

## 5.3 Required Push Sequence

Run these commands in order:

```bash
# 1) verify current change set
git status

# 2) stage regression artifacts for the affected repo key
git add repos/<repo_key>/testplan/
git add repos/<repo_key>/tests/
git add repos/<repo_key>/reports/raw_report.md
git add repos/<repo_key>/results/test_results.json
git add regression_compiled/latest/

# 3) commit
git commit -m "test(<repo-key>): add/update regression cases for <feature>"

# 4) push branch
git push -u origin test/<engineer>-<repo-key>-regression

# 5) create PR
gh pr create --title "test(<repo-key>): regression coverage for <feature>" --body-file <path-to-pr-body.md>
```

## 5.4 Merge Quality Gate
A PR is merge-eligible only if:
1. full suite for changed repo passed
2. required cross-repo contract/smoke set passed
3. all mandatory `p0`/`security` tests passed
4. `raw_report.md` and `test_results.json` are present and schema-compliant

---

## 6. Regression Execution Policy (Tiered)

### 6.1 On Push to One Repository
Always run:
1. Full regression suite for the changed repository.
2. Mandatory cross-repo integration/contract smoke tests for dependencies touched by the change.

### 6.2 Nightly and Pre-Release
- Run full 4-repository regression compilation.
- Publish compiled outputs to `regression_compiled/latest/`.
- Archive previous compiled outputs into `regression_compiled/history/`.

### 6.3 Security Test Rule
- Tests tagged `security` or marked `p0` are always mandatory, regardless of changed repository.

## 6.4 Cross-Repo Smoke Matrix

When `repo1_jkyog_2_0` changes, run:
- `repo1_jkyog_2_0` full suite
- contracts with `repo3_jkyog_2_0_backend` (auth, user profile, payments)
- content read smoke with `repo4_jkyog_strapi`

When `repo2_radhakrishnatemple2_0` changes, run:
- `repo2_radhakrishnatemple2_0` full suite
- contracts with `repo3_jkyog_2_0_backend` (events, donations, notifications)
- content read smoke with `repo4_jkyog_strapi`

When `repo3_jkyog_2_0_backend` changes, run:
- `repo3_jkyog_2_0_backend` full suite
- consumer contract smoke from `repo1_jkyog_2_0`
- consumer contract smoke from `repo2_radhakrishnatemple2_0`
- webhook/token integration smoke with `repo4_jkyog_strapi` where applicable

When `repo4_jkyog_strapi` changes, run:
- `repo4_jkyog_strapi` full suite
- consumer content smoke in `repo1_jkyog_2_0`
- consumer content smoke in `repo2_radhakrishnatemple2_0`
- dependent webhook/token smoke in `repo3_jkyog_2_0_backend` where applicable

---

## 7. Compilation Requirements for Complete Regression

Compilation is deterministic and must follow this order:

1. Collect `repos/<repo_key>/results/test_results.json` from all 4 repositories.
2. Validate schema; reject malformed records and fail compilation.
3. Normalize identifiers:
   - lowercase all `test_id`
   - enforce `snake_case`
   - normalize legacy keys and timestamps using section 13 mapping
   - normalize `status` and `failure_category` to allowed enums
4. Deduplicate using key: `repo_key + test_id + run_id` (if `run_id` is missing, use `repo_key + test_id + created_at` fallback key).
5. Aggregate outputs into:
   - `regression_compiled/latest/compiled_test_results.json`
   - `regression_compiled/latest/compiled_report.md`
6. `compiled_report.md` must include:
   - totals by status
   - failure distribution by category
   - top unresolved risks
   - per-repository summary
7. Mark run as `complete` only if all 4 repositories submitted required suite results.

---

## 8. Failure Triage and Remediation Rules

For each failed test, classify exactly one `failure_category` and follow this action:

- `security_issue`
  - block merge and release immediately
  - create high-priority defect
  - assign owner and ETA before next pipeline run

- `code_issue`
  - create defect linked to `test_id`, `commit_sha`, and `run_id`
  - include rollback or fix plan

- `env_issue`
  - verify environment and rerun once
  - if still failing, escalate as infrastructure defect

- `test_data_issue`
  - regenerate or correct test fixtures
  - rerun impacted tests

- `flake`
  - rerun to confirm reproducibility
  - quarantine only after repeated non-deterministic failure is proven

- `unknown`
  - assign immediate triage owner
  - classify within one business day

Mandatory: every failed test in `raw_report.md` must include owner and ETA.

---

## 9. Acceptance Criteria for This Manual

`instructions_v2.md` is accepted only if:
1. naming ambiguity is removed (`test_results.json` is canonical)
2. repository ownership of all artifacts is explicit from folder layout
3. push workflow is executable with no tribal knowledge
4. policy clearly states when to test changed repo only vs all 4 repos
5. compilation and triage rules are sufficient for release-grade regression status

---

## 10. Validation Scenarios (Standard Compliance)

1. Existing `test_results.json` with legacy keys (`projectId`, `testId`, `testStatus`) is normalized using section 13 mapping and passes canonical schema checks.
2. Existing `raw_report.md` containing `{{TODO...}}` fails review checklist until placeholders are replaced with real analysis.
3. A `.py` test with direct tail call (`test_x()`) fails style rules; updated `if __name__ == "__main__":` execution footer passes.
4. A report/result entry with `PASS/FAIL` vocabulary is normalized to `passed/failed`.
5. A result record missing `failure_category` is flagged as non-compliant by reviewer checklist.
6. Backend-only feature push triggers backend full suite + cross-repo smoke checks and produces compliant `raw_report.md` + `test_results.json`.
7. Security failure in any repository blocks merge/release and requires high-priority defect creation.
8. Nightly run is marked `complete` only when all 4 repositories submit required suite outputs.

---

## 11. Assumptions and Defaults

1. Team keeps four-repository scope for this version.
2. Existing `instructions.md` remains as legacy reference.
3. `instructions_v2.md` is the governing standard for new regression runs.
4. BYR is not part of this system and is excluded from all artifact standards.
5. Supported artifact types are only `.json`, `.md`, and `.py`.
6. Markdown is semi-structured: required headings/fields are fixed, prose wording is flexible.
7. JSON and Python structures are stricter than Markdown for consistency and compilation.
8. Enforcement is manual checklist-based in this phase (no CI hard gate).
9. All timestamps use ISO-8601 UTC.

---

## 12. Artifact Authoring Templates (`.json`, `.md`, `.py`)

Use these as copy-paste starting points. Required keys/headings must remain unchanged.

## 12.1 Template: `testsprite_<repo_key>_testplan.json`

```json
[
  {
    "id": "tc01_valid_token",
    "title": "valid token acceptance",
    "description": "verify supabase guard accepts a valid token",
    "repo_key": "repo3_jkyog_2_0_backend",
    "service_or_module": "supabase.guard",
    "priority": "p0",
    "tags": ["auth", "security"],
    "method": "GET",
    "endpoint": "/api/user/get-account-details",
    "expected_status": [200, 404],
    "notes": "401 is not acceptable for this valid-token scenario"
  }
]
```

## 12.2 Template: `test_results.json`

```json
[
  {
    "test_id": "tc01_valid_token",
    "repo_key": "repo3_jkyog_2_0_backend",
    "title": "valid token acceptance",
    "description": "verify supabase guard accepts a valid token",
    "status": "passed",
    "failure_category": "unknown",
    "failure_reason": "",
    "test_type": "backend",
    "created_at": "2026-02-19T20:49:21Z",
    "modified_at": "2026-02-19T20:49:31Z",
    "project_id": "optional-project-id",
    "user_id": "optional-user-id",
    "code": "optional-inline-test-code-or-reference",
    "artifact_links": {
      "log": "repos/repo3_jkyog_2_0_backend/results/logs/tc01.log",
      "report": "repos/repo3_jkyog_2_0_backend/reports/raw_report.md"
    },
    "run_id": "repo3_20260219_2049_pr_182",
    "commit_sha": "abc123def456",
    "created_from": "mcp"
  }
]
```

## 12.3 Template: `raw_report.md`

```markdown
# Regression Raw Report

## Metadata
- repo_key: repo3_jkyog_2_0_backend
- repository: 3_JKYog_2.0_backend
- branch: test/<engineer>-repo3_jkyog_2_0_backend-regression
- commit_sha: <commit_sha>
- run_id: <run_id>
- executed_at_utc: 2026-02-19T20:50:00Z
- author: <engineer_name>

## Execution Summary
| metric | value |
|---|---|
| planned_tests | 10 |
| executed_tests | 10 |
| passed | 9 |
| failed | 1 |
| skipped | 0 |
| blocked | 0 |
| pass_rate_percent | 90.00 |

## Requirement Validation Summary
| test_id | title | status | failure_category | evidence_link | notes |
|---|---|---|---|---|---|
| tc01_valid_token | valid token acceptance | passed | unknown | ./results/logs/tc01.log | validated 200/404 behavior |
| tc02_invalid_token | invalid token rejection | failed | security_issue | ./results/logs/tc02.log | returned 200 unexpectedly |

## Failure Triage
### security_issue
| test_id | root_cause_hypothesis | owner | eta_utc | next_action |
|---|---|---|---|---|
| tc02_invalid_token | guard bypass in token validation path | backend_owner | 2026-02-20T18:00:00Z | patch guard logic and rerun |

### code_issue
No findings.

### env_issue
No findings.

### test_data_issue
No findings.

### flake
No findings.

### unknown
No findings.

## Risks and Release Recommendation
- top_risks:
  - invalid token path not enforcing unauthorized response
- release_recommendation: no_go
- justification: unresolved security failure in auth guard flow

## Action Items
| item_id | description | owner | eta_utc | status |
|---|---|---|---|---|
| A-001 | fix invalid-token guard handling | backend_owner | 2026-02-20T18:00:00Z | open |
| A-002 | rerun auth regression subset | qa_owner | 2026-02-20T21:00:00Z | open |
```

## 12.4 Template: `compiled_report.md`

```markdown
# Compiled Regression Report

## Metadata
- compiled_run_id: compiled_2026-02-20_nightly
- compiled_at_utc: 2026-02-20T06:00:00Z
- source_run_ids:
  - repo1_20260220_0100
  - repo2_20260220_0130
  - repo3_20260220_0200
  - repo4_20260220_0230
- compiler: qa_release_coordinator

## Repository Contribution Summary
| repo_key | planned | executed | passed | failed | blocked | pass_rate_percent |
|---|---:|---:|---:|---:|---:|---:|
| repo1_jkyog_2_0 | 80 | 80 | 79 | 1 | 0 | 98.75 |
| repo2_radhakrishnatemple2_0 | 70 | 70 | 70 | 0 | 0 | 100.00 |
| repo3_jkyog_2_0_backend | 90 | 90 | 88 | 2 | 0 | 97.78 |
| repo4_jkyog_strapi | 60 | 60 | 60 | 0 | 0 | 100.00 |

## Global Failure Distribution
| failure_category | count | repos_impacted |
|---|---:|---|
| security_issue | 1 | repo3_jkyog_2_0_backend |
| code_issue | 1 | repo1_jkyog_2_0 |
| env_issue | 0 | none |
| test_data_issue | 0 | none |
| flake | 1 | repo3_jkyog_2_0_backend |
| unknown | 0 | none |

## Critical Findings
- security_issue in repo3_jkyog_2_0_backend for invalid-token rejection path.
- unresolved p0 finding blocks release.

## Regression Risk Posture
- overall_recommendation: no_go
- blocking_issues:
  - security_issue in repo3_jkyog_2_0_backend
- non_blocking_risks:
  - one flaky test under retry analysis

## Follow-up Tracker
| issue_ref | repo_key | owner | eta_utc | state |
|---|---|---|---|---|
| SEC-221 | repo3_jkyog_2_0_backend | backend_owner | 2026-02-20T18:00:00Z | open |
| QA-178 | repo3_jkyog_2_0_backend | qa_owner | 2026-02-20T21:00:00Z | open |
```

## 12.5 Template: `tcNN_<feature>_<scenario>_<target>.py`

```python
import os
import requests


def test_tc01_valid_token_acceptance():
    base_url = os.getenv("BASE_URL", "http://localhost:3000")
    endpoint = "/api/user/get-account-details"
    url = f"{base_url}{endpoint}"

    token = os.getenv("TEST_AUTH_TOKEN", "REPLACE_WITH_TEST_TOKEN")
    headers = {"Authorization": f"Bearer {token}"}

    try:
        response = requests.get(url, headers=headers, timeout=30)
    except requests.RequestException as exc:
        assert False, f"Request failed: {exc}"

    assert response.status_code in (200, 404), (
        f"Unexpected status: {response.status_code}, body: {response.text}"
    )

    if response.status_code == 200:
        payload = response.json()
        assert isinstance(payload, dict), "Expected object response payload"


if __name__ == "__main__":
    test_tc01_valid_token_acceptance()
```

---

## 13. Normalization Rules

## 13.1 Legacy Key Mapping (`test_results.json`)

| Legacy Key | Canonical Key |
|---|---|
| `projectId` | `project_id` |
| `testId` | `test_id` |
| `userId` | `user_id` |
| `testStatus` | `status` |
| `testError` | `failure_reason` |
| `testType` | `test_type` |
| `createFrom` | `created_from` |
| `created` | `created_at` |
| `modified` | `modified_at` |

## 13.2 Enum Normalization

### `status` mapping
- `PASSED` -> `passed`
- `FAILED` -> `failed`
- `SKIPPED` -> `skipped`
- `BLOCKED` -> `blocked`
- `PASS` -> `passed`
- `FAIL` -> `failed`

### `failure_category` allowed values
- `security_issue`
- `code_issue`
- `env_issue`
- `test_data_issue`
- `flake`
- `unknown`

If legacy values exist, map conservatively:
- `infra` or `environment` -> `env_issue`
- `data` -> `test_data_issue`
- `security` -> `security_issue`
- unmapped values -> `unknown`

## 13.3 Timestamp Normalization
1. Convert `created` to `created_at`.
2. Convert `modified` to `modified_at`.
3. Ensure output timestamps are ISO-8601 UTC (`YYYY-MM-DDTHH:MM:SSZ`).
4. If timezone is missing in legacy input, treat source value as UTC and append `Z`.

---

## 14. Reviewer Checklist (Manual Enforcement)

Every regression PR must include this checklist in the PR body:

- [ ] only `.json`, `.md`, and `.py` artifacts are introduced/updated for regression deliverables
- [ ] filenames follow canonical `snake_case` rules
- [ ] `testsprite_<repo_key>_testplan.json` includes all required keys
- [ ] `test_results.json` includes all required canonical keys
- [ ] legacy keys/enums were normalized where applicable
- [ ] `raw_report.md` uses all required section headings in required order
- [ ] `compiled_report.md` uses all required section headings in required order (for nightly/pre-release compilation runs)
- [ ] no placeholders remain (`{{TODO...}}`, `TBD`, filler `...`, or empty analysis blocks)
- [ ] failed tests include owner + ETA + next action in triage/action sections
- [ ] release recommendation is explicitly stated (`go`, `go_with_risks`, or `no_go`)
