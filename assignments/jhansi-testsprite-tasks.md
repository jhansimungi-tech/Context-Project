# Mission: Jhansi — Interactive & Transactional

## Zero-Generic Policy
- Every scenario must reference an exact file plus function/component.
- No generic wording like "test payment" or "check form".

## Reference Documentation
- [Architectural Context](../docs/00-context.md)
- [Repo Setup](../docs/01-setup.md)

## Mandatory Component Targets
- CanteenMenu (implementation mapping): `2_radhakrishnatemple2.0/src/pages-ui/dallas-yoga-fest/MenuModal.tsx::MenuModal`
- VolunteerStepper (implementation mapping): `2_radhakrishnatemple2.0/src/pages-ui/donation-page/sevas-donations/stepper.tsx::Stepper`
- PoojaDatepicker (implementation mapping): `2_radhakrishnatemple2.0/src/components/datepicker/datepicker.tsx::DatePicker`

## Remediated Scenarios
| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 1 | Verify `CanteenMenu` mapping (`MenuModal`) renders modal only when `isOpen=true` and closes via `onClose`. | `2_radhakrishnatemple2.0/src/pages-ui/dallas-yoga-fest/MenuModal.tsx::MenuModal` |
| 2 | Verify `MenuModal` table correctly marks per-day availability (`friday/saturday/sunday`) for each menu item. | `2_radhakrishnatemple2.0/src/pages-ui/dallas-yoga-fest/MenuModal.tsx::menuData.items` |
| 3 | Verify `VolunteerStepper` mapping (`Stepper`) highlights completed/current steps using `activeStep` state. | `2_radhakrishnatemple2.0/src/pages-ui/donation-page/sevas-donations/stepper.tsx::Stepper` |
| 4 | Verify `Stepper` emits deterministic DOM ids (`stepper-step-{n}-{id}`) for mobile step focus targeting. | `2_radhakrishnatemple2.0/src/pages-ui/donation-page/sevas-donations/stepper.tsx::id` |
| 5 | Verify `PoojaDatepicker` mapping (`DatePicker`) enforces `min` date and required value constraints. | `2_radhakrishnatemple2.0/src/components/datepicker/datepicker.tsx::DatePicker` |
| 6 | Verify `DatePicker` `handleChange` preserves local date semantics for YYYY-MM-DD input values. | `2_radhakrishnatemple2.0/src/components/datepicker/datepicker.tsx::handleChange` |
| 7 | Verify donation step flow transitions in order (seva -> personal info -> payment -> success). | `2_radhakrishnatemple2.0/src/pages-ui/donation-page/sevas-donations/step-container.tsx` |
| 8 | Verify Stripe checkout submission and error handling in donation checkout form. | `2_radhakrishnatemple2.0/src/pages-ui/donation-page/sevas-donations/checkout-form.tsx` |
| 9 | Verify Puja Payment route renders registration and sponsorship blocks together for booked service context. | `2_radhakrishnatemple2.0/app/puja-payment/page.tsx` |
| 10 | Verify ticket booking date and registrant sections enforce validation before payment summary. | `2_radhakrishnatemple2.0/src/pages-ui/book-tickets/components/DateSelectionSection.tsx` |

### Remediated Scenarios (Gap Analysis)
> Source: `09-quality-reports/coverage-gap-analysis.md` | Categories: SQL/XSS Injection, Network Resilience, CSRF, Empty States

| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 11 | Verify `RegistrationForm` (DateSelectionSection) input fields reject SQL injection (`' OR 1=1 --`) and XSS (`<script>alert(1)</script>`) payloads — values are sanitized or validation rejects them. | `2_radhakrishnatemple2.0/src/pages-ui/book-tickets/components/DateSelectionSection.tsx` |
| 12 | Verify `CheckoutForm` displays a network-error toast when `stripe.confirmPayment` rejects due to offline connectivity and the `isLoading` state resets to false. | `2_radhakrishnatemple2.0/src/pages-ui/donation-page/sevas-donations/checkout-form.tsx::CheckoutForm` |
| 13 | Verify `CheckoutForm` shows a loading spinner with the submit button disabled while `stripe.confirmPayment` is in flight, preventing duplicate submissions. | `2_radhakrishnatemple2.0/src/pages-ui/donation-page/sevas-donations/checkout-form.tsx::isLoading` |
| 14 | Verify `MenuModal` renders a "No menu items available" empty state when `menuData.items` array is empty or undefined. | `2_radhakrishnatemple2.0/src/pages-ui/dallas-yoga-fest/MenuModal.tsx::MenuModal` |
| 15 | Verify donation checkout and registration endpoints reject cross-origin POST requests that lack a valid CSRF token or Origin header validation. | `2_radhakrishnatemple2.0/src/pages-ui/donation-page/sevas-donations/checkout-form.tsx::confirmPayment`, `3_JKYog_2.0_backend/src/user/user.controller.ts::updateAccountDetails` |

### Network Chaos — Resilience Scenarios
> These 5 scenarios must be adapted per component. Replace `[COMPONENT_NAME]` and `[FILE_PATH]` with the component under test.

| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| NC-1 | Verify `CheckoutForm` displays a user-friendly error toast/banner when a primary API call fails with HTTP 500 (server error). | `2_radhakrishnatemple2.0/src/pages-ui/donation-page/sevas-donations/checkout-form.tsx` |
| NC-2 | Verify `CheckoutForm` displays a "You are offline" banner or toast when `navigator.onLine` is false and an API call is attempted. | `2_radhakrishnatemple2.0/src/pages-ui/donation-page/sevas-donations/checkout-form.tsx` |
| NC-3 | Verify `CheckoutForm` shows a retry button after a network timeout (simulated 10s delay) and successfully recovers on retry. | `2_radhakrishnatemple2.0/src/pages-ui/donation-page/sevas-donations/checkout-form.tsx` |
| NC-4 | Verify `CheckoutForm` does not lose user-entered form data when a transient network error occurs during submission — form fields retain their values after the error. | `2_radhakrishnatemple2.0/src/pages-ui/donation-page/sevas-donations/checkout-form.tsx` |
| NC-5 | Verify `CheckoutForm` gracefully handles HTTP 429 (rate limit) by showing a "Please wait" message and not firing additional requests while throttled. | `2_radhakrishnatemple2.0/src/pages-ui/donation-page/sevas-donations/checkout-form.tsx` |

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

For 2_radhakrishnatemple2.0/src/pages-ui/book-tickets/components/DateSelectionSection.tsx — generate 1 test case:
1. Type "' OR 1=1 --" and '<script>alert(1)</script>' into text input fields; assert the values are either rejected by validation or the displayed output is HTML-escaped.

For 2_radhakrishnatemple2.0/src/pages-ui/donation-page/sevas-donations/checkout-form.tsx — generate 2 test cases:
1. Mock stripe.confirmPayment to reject with NetworkError; assert toast.error is called and isLoading resets to false.
2. Assert the submit button has disabled=true and a spinner is visible while isLoading=true.

For 2_radhakrishnatemple2.0/src/pages-ui/dallas-yoga-fest/MenuModal.tsx — generate 1 test case:
1. Render MenuModal with isOpen=true and override menuData.items to []; assert "No menu items available" text is rendered.

Simulate Offline Mode and Simulate API Errors for all checkout and booking endpoints.

Output the code for React Testing Library + Jest.
```

### TestSprite Prompt for Network Chaos
```text
Act as a Senior SDET. Read ../docs/00-context.md.

For 2_radhakrishnatemple2.0/src/pages-ui/donation-page/sevas-donations/checkout-form.tsx — generate 5 resilience test cases:
1. Mock fetch/axios to return { status: 500 }; assert error UI appears.
2. Set navigator.onLine = false before API call; assert offline banner/toast.
3. Mock fetch to delay 10s then timeout; assert retry button appears and works.
4. Fill form, mock fetch to throw NetworkError on submit; assert form fields retain values.
5. Mock fetch to return { status: 429 }; assert "Please wait" message and no duplicate requests.

Output the code for React Testing Library + Jest.
```

---

## Phase 2 — Regression Expansion

### Phase 2 Mandatory Targets
- Subscription Management UI:
  - `2_radhakrishnatemple2.0/src/pages-ui/donation-page/` (subscription flow if present)
  - `1_JKYog_2.0/src/pages-view/profile/` (subscription management section)
- PayPal Checkout Flow (Temple Site):
  - `2_radhakrishnatemple2.0/src/pages-ui/donation-page/sevas-donations/` (PayPal branch)
- Ticket Booking Full Flow:
  - `2_radhakrishnatemple2.0/src/pages-ui/book-tickets/` (complete E2E)
- Zoom Integration:
  - `1_JKYog_2.0/src/pages-view/zoom/` (Zoom meeting join flow)

### Phase 2 Scenarios
| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 16 | Verify donation page PayPal branch renders PayPal payment button when PayPal is selected as payment method; clicking the button redirects to PayPal approval URL. | `2_radhakrishnatemple2.0/src/pages-ui/donation-page/sevas-donations/step-container.tsx` |
| 17 | Verify donation page PayPal return handler completes the payment flow and renders success confirmation step. | `2_radhakrishnatemple2.0/src/pages-ui/donation-page/sevas-donations/step-container.tsx` |
| 18 | Verify donation page PayPal cancel handler returns the user to the payment step with form data intact and shows "Payment cancelled" message. | `2_radhakrishnatemple2.0/src/pages-ui/donation-page/sevas-donations/step-container.tsx` |
| 19 | Verify ticket booking full E2E flow: select date → select registrants → fill personal info → proceed to payment summary → confirm checkout. | `2_radhakrishnatemple2.0/src/pages-ui/book-tickets/` |
| 20 | Verify ticket booking `DateSelectionSection` disables past dates and shows "No available dates" when all seva dates are in the past. | `2_radhakrishnatemple2.0/src/pages-ui/book-tickets/components/DateSelectionSection.tsx` |
| 21 | Verify ticket booking registrant section enforces minimum 1 registrant and maximum registrant limit per ticket type. | `2_radhakrishnatemple2.0/src/pages-ui/book-tickets/` |
| 22 | Verify subscription management section on Profile page renders active subscriptions with `plan name`, `status`, `next billing date`, and `Cancel` button. | `1_JKYog_2.0/src/pages-view/profile/right-part/` |
| 23 | Verify subscription `Cancel` button triggers confirmation modal; confirming calls `cancel-subscription` API and updates status to "Cancelled". | `1_JKYog_2.0/src/pages-view/profile/right-part/` |
| 24 | Verify subscription management shows "No active subscriptions" empty state when the user has no subscriptions. | `1_JKYog_2.0/src/pages-view/profile/right-part/` |
| 25 | Verify Zoom meeting join page (`/zoom`) renders meeting SDK with correct `meetingNumber` and `signature` from the backend JWT signing endpoint. | `1_JKYog_2.0/src/pages-view/zoom/index.tsx` |
| 26 | Verify Zoom meeting join page shows "Meeting not found" error when an invalid meeting ID is provided. | `1_JKYog_2.0/src/pages-view/zoom/index.tsx` |

### TestSprite Prompt for Phase 2
```text
Act as a Senior SDET. Read ../docs/00-context.md.

For PayPal flow on temple site — generate 3 test cases:
1. Select PayPal as payment method; assert PayPal button renders; click; assert redirect to approval URL.
2. Simulate PayPal return with success callback; assert success step renders.
3. Simulate PayPal cancel callback; assert user returns to payment step with form data intact.

For ticket booking — generate 3 test cases:
1. Full E2E: select date → add registrants → fill info → payment summary → confirm. Assert success page.
2. Assert past dates are disabled in DateSelectionSection; mock all dates in past; assert "No available dates".
3. Add maximum allowed registrants; assert "Add" button disabled at limit.

For subscription management — generate 3 test cases:
1. Navigate to profile subscriptions; assert active subscription card with plan name, status, next billing date.
2. Click Cancel; confirm in modal; assert cancel-subscription API called and status updates to "Cancelled".
3. Mock subscriptions API to return []; assert "No active subscriptions" empty state.

For Zoom — generate 2 test cases:
1. Navigate to /zoom with valid meetingNumber; assert Zoom SDK container renders.
2. Navigate to /zoom with invalid meetingNumber; assert "Meeting not found" error.

Output the code for Playwright / React Testing Library + Jest.
```

## Deliverable
- [ ] Completed test files committed to the `testing/` directory.
- [ ] Each scenario from the Remediated Scenarios table covered by at least one test case.
- [ ] Each scenario from the Remediated Scenarios (Gap Analysis) table covered by at least one test case.
- [ ] All Network Chaos scenarios (NC-1 to NC-5) covered by at least one test case.
- [ ] Each Phase 2 scenario (16-26) covered by at least one test case.
- [ ] All tests pass locally before submission.
