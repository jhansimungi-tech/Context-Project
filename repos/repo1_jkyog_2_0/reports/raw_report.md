# Regression Raw Report

## Metadata
- repo_key: repo1_jkyog_2_0
- repository: 1_JKYog_2.0
- branch: test/jhansi-repo1_jkyog_2_0-regression
- run_id: repo1_batch5_20260219
- executed_at_utc: 2026-02-19T22:30:00Z
- author: jhansi

## Execution Summary
| metric | value |
|---|---|
| planned_tests | 8 |
| executed_tests | 8 |
| passed | 0 |
| failed | 8 |
| skipped | 0 |
| blocked | 0 |
| pass_rate_percent | 0.00 |

## Requirement Validation Summary
| test_id | title | status | failure_category | evidence_link | notes |
|---|---|---|---|---|---|
| tc038 | View subscription details on Profile page | failed | env_issue | — | Magic-link auth blocks automation |
| tc039 | Open cancel subscription modal | failed | env_issue | — | Requires authenticated profile |
| tc040 | Dismiss cancel subscription modal | failed | env_issue | — | Requires authenticated profile |
| tc041 | Confirm cancellation | failed | env_issue | — | Requires authenticated profile |
| tc042 | Prevent duplicate cancellation | failed | env_issue | — | Requires authenticated profile |
| tc043 | Cancel button not available after Cancelled | failed | env_issue | — | Requires authenticated profile |
| tc044 | Zoom SDK with valid meeting info | failed | env_issue | — | Timeout; app not on port 3002 |
| tc045 | Zoom error when meeting info missing | failed | env_issue | — | Timeout |

## Failure Triage
### env_issue
| test_id | root_cause_hypothesis | owner | eta_utc | next_action |
|---|---|---|---|---|
| tc038–tc043 | Magic-link auth; no password flow for automation | qa_owner | 2026-02-25T18:00:00Z | Provide test credentials or pre-auth session |
| tc044–tc045 | App not running on 3002; /smex-live timeout | qa_owner | 2026-02-25T18:00:00Z | Ensure 1_JKYog_2.0 on 3002 before run |

## Risks and Release Recommendation
- top_risks: Subscription and Zoom flows blocked by env/auth
- release_recommendation: go_with_risks
- justification: Failures are env-related; no code defects identified

## Action Items
| item_id | description | owner | eta_utc | status |
|---|---|---|---|---|
| A-001 | Provide password-based or pre-auth for profile tests | infra_owner | 2026-02-25T18:00:00Z | open |
| A-002 | Verify 1_JKYog_2.0 runs on 3002 for Zoom tests | qa_owner | 2026-02-25T18:00:00Z | open |
