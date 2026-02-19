# test: regression coverage — v2 layout migration

## Changed test files list

### repo2_radhakrishnatemple2_0
- `repos/repo2_radhakrishnatemple2_0/tests/tc001_*` … `tc037_*` (37 files, snake_case)

### repo1_jkyog_2_0
- `repos/repo1_jkyog_2_0/tests/tc038_*` … `tc045_*` (8 files, snake_case)

### repo3_jkyog_2_0_backend
- `repos/repo3_jkyog_2_0_backend/tests/tc46_put_update_account_details_rejects_without_bearer_token_user_controller.py`

---

## Impacted repository list

| repo_key | repository |
|----------|------------|
| repo1_jkyog_2_0 | 1_JKYog_2.0 |
| repo2_radhakrishnatemple2_0 | 2_radhakrishnatemple2.0 |
| repo3_jkyog_2_0_backend | 3_JKYog_2.0_backend |

---

## Executed suite list

| repo_key | suite | batches |
|----------|-------|---------|
| repo2_radhakrishnatemple2_0 | Frontend (TC001–TC037) | batch_1–batch_4 |
| repo1_jkyog_2_0 | Profile, Subscription, Zoom (TC038–TC045) | batch_4, batch_5 |
| repo3_jkyog_2_0_backend | PUT update-account-details (TC046) | batch_5 |

---

## Pass/fail counts

| repo_key | planned | executed | passed | failed | pass_rate |
|----------|---------|----------|--------|--------|-----------|
| repo1_jkyog_2_0 | 8 | 8 | 0 | 8 | 0% |
| repo2_radhakrishnatemple2_0 | 37 | 37 | 16 | 21 | 43.24% |
| repo3_jkyog_2_0_backend | 1 | 1 | 0 | 1 | 0% |
| **Total** | **46** | **46** | **16** | **30** | **34.8%** |

---

## Unresolved risks and follow-ups

- **Donation page (repo2):** Backend/API for Seva opportunities not reachable; stepper UI never renders.
- **Subscription & Profile (repo1):** Magic-link auth blocks automation; no password-based test flow.
- **Zoom (repo1):** App not on port 3002; navigation timeout to `/smex-live`.
- **Backend CSRF (repo3):** PUT `update-account-details` returns 500 instead of 401 for unauthenticated request.
- **Puja Payment (repo2):** Sponsorship section and empty-state messages not found.
- **Ticket Booking (repo2):** Fixed date range; no editable date input for tests.

**Release recommendation:** `go_with_risks` (no confirmed code defects; env/auth/config issues dominate)

---

*Per `testing/instructions_v2.md` §5.2*
