# Mission: Manasi — Payments & Class Platform

## Zero-Generic Policy
- Every scenario must cite an exact controller/service/schema file and callable path.
- No generic wording like "test webhook" or "test class API".

## Reference Documentation
- [Architectural Context](../docs/00-context.md)
- [Repo Setup](../docs/01-setup.md)

## Mandatory Backend Targets
- PaymentController `createIntent` (implementation mapping):
  - `3_JKYog_2.0_backend/src/payment/payment.controller.ts::createDonationPayment`
  - `3_JKYog_2.0_backend/src/stripe/stripe.service.ts::createPaymentIntent`
- DonationController `webhook` (implementation mapping):
  - `3_JKYog_2.0_backend/src/stripe/stripe.controller.ts::handleWebhook`
  - `3_JKYog_2.0_backend/src/paypal/paypal.controller.ts::webhookHandler`
- ClassController CRUD (implementation mapping):
  - `4_JKYog_Strapi/src/api/online-class/routes/online-class.js::createCoreRouter('api::online-class.online-class')`

## Remediated Scenarios
| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 1 | Verify payment creation endpoint accepts valid donation DTO and returns checkout payload. | `3_JKYog_2.0_backend/src/payment/payment.controller.ts::createDonationPayment` |
| 2 | Verify `createDonationPayment` routes Stripe requests to `createPaymentIntent` with donor metadata. | `3_JKYog_2.0_backend/src/payment/payment.service.ts::createDonationPayment` |
| 3 | Verify Stripe branch includes comment-key fallback for long comments and truncates metadata safely. | `3_JKYog_2.0_backend/src/payment/payment.service.ts::createDonationPayment` |
| 4 | Verify PayPal branch returns `approvalUrl` from PayPal links list for donation flow. | `3_JKYog_2.0_backend/src/payment/payment.service.ts::createDonationPayment` |
| 5 | Verify donation webhook processing handles `payment_intent.succeeded` and returns HTTP 200 on success. | `3_JKYog_2.0_backend/src/stripe/stripe.service.ts::handleWebhook` |
| 6 | Verify Stripe webhook rejects invalid signature with HTTP 400 and explicit error body. | `3_JKYog_2.0_backend/src/stripe/stripe.service.ts::handleWebhook` |
| 7 | Verify PayPal webhook handler accepts provider headers/body and forwards to service layer. | `3_JKYog_2.0_backend/src/paypal/paypal.controller.ts::webhookHandler` |
| 8 | Verify class CRUD endpoints (`find`, `findOne`, `create`, `update`, `delete`) are exposed by Strapi core router. | `4_JKYog_Strapi/src/api/online-class/routes/online-class.js` |
| 9 | Verify class controller custom route returns total count and 500 error branch on query failure. | `4_JKYog_Strapi/src/api/online-class/controllers/online-class.js::countOnly` |
| 10 | Verify online class schema enforces `Title` length, `Logo` required media, and `ZoomMeetingUrl` required rule. | `4_JKYog_Strapi/src/api/online-class/content-types/online-class/schema.json` |

### Remediated Scenarios (Gap Analysis)
> Source: `09-quality-reports/coverage-gap-analysis.md` | Categories: Integration Failure, Data Integrity, Race Conditions

| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 11 | Verify `createPaymentIntent` rejects when Stripe returns `card_declined` error and the service propagates the exception with HTTP 402 status to the caller. | `3_JKYog_2.0_backend/src/stripe/stripe.service.ts::createPaymentIntent` |
| 12 | Verify PayPal `createPayment` handles API timeout/network error by catching the rejected promise and throwing `BadRequestException` with the upstream error payload. | `3_JKYog_2.0_backend/src/paypal/paypal.service.ts::createPayment` |
| 13 | Verify Stripe webhook idempotency: when `handlePaymentIntentSucceededEvent` receives a duplicate `payment_intent.succeeded` event for an already-completed transaction, it updates (not duplicates) the existing `TransactionEntity`. | `3_JKYog_2.0_backend/src/stripe/stripe.service.ts::handlePaymentIntentSucceededEvent` |
| 14 | Verify `CreateDonationPaymentDto` validation rejects tampered payloads: negative `amount`, missing `paymentService` enum, and `amount` exceeding `IsPositive` constraint return 400. | `3_JKYog_2.0_backend/src/payment/dtos/create-donation-payment.dto.ts::CreateDonationPaymentDto` |
| 15 | Verify concurrent `update` calls on the same online-class entity via Strapi core router do not produce data corruption — second request receives 409 or last-write-wins with consistent state. | `4_JKYog_Strapi/src/api/online-class/controllers/online-class.js::createCoreController` |

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

For 3_JKYog_2.0_backend/src/stripe/stripe.service.ts — generate 2 test cases:
1. Mock stripe.paymentIntents.create to throw { code: 'card_declined' } and assert the service propagates the error with HTTP 402.
2. Fire the same payment_intent.succeeded webhook event twice (same event.id) and assert only one TransactionEntity row exists afterward.

For 3_JKYog_2.0_backend/src/paypal/paypal.service.ts — generate 1 test case:
1. Mock paypal.payment.create callback with a network ETIMEDOUT error and assert BadRequestException is thrown.

For 3_JKYog_2.0_backend/src/payment/dtos/create-donation-payment.dto.ts — generate 1 test case:
1. Submit DTO with amount=-5, paymentService='INVALID', and assert 400 validation errors for each field.

For 4_JKYog_Strapi/src/api/online-class/controllers/online-class.js — generate 1 test case:
1. Fire two concurrent PUT /online-classes/:id requests with different Title values and assert the final state is consistent.

Simulate Offline Mode and Simulate API Errors for all payment-related endpoints.

Output the code for Jest + Supertest.
```

---

## Phase 2 — Regression Expansion

### Phase 2 Mandatory Targets
- Event Registration:
  - `3_JKYog_2.0_backend/src/event-registration/event-registration.controller.ts`
  - `3_JKYog_2.0_backend/src/event-registration/event-registration.service.ts`
- Event Tickets CRUD:
  - `3_JKYog_2.0_backend/src/event-ticket/event-ticket.controller.ts`
- Event Add-ons CRUD:
  - `3_JKYog_2.0_backend/src/event-addon/event-addon.controller.ts`
- Event Promo Codes:
  - `3_JKYog_2.0_backend/src/event-promocode/event-promocode.controller.ts`
- Subscription Management:
  - `3_JKYog_2.0_backend/src/subscription/subscription.controller.ts`
  - `3_JKYog_2.0_backend/src/subscription/subscription.service.ts`
- Stripe Checkout Sessions:
  - `3_JKYog_2.0_backend/src/stripe/stripe.controller.ts::checkoutSession`
  - `3_JKYog_2.0_backend/src/stripe/stripe.controller.ts::courseCheckoutSession`
- Plans & Pricing:
  - `3_JKYog_2.0_backend/src/plans/plans.controller.ts`
  - `3_JKYog_2.0_backend/src/price/price.controller.ts`

### Phase 2 Scenarios
| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 16 | Verify `POST /api/event-registration/create-event-registration` creates a registration record with tickets, add-ons, and payment metadata for a valid event UUID. | `3_JKYog_2.0_backend/src/event-registration/event-registration.controller.ts::createEventRegistration` |
| 17 | Verify `GET /api/event-registration/get-event-registration-history` returns only the authenticated user's registrations (not another user's data). | `3_JKYog_2.0_backend/src/event-registration/event-registration.controller.ts::getEventRegistrationHistory` |
| 18 | Verify `GET /api/event-registration/get-user-event-registration/:eventUuid` returns the correct registration status for the authenticated user and the given event. | `3_JKYog_2.0_backend/src/event-registration/event-registration.controller.ts::getUserEventRegistration` |
| 19 | Verify `POST /api/event-ticket/create-event-ticket` creates a ticket tied to an event UUID; `PATCH` updates price; `DELETE` removes the ticket and returns 404 on subsequent GET. | `3_JKYog_2.0_backend/src/event-ticket/event-ticket.controller.ts` |
| 20 | Verify `POST /api/event-addon/create-event-addon` creates an add-on; `PUT` updates it; `DELETE` removes it — full CRUD lifecycle. | `3_JKYog_2.0_backend/src/event-addon/event-addon.controller.ts` |
| 21 | Verify `GET /api/event-promocode/check-promocode` validates a promo code against an event and returns discount details; expired/invalid codes return appropriate errors. | `3_JKYog_2.0_backend/src/event-promocode/event-promocode.controller.ts::checkPromocode` |
| 22 | Verify `POST /api/event-promocode/create-event-promocode` creates a promo code with discount percentage and usage limit; `PATCH` updates; `DELETE` removes. | `3_JKYog_2.0_backend/src/event-promocode/event-promocode.controller.ts` |
| 23 | Verify `POST /api/subscription/create-subscription` creates a Stripe subscription for the authenticated user and returns `subscriptionId` and `clientSecret`. | `3_JKYog_2.0_backend/src/subscription/subscription.controller.ts::createSubscription` |
| 24 | Verify `POST /api/subscription/cancel-subscription/:subscriptionId` cancels the subscription in Stripe and updates the local record status to `cancelled`. | `3_JKYog_2.0_backend/src/subscription/subscription.controller.ts::cancelSubscription` |
| 25 | Verify `GET /api/subscription/get-user-subscriptions` returns only the authenticated user's subscriptions with correct status (active/cancelled/past_due). | `3_JKYog_2.0_backend/src/subscription/subscription.controller.ts::getUserSubscriptions` |
| 26 | Verify `POST /api/stripe/checkout-session` creates a Stripe Checkout session for event registration with correct `line_items` and `success_url`/`cancel_url`. | `3_JKYog_2.0_backend/src/stripe/stripe.controller.ts::checkoutSession` |
| 27 | Verify `POST /api/stripe/course-checkout-session` creates a Stripe Checkout session for LMS course purchase with the correct `courseStrapiId` metadata. | `3_JKYog_2.0_backend/src/stripe/stripe.controller.ts::courseCheckoutSession` |
| 28 | Verify `POST /api/plans` (AdminEmailGuard) creates a subscription plan; `PATCH /api/plans/:id` updates it; non-admin users receive 403. | `3_JKYog_2.0_backend/src/plans/plans.controller.ts` |
| 29 | Verify `POST /api/price` (AdminEmailGuard) creates a price entry linked to a plan; `PATCH /api/price/:id` updates; non-admin users receive 403. | `3_JKYog_2.0_backend/src/price/price.controller.ts` |
| 30 | Verify `GET /api/transaction/get-donations-history` returns paginated donation history for the authenticated user. | `3_JKYog_2.0_backend/src/transaction/transaction.controller.ts::getDonationsHistory` |

### TestSprite Prompt for Phase 2
```text
Act as a Senior SDET. Read ../docs/00-context.md.

For event-registration controller — generate 3 test cases:
1. POST /api/event-registration/create-event-registration with valid event UUID, tickets, and payment DTO; assert 201 and registration ID returned.
2. GET /api/event-registration/get-event-registration-history with auth; assert array of user's registrations.
3. GET /api/event-registration/get-user-event-registration/:eventUuid with auth; assert registration status object.

For event-ticket controller — generate 1 test case:
1. Full CRUD lifecycle: POST create → PATCH update price → DELETE → GET returns 404.

For event-addon controller — generate 1 test case:
1. Full CRUD lifecycle: POST create → PUT update → DELETE → GET returns 404.

For event-promocode controller — generate 2 test cases:
1. POST create a promo code with 20% discount and limit=100; GET check-promocode returns discount details.
2. GET check-promocode with expired code; assert error response.

For subscription controller — generate 3 test cases:
1. POST /api/subscription/create-subscription with valid plan; assert subscriptionId returned.
2. POST /api/subscription/cancel-subscription/:id; assert status=cancelled.
3. GET /api/subscription/get-user-subscriptions; assert only authenticated user's subscriptions.

For stripe controller — generate 2 test cases:
1. POST /api/stripe/checkout-session with valid event registration data; assert session URL returned.
2. POST /api/stripe/course-checkout-session with valid courseStrapiId; assert session URL returned.

For plans/price controllers — generate 2 test cases:
1. POST /api/plans as admin; assert 201. POST /api/plans as non-admin; assert 403.
2. POST /api/price linked to plan as admin; assert 201.

Output the code for Jest + Supertest.
```

## Deliverable
- [ ] Completed test files committed to the `testing/` directory.
- [ ] Each scenario from the Remediated Scenarios table covered by at least one test case.
- [ ] Each scenario from the Remediated Scenarios (Gap Analysis) table covered by at least one test case.
- [ ] Each Phase 2 scenario (16-30) covered by at least one test case.
- [ ] All tests pass locally before submission.
