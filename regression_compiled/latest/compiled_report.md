# Compiled Regression Report

## Metadata
- compiled_run_id: compiled_2026-02-19_migration
- compiled_at_utc: 2026-02-19T23:00:00Z
- source_run_ids:
  - repo2_batch1_20260219
  - repo2_batch2_20260219
  - repo2_batch3_20260219
  - repo2_batch4_20260219
  - repo1_batch5_20260219
  - repo3_tc046_20260219
- compiler: jhansi

## Repository Contribution Summary
| repo_key | planned | executed | passed | failed | blocked | pass_rate_percent |
|---|---:|---:|---:|---:|---:|---:|
| repo1_jkyog_2_0 | 8 | 8 | 0 | 8 | 0 | 0.00 |
| repo2_radhakrishnatemple2_0 | 37 | 37 | 16 | 21 | 0 | 43.24 |
| repo3_jkyog_2_0_backend | 1 | 1 | 0 | 1 | 0 | 0.00 |
| repo4_jkyog_strapi | 0 | 0 | 0 | 0 | 0 | — |

## Global Failure Distribution
| failure_category | count | repos_impacted |
|---|---:|---|
| security_issue | 0 | none |
| code_issue | 0 | none |
| env_issue | 30 | repo1_jkyog_2_0, repo2_radhakrishnatemple2_0, repo3_jkyog_2_0_backend |
| test_data_issue | 0 | none |
| flake | 0 | none |
| unknown | 0 | none |

## Critical Findings
- Donation page (repo2): Backend/API for Seva opportunities not reachable — stepper UI never renders.
- Subscription & Profile (repo1): Magic-link auth blocks automation; no password-based test flow.
- Zoom (repo1): App not on port 3002; navigation timeout to /smex-live.
- Backend CSRF (repo3): PUT update-account-details returned 500 instead of 401 for unauthenticated request.
- Puja Payment (repo2): Sponsorship section and empty-state messages not found on page.
- Ticket Booking (repo2): Fixed date range (11-day pass); no editable date input for test scenarios.

## Regression Risk Posture
- overall_recommendation: go_with_risks
- blocking_issues: none (no confirmed code defects)
- non_blocking_risks: env_issue dominates; auth, backend/API availability, port configuration

## Follow-up Tracker
| issue_ref | repo_key | owner | eta_utc | state |
|---|---|---|---|---|
| A-001 | repo1_jkyog_2_0 | infra_owner | 2026-02-25T18:00:00Z | open |
| A-002 | repo1_jkyog_2_0 | qa_owner | 2026-02-25T18:00:00Z | open |
| A-003 | repo2_radhakrishnatemple2_0 | infra_owner | 2026-02-25T18:00:00Z | open |
| A-004 | repo3_jkyog_2_0_backend | backend_owner | 2026-02-25T18:00:00Z | open |
