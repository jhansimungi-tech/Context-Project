# Mission: Kanan — Identity & Notification

## Zero-Generic Policy
- Every scenario must cite an exact controller/service file and function.
- No generic wording like "test auth" or "test API".

## Reference Documentation
- [Architectural Context](../docs/00-context.md)
- [Repo Setup](../docs/01-setup.md)

## Mandatory Backend Targets
- Auth Guards (JWT/Token validation):
  - `3_JKYog_2.0_backend/src/supabase/supabase.guard.ts::SupabaseGuard`
  - `3_JKYog_2.0_backend/src/supabase/supabase.strategy.ts::SupabaseStrategy`
  - `3_JKYog_2.0_backend/src/common/guards/api-token.guard.ts::ApiTokenGuard`
  - `3_JKYog_2.0_backend/src/common/guards/admin-email.guard.ts::AdminEmailGuard`
- JWT Service:
  - `3_JKYog_2.0_backend/src/jwt/jwt.service.ts::JwtService`
- UserController me/update:
  - `3_JKYog_2.0_backend/src/user/user.controller.ts::getAccountDetails`
  - `3_JKYog_2.0_backend/src/user/user.controller.ts::updateAccountDetails`
- NotificationService email triggers:
  - `3_JKYog_2.0_backend/src/notification/notification.service.ts::sendNotifications`
  - `3_JKYog_2.0_backend/src/notification/notification.service.ts::handleSendNotificationsJob`

## Remediated Scenarios
| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 1 | Verify `SupabaseGuard` accepts a valid Supabase JWT Bearer token and attaches the authenticated `CurrentUserDto` (userId, supabaseUserId, email) to the request object. | `3_JKYog_2.0_backend/src/supabase/supabase.guard.ts::SupabaseGuard`, `3_JKYog_2.0_backend/src/supabase/supabase.strategy.ts::validate` |
| 2 | Verify `SupabaseGuard` rejects an invalid/expired JWT token with 401 Unauthorized and does not attach a user to the request. | `3_JKYog_2.0_backend/src/supabase/supabase.guard.ts::SupabaseGuard` |
| 3 | Verify `JwtService.verifyToken` returns a valid `TokenPayload` (sub, email, role) for a correctly signed Supabase JWT. | `3_JKYog_2.0_backend/src/jwt/jwt.service.ts::verifyToken` |
| 4 | Verify `JwtService.verifyToken` throws `BadRequestException` for an invalid or tampered token string. | `3_JKYog_2.0_backend/src/jwt/jwt.service.ts::verifyToken` |
| 5 | Verify `/user/get-account-details` returns authenticated user profile with optional avatar flag handling. | `3_JKYog_2.0_backend/src/user/user.controller.ts::getAccountDetails` |
| 6 | Verify `/user/update-account-details` persists DTO updates and enforces DTO-level validation. | `3_JKYog_2.0_backend/src/user/user.controller.ts::updateAccountDetails` |
| 7 | Verify `link-fcm-token` path associates FCM token to the current user identity. | `3_JKYog_2.0_backend/src/user/user.controller.ts::linkFCMToken` |
| 8 | Verify CSV validation in notification dispatch rejects missing `EMAIL`/`SMS` columns before queuing jobs. | `3_JKYog_2.0_backend/src/notification/notification.service.ts::validateCsvOnSendNotifications` |
| 9 | Verify notification job processing triggers registration confirmation emails when `sendEmail=true`. | `3_JKYog_2.0_backend/src/notification/notification.service.ts::handleSendNotificationsJob` |
| 10 | Verify email trigger path builds and sends event registration confirmation via Postmark client. | `3_JKYog_2.0_backend/src/email/email.service.ts::sendEventRegistrationConfirmationEmail` |

### Remediated Scenarios (Gap Analysis)
> Source: `09-quality-reports/coverage-gap-analysis.md` | Categories: Integration Failure, Security, Data Integrity, Race Conditions

| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 11 | Verify `sendEventRegistrationConfirmationEmail` handles Postmark `ServerClient` timeout/5xx by catching the error and re-throwing, ensuring the caller receives the failure signal. | `3_JKYog_2.0_backend/src/email/email.service.ts::sendEventRegistrationConfirmationEmail` |
| 12 | Verify two concurrent `SupabaseStrategy.validate()` calls with the same email (first-time login) do not create duplicate user records — second call returns the existing user or is serialized. | `3_JKYog_2.0_backend/src/supabase/supabase.strategy.ts::validate` |
| 13 | Verify two concurrent `updateAccountDetails` calls for the same `userId` with different `firstName` values result in a consistent final state (last-write-wins without data corruption). | `3_JKYog_2.0_backend/src/user/user.controller.ts::updateAccountDetails` |
| 14 | Verify `linkFCMToken` rejects or handles gracefully when the same FCM token string is linked to two different user IDs concurrently. | `3_JKYog_2.0_backend/src/user/user.controller.ts::linkFCMToken` |
| 15 | Verify `sendNotificationsQueueService.addSendNotificationsJobs` handles queue overflow by returning an error or backpressure signal when the BullMQ queue depth exceeds a configured threshold. | `3_JKYog_2.0_backend/src/notification/notification.service.ts::sendNotifications` |
| 16 | Verify `ApiTokenGuard` rejects requests with missing or invalid API token in the Authorization header — returns 403 `INVALID_API_TOKEN` error. | `3_JKYog_2.0_backend/src/common/guards/api-token.guard.ts::canActivate` |
| 17 | **[SECURITY CRITICAL]** Verify `SupabaseStrategy.validate()` auto-creates new users with `userType: REGISTERED` only — a crafted JWT payload with elevated role claims does not result in admin-level user creation or privilege escalation. | `3_JKYog_2.0_backend/src/supabase/supabase.strategy.ts::validate` |
| 18 | Verify `/user/get-account-details` always returns only the JWT-authenticated user's own data and cannot be manipulated to return another user's profile via query parameter tampering (IDOR). | `3_JKYog_2.0_backend/src/user/user.controller.ts::getAccountDetails`, `3_JKYog_2.0_backend/src/user/user.controller.ts::getDuplicates` |

## TestSprite Prompt Strategy
```text
Act as a Senior SDET. Read ../docs/00-context.md.

Analyze [Specific File Name].

Generate 5 E2E Playwright/Cypress test cases covering:

Happy Path (Success).

Validation Errors (Empty/Invalid inputs).

Network Errors (Simulate offline/timeout).

Edge Cases (Max length, special chars).

Output the code for [Testing Framework].
```

### TestSprite Prompt Additions (Gap Analysis)
```text
Act as a Senior SDET. Read ../docs/00-context.md.

For 3_JKYog_2.0_backend/src/email/email.service.ts — generate 1 test case:
1. Mock Postmark ServerClient.sendEmailWithTemplate to throw { statusCode: 503, message: 'Service Unavailable' }; assert the error propagates and the method does not silently succeed.

For 3_JKYog_2.0_backend/src/supabase/supabase.strategy.ts — generate 3 test cases:
1. Fire two concurrent requests with valid JWTs containing the same email (new user); assert only one user record exists in the database afterward.
2. [SECURITY CRITICAL] Craft a JWT with payload containing role='admin' or user_metadata.is_admin=true; call a SupabaseGuard-protected endpoint; assert the created user has userType=REGISTERED (not elevated).
3. Send a request with a JWT containing an email that exists in the database but has no supabaseUserId; assert the strategy links the Supabase ID to the existing user without creating a duplicate.

For 3_JKYog_2.0_backend/src/common/guards/api-token.guard.ts — generate 2 test cases:
1. Call an ApiTokenGuard-protected endpoint with no Authorization header; assert 403 Forbidden.
2. Call an ApiTokenGuard-protected endpoint with Authorization='WRONG_TOKEN'; assert 403 with INVALID_API_TOKEN error code.

For 3_JKYog_2.0_backend/src/user/user.controller.ts — generate 3 test cases:
1. Fire two concurrent PUT /user/update-account-details requests with different firstName values; assert no 500 error and the final record has one consistent firstName.
2. Fire two concurrent PATCH /user/link-fcm-token requests with the same token but different userId; assert the token is associated with exactly one user.
3. Authenticate as User A, call GET /user/get-account-details with an additional query param userId=USER_B_ID — assert the response contains only User A's data (IDOR test).

For 3_JKYog_2.0_backend/src/notification/notification.service.ts — generate 1 test case:
1. Mock sendNotificationsQueueService to reject when queue depth exceeds limit; assert sendNotifications returns an error or logs the overflow condition.

Simulate Offline Mode and Simulate API Errors for Postmark, auth guard, and notification endpoints.

Output the code for Jest + Supertest.
```

---

## Phase 2 — Regression Expansion

### Phase 2 Mandatory Targets
- Unguarded Endpoints (P0 Security):
  - `3_JKYog_2.0_backend/src/event/event.controller.ts::getSmexJoinedParticipants`
  - `3_JKYog_2.0_backend/src/event-registration/event-registration.controller.ts::getUserEventRegistrationTest`
- OptionalSupabaseGuard:
  - `3_JKYog_2.0_backend/src/supabase/optional-supabase.guard.ts::OptionalSupabaseGuard`
- AdminEmailGuard:
  - `3_JKYog_2.0_backend/src/common/guards/admin-email.guard.ts::AdminEmailGuard`
- StrapiGuard (Webhook Token):
  - `3_JKYog_2.0_backend/src/strapi/strapi.guard.ts::StrapiGuard`
- Family Member CRUD:
  - `3_JKYog_2.0_backend/src/family-member/family-member.controller.ts`
- Twilio SMS Integration:
  - `3_JKYog_2.0_backend/src/notification/notification.service.ts`
- Brevo Newsletter Integration:
  - `3_JKYog_2.0_backend/src/app.controller.ts` (Brevo/Sendinblue paths)
- Environment Config Validation:
  - `3_JKYog_2.0_backend/src/config/`

### Phase 2 Scenarios
| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 19 | **[P0 SECURITY]** Verify `GET /api/event/smex-joined-participants/:eventId` is NOT accessible without `ApiTokenGuard` — unauthenticated requests must return 401/403, not participant data. | `3_JKYog_2.0_backend/src/event/event.controller.ts::getSmexJoinedParticipants` |
| 20 | **[P0 SECURITY]** Verify the deprecated test endpoint `GET /api/event-registration/get-user-event-registration-test/:eventUuid/user/:userId` returns 404 or 403 — it must not leak registration data without authentication. | `3_JKYog_2.0_backend/src/event-registration/event-registration.controller.ts::getUserEventRegistrationTest` |
| 21 | Verify `OptionalSupabaseGuard` returns `true` even when no token is provided — the request proceeds but `request.user` is undefined. | `3_JKYog_2.0_backend/src/supabase/optional-supabase.guard.ts::canActivate` |
| 22 | Verify `AdminEmailGuard` accepts requests with `x-user-email` header matching a volunteer with `isSuperAdmin=true` and rejects all others with `UnauthorizedException`. | `3_JKYog_2.0_backend/src/common/guards/admin-email.guard.ts::canActivate` |
| 23 | Verify `StrapiGuard` accepts requests with correct `STRAPI_WEBHOOK_TOKEN` in Authorization header and rejects invalid tokens with 403 `INVALID_TOKEN`. | `3_JKYog_2.0_backend/src/strapi/strapi.guard.ts::canActivate` |
| 24 | Verify `POST /api/family-member/create-family-member` creates a family member record linked to the authenticated user and returns the new entity. | `3_JKYog_2.0_backend/src/family-member/family-member.controller.ts::createFamilyMember` |
| 25 | Verify `PUT /api/family-member/update-family-member` updates fields and rejects requests for family members not owned by the authenticated user (IDOR). | `3_JKYog_2.0_backend/src/family-member/family-member.controller.ts::updateFamilyMember` |
| 26 | Verify `DELETE /api/family-member/delete-family-member/:familyMemberId` removes the record and returns 404 on subsequent GET for the same ID. | `3_JKYog_2.0_backend/src/family-member/family-member.controller.ts::deleteFamilyMember` |
| 27 | Verify SMS notification dispatch via Twilio sends to valid phone numbers and handles Twilio API errors (invalid number, rate limit) gracefully without crashing the job queue. | `3_JKYog_2.0_backend/src/notification/notification.service.ts::handleSendNotificationsJob` |
| 28 | Verify Brevo `subscribe-to-newsletter` endpoint adds the email to the Brevo contact list and returns success; duplicate email does not throw. | `3_JKYog_2.0_backend/src/app.controller.ts::subscribeToNewsletter` |
| 29 | Verify Brevo `subscribe-to-videos` endpoint adds the email to the video subscriber list and returns success. | `3_JKYog_2.0_backend/src/app.controller.ts::subscribeToVideos` |
| 30 | Verify backend startup fails gracefully (throws descriptive error, does not hang) when critical environment variables (`SUPABASE_URL`, `STRIPE_API_KEY`, `DATABASE_HOST`) are missing. | `3_JKYog_2.0_backend/src/config/` |

### TestSprite Prompt for Phase 2
```text
Act as a Senior SDET. Read ../docs/00-context.md.

For 3_JKYog_2.0_backend/src/event/event.controller.ts — generate 1 test case:
1. Send GET /api/event/smex-joined-participants/ANY_EVENT_ID without any Authorization header or API token; assert 401 or 403 (not 200 with data).

For 3_JKYog_2.0_backend/src/event-registration/event-registration.controller.ts — generate 1 test case:
1. Send GET /api/event-registration/get-user-event-registration-test/ANY_UUID/user/ANY_USER_ID without auth; assert 404 or 403.

For 3_JKYog_2.0_backend/src/supabase/optional-supabase.guard.ts — generate 1 test case:
1. Call an OptionalSupabaseGuard-protected endpoint without a token; assert 200 and request.user is undefined.

For 3_JKYog_2.0_backend/src/common/guards/admin-email.guard.ts — generate 2 test cases:
1. Send request with x-user-email matching a superAdmin volunteer; assert 200.
2. Send request with x-user-email of a non-admin user; assert UnauthorizedException.

For 3_JKYog_2.0_backend/src/strapi/strapi.guard.ts — generate 1 test case:
1. Call a StrapiGuard-protected endpoint with correct webhook token; assert 200. Call with wrong token; assert 403.

For 3_JKYog_2.0_backend/src/family-member/family-member.controller.ts — generate 3 test cases:
1. Authenticate as User A; POST /api/family-member/create-family-member with valid DTO; assert 201 and familyMemberId returned.
2. Authenticate as User A; PUT /api/family-member/update-family-member with familyMemberId belonging to User B; assert 403.
3. Authenticate as User A; DELETE /api/family-member/delete-family-member/:id; assert 200; GET same ID; assert 404.

For notification service (Twilio) — generate 1 test case:
1. Mock Twilio client to throw { code: 21211, message: 'Invalid phone number' }; assert the job logs the error and does not crash the BullMQ worker.

For Brevo integration — generate 2 test cases:
1. POST /api/subscribe-to-newsletter with valid email; assert 200 and Brevo contact creation.
2. POST /api/subscribe-to-newsletter with duplicate email; assert 200 (no error thrown).

Output the code for Jest + Supertest.
```

## Deliverable
- [ ] Completed test files committed to the `testing/` directory.
- [ ] Each scenario from the Remediated Scenarios table covered by at least one test case.
- [ ] Each scenario from the Remediated Scenarios (Gap Analysis) table covered by at least one test case.
- [ ] **[SECURITY]** Scenario 17 (Privilege Escalation via JWT) test MUST exist and verify no admin-level user creation.
- [ ] **[P0 SECURITY]** Scenarios 19-20 (Unguarded Endpoints) tests MUST verify auth enforcement.
- [ ] Each Phase 2 scenario (19-30) covered by at least one test case.
- [ ] All tests pass locally before submission.
