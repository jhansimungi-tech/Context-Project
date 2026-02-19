# Mission: Anusha — Transactions & Events

## Zero-Generic Policy
- Every scenario must include an exact file path and component/function.
- No generic wording like "test donation page" or "check payment".

## Reference Documentation
- [Architectural Context](../docs/00-context.md)
- [Repo Setup](../docs/01-setup.md)

## Mandatory Component Targets
- DonationCheckout (implementation mapping): `1_JKYog_2.0/src/pages-view/make-donation/donation-form/checkout-form.tsx::CheckoutForm`
- StripeElements (implementation mapping): `1_JKYog_2.0/src/pages-view/make-donation/donation-form/payment.tsx::Payment`
- EventCard: `1_JKYog_2.0/src/components/event-card/index.tsx::EventCard`

## Remediated Scenarios
| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 1 | Verify `DonationCheckout` mapping (`CheckoutForm`) calls `stripe.confirmPayment` with billing details and handles `paymentIntent.succeeded`. | `1_JKYog_2.0/src/pages-view/make-donation/donation-form/checkout-form.tsx::confirmPayment` |
| 2 | Verify `CheckoutForm` handles `requires_payment_method` and unknown statuses with error/info toast branches. | `1_JKYog_2.0/src/pages-view/make-donation/donation-form/checkout-form.tsx::useEffect(paymentIntent)` |
| 3 | Verify `StripeElements` mapping (`Payment`) mounts `<Elements>` only when `clientSecret` is available. | `1_JKYog_2.0/src/pages-view/make-donation/donation-form/payment.tsx::Payment` |
| 4 | Verify Stripe appearance/options are passed with configured `borderRadius` and publishable key. | `1_JKYog_2.0/src/pages-view/make-donation/donation-form/payment.tsx::options` |
| 5 | Verify donation form validation blocks invalid amount/email/phone combinations before payment step. | `1_JKYog_2.0/src/pages-view/make-donation/donation-form/validation.ts` |
| 6 | Verify `EventCard` renders `basic` variant metadata (`place`, `date`) and preserves link target behavior. | `1_JKYog_2.0/src/components/event-card/index.tsx::EventCard` |
| 7 | Verify `EventCard` renders `detailed` variant `CardInfoBlock` entries for Date/Time/Venue. | `1_JKYog_2.0/src/components/event-card/index.tsx::CardInfoBlock` |
| 8 | Verify event detail route loads slug-specific payload and renders registration controls. | `1_JKYog_2.0/app/events/[slug]/page.tsx` |
| 9 | Verify event registration checkout summary and payment flow use the registration checkout form component. | `1_JKYog_2.0/src/pages-view/event-registration/registration-section/payment-summary/checkout-form.tsx` |
| 10 | Verify donation API creation path returns payment metadata required for checkout rendering. | `1_JKYog_2.0/src/api/donation/create-donation.ts` |

### Remediated Scenarios (Gap Analysis)
> Source: `09-quality-reports/coverage-gap-analysis.md` | Categories: Race Condition, Network Resilience, Empty States

| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 11 | Verify `CheckoutForm` disables the submit button and shows `isLoading=true` spinner while `stripe.confirmPayment` is in flight, preventing double-click race conditions. | `1_JKYog_2.0/src/pages-view/make-donation/donation-form/checkout-form.tsx::CheckoutForm` |
| 12 | Verify `Payment` component renders an empty fragment (no crash) when `loadStripe` fails to initialize, simulating Stripe Elements mount failure. | `1_JKYog_2.0/src/pages-view/make-donation/donation-form/payment.tsx::Payment` |
| 13 | Verify `CheckoutForm` displays a network-error toast when `stripe.confirmPayment` rejects with `NetworkError` due to offline connectivity. | `1_JKYog_2.0/src/pages-view/make-donation/donation-form/checkout-form.tsx::confirmPayment` |
| 14 | Verify `Payment` component renders a loading skeleton (`loader: 'always'`) while `clientSecret` is provided but Stripe Elements have not yet mounted. | `1_JKYog_2.0/src/pages-view/make-donation/donation-form/payment.tsx::options` |
| 15 | Verify `EventCard` renders a "No upcoming events" empty state when the events array prop is empty or undefined. | `1_JKYog_2.0/src/components/event-card/index.tsx::EventCard` |

### Network Chaos — Resilience Scenarios
> These 5 scenarios must be adapted per component. Replace `[COMPONENT_NAME]` and `[FILE_PATH]` with the component under test.

| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| NC-1 | Verify `CheckoutForm` displays a user-friendly error toast/banner when a primary API call fails with HTTP 500 (server error). | `1_JKYog_2.0/src/pages-view/make-donation/donation-form/checkout-form.tsx` |
| NC-2 | Verify `CheckoutForm` displays a "You are offline" banner or toast when `navigator.onLine` is false and an API call is attempted. | `1_JKYog_2.0/src/pages-view/make-donation/donation-form/checkout-form.tsx` |
| NC-3 | Verify `CheckoutForm` shows a retry button after a network timeout (simulated 10s delay) and successfully recovers on retry. | `1_JKYog_2.0/src/pages-view/make-donation/donation-form/checkout-form.tsx` |
| NC-4 | Verify `CheckoutForm` does not lose user-entered form data when a transient network error occurs during submission — form fields retain their values after the error. | `1_JKYog_2.0/src/pages-view/make-donation/donation-form/checkout-form.tsx` |
| NC-5 | Verify `CheckoutForm` gracefully handles HTTP 429 (rate limit) by showing a "Please wait" message and not firing additional requests while throttled. | `1_JKYog_2.0/src/pages-view/make-donation/donation-form/checkout-form.tsx` |

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

For 1_JKYog_2.0/src/pages-view/make-donation/donation-form/checkout-form.tsx — generate 3 test cases:
1. Click submit twice rapidly; assert stripe.confirmPayment is called exactly once and the button has disabled=true after first click.
2. Mock stripe.confirmPayment to reject with { type: 'NetworkError' }; assert toast.error is called with a network-related message.
3. Assert isLoading state shows a spinner/loading indicator during payment processing.

For 1_JKYog_2.0/src/pages-view/make-donation/donation-form/payment.tsx — generate 1 test case:
1. Mock loadStripe to return null; assert the component renders <></> without throwing.

For 1_JKYog_2.0/src/components/event-card/index.tsx — generate 1 test case:
1. Render EventCard parent container with events=[] and assert "No upcoming events" or equivalent empty-state text appears.

Simulate Offline Mode and Simulate API Errors for all checkout and event-loading endpoints.

Output the code for React Testing Library + Jest.
```

### TestSprite Prompt for Network Chaos
```text
Act as a Senior SDET. Read ../docs/00-context.md.

For 1_JKYog_2.0/src/pages-view/make-donation/donation-form/checkout-form.tsx — generate 5 resilience test cases:
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
- Event Registration Flow (Frontend E2E):
  - `1_JKYog_2.0/src/pages-view/event-registration/` (full registration flow)
  - `1_JKYog_2.0/src/pages-view/event-registration/registration-section/ticket-selection/`
  - `1_JKYog_2.0/src/pages-view/event-registration/registration-section/addon-selection/`
  - `1_JKYog_2.0/src/pages-view/event-registration/registration-section/promo-code/`
- Live Portal Page: `1_JKYog_2.0/app/live-portal/page.tsx`
- PayPal Frontend Flow: `1_JKYog_2.0/src/pages-view/make-donation/donation-form/` (PayPal branch)
- Donation History Page: `1_JKYog_2.0/src/pages-view/donations/`

### Phase 2 Scenarios
| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 16 | Verify event registration flow renders ticket selection step with available ticket types, prices, and quantity selectors for the given event. | `1_JKYog_2.0/src/pages-view/event-registration/registration-section/ticket-selection/` |
| 17 | Verify event registration ticket selection enforces max quantity limits and disables "Add" when max reached. | `1_JKYog_2.0/src/pages-view/event-registration/registration-section/ticket-selection/` |
| 18 | Verify event registration add-on selection step renders available add-ons with prices and allows toggle on/off. | `1_JKYog_2.0/src/pages-view/event-registration/registration-section/addon-selection/` |
| 19 | Verify event registration promo code input validates the code against the event API and applies discount to the order summary. | `1_JKYog_2.0/src/pages-view/event-registration/registration-section/promo-code/` |
| 20 | Verify event registration promo code shows error for expired/invalid codes and does not apply any discount. | `1_JKYog_2.0/src/pages-view/event-registration/registration-section/promo-code/` |
| 21 | Verify event registration payment summary displays correct total (tickets + add-ons - promo discount) before proceeding to Stripe checkout. | `1_JKYog_2.0/src/pages-view/event-registration/registration-section/payment-summary/` |
| 22 | Verify event registration end-to-end flow: select tickets → add add-ons → apply promo → fill personal info → confirm payment → success page. | `1_JKYog_2.0/src/pages-view/event-registration/` |
| 23 | Verify Live Portal page (`/live-portal`) renders active live stream embed when a stream is currently live. | `1_JKYog_2.0/app/live-portal/page.tsx` |
| 24 | Verify Live Portal page renders "No live stream currently" empty state when no stream is active. | `1_JKYog_2.0/app/live-portal/page.tsx` |
| 25 | Verify donation form PayPal branch renders PayPal button and redirects to PayPal approval URL on click. | `1_JKYog_2.0/src/pages-view/make-donation/donation-form/` |
| 26 | Verify donation form PayPal return URL handling completes the payment and shows success confirmation. | `1_JKYog_2.0/src/pages-view/make-donation/donation-form/` |
| 27 | Verify donations history page renders a paginated list of past donations with `amount`, `date`, `status`, and `receipt` link. | `1_JKYog_2.0/src/pages-view/donations/` |

### TestSprite Prompt for Phase 2
```text
Act as a Senior SDET. Read ../docs/00-context.md.

For event registration flow — generate 5 E2E test cases:
1. Navigate to /event-registration/:eventUuid; assert ticket types render with prices and quantity selectors.
2. Select 2 tickets, add 1 add-on; assert order summary total is correct.
3. Enter valid promo code; assert discount applied to summary. Enter expired code; assert error message.
4. Fill personal info and proceed to payment; assert Stripe checkout form renders.
5. Complete full E2E flow: tickets → add-ons → promo → info → payment → assert success page.

For Live Portal — generate 2 test cases:
1. Mock live stream API to return active stream; assert video embed renders.
2. Mock live stream API to return no active streams; assert "No live stream currently" empty state.

For PayPal flow — generate 2 test cases:
1. Select PayPal as payment method; click Pay; assert redirect to PayPal approval URL.
2. Simulate PayPal return with success; assert donation confirmation page renders.

For donations history — generate 1 test case:
1. Navigate to donations page; assert donation list renders with amount, date, status columns.

Output the code for Playwright / React Testing Library + Jest.
```

## Deliverable
- [ ] Completed test files committed to the `testing/` directory.
- [ ] Each scenario from the Remediated Scenarios table covered by at least one test case.
- [ ] Each scenario from the Remediated Scenarios (Gap Analysis) table covered by at least one test case.
- [ ] All Network Chaos scenarios (NC-1 to NC-5) covered by at least one test case.
- [ ] Each Phase 2 scenario (16-27) covered by at least one test case.
- [ ] All tests pass locally before submission.
