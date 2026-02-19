# Regression Raw Report

## Metadata
- repo_key: repo3_jkyog_2_0_backend
- repository: 3_JKYog_2.0_backend
- branch: test/jhansi-repo3_jkyog_2_0_backend-regression
- run_id: repo3_tc046_20260219
- executed_at_utc: 2026-02-19T22:35:00Z
- author: jhansi

## Execution Summary
| metric | value |
|---|---|
| planned_tests | 1 |
| executed_tests | 1 |
| passed | 0 |
| failed | 1 |
| skipped | 0 |
| blocked | 0 |
| pass_rate_percent | 0.00 |

## Requirement Validation Summary
| test_id | title | status | failure_category | evidence_link | notes |
|---|---|---|---|---|---|
| tc46 | PUT update-account-details rejects without Bearer token | failed | env_issue | — | Expected 401, got 500 |

## Failure Triage
### env_issue
| test_id | root_cause_hypothesis | owner | eta_utc | next_action |
|---|---|---|---|---|
| tc46 | Backend returned 500; possible DB/env misconfiguration | backend_owner | 2026-02-25T18:00:00Z | Verify backend runs; ensure 401 for unauthenticated |

## Risks and Release Recommendation
- top_risks: CSRF/auth rejection path returns 500 instead of 401
- release_recommendation: go_with_risks
- justification: Single backend test; 500 suggests env, not necessarily code defect

## Action Items
| item_id | description | owner | eta_utc | status |
|---|---|---|---|---|
| A-001 | Verify backend returns 401 for unauthenticated PUT | backend_owner | 2026-02-25T18:00:00Z | open |
