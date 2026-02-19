# Mission: Divyani — Core Navigation & Static

## Zero-Generic Policy
- Every scenario must include an exact source file and component/function.
- No generic checks like "verify page works".

## Reference Documentation
- [Architectural Context](../docs/00-context.md)
- [Repo Setup](../docs/01-setup.md)

## Mandatory Component Targets
- TempleServiceList (implementation mapping): `2_radhakrishnatemple2.0/src/pages-ui/puja-services/registration.tsx::RegistrationForm` (uses `pujaTypes` service list)
- CalendarWidget (implementation mapping): `2_radhakrishnatemple2.0/src/components/sunday-calendar/sunday-calendar.tsx::SundayCalendar`

## Remediated Scenarios
| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 1 | Verify Puja Services route composes `Navbar`, `Registration`, `Sponsorship`, and `Footer` in order. | `2_radhakrishnatemple2.0/app/puja-services/page.tsx::Home` |
| 2 | Verify `TempleServiceList` mapping (`RegistrationForm`) renders all `pujaTypes` options in the service selector. | `2_radhakrishnatemple2.0/src/pages-ui/puja-services/registration.tsx::pujaTypes` |
| 3 | Verify `RegistrationForm` updates `selectedDate` through `handleDateChange` after `DatePicker` input changes. | `2_radhakrishnatemple2.0/src/pages-ui/puja-services/registration.tsx::handleDateChange` |
| 4 | Verify `RegistrationForm` submit builds event-registration payload with `eventUuid`, contact, and personal information fields. | `2_radhakrishnatemple2.0/src/pages-ui/puja-services/registration.tsx::handleSubmit` |
| 5 | Verify `CalendarWidget` mapping (`SundayCalendar`) initializes future Sundays and excludes past dates. | `2_radhakrishnatemple2.0/src/components/sunday-calendar/sunday-calendar.tsx::useEffect(setUpcomingSundays)` |
| 6 | Verify `SundayCalendar` seva selection toggles IDs correctly and emits `onSevasChange` updates. | `2_radhakrishnatemple2.0/src/components/sunday-calendar/sunday-calendar.tsx::handleSevaToggle` |
| 7 | Verify Sunday-only calendar input enforces Sunday selection and min-date constraints. | `2_radhakrishnatemple2.0/src/components/sunday-calendar/sunday-date-picker.tsx::SundayDatePicker` |
| 8 | Verify Upcoming Events route renders page-level event sections and link-through behavior. | `2_radhakrishnatemple2.0/app/upcoming-events/page.tsx` |
| 9 | Verify dynamic `[eventSlug]` route renders event detail layout for known event slugs. | `2_radhakrishnatemple2.0/app/[eventSlug]/page.tsx` |
| 10 | Verify shared static footer renders legal and social blocks for public pages. | `2_radhakrishnatemple2.0/src/pages-ui/layout/Footer.tsx::Footer` |

### Remediated Scenarios (Gap Analysis)
> Source: `09-quality-reports/coverage-gap-analysis.md` | Categories: Empty States, Network Resilience, Loading States

| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 11 | Verify `RegistrationForm` renders a "No temple services found" empty state when the `pujaTypes` array is empty. | `2_radhakrishnatemple2.0/src/pages-ui/puja-services/registration.tsx::pujaTypes` |
| 12 | Verify `RegistrationForm` `handleSubmit` displays a network-error message when the registration API call fails due to offline connectivity and resets `isSubmitting` to false. | `2_radhakrishnatemple2.0/src/pages-ui/puja-services/registration.tsx::handleSubmit` |
| 13 | Verify `RegistrationForm` shows a loading spinner with the submit button disabled while `isSubmitting=true` during the `pujaTypes` fetch or form submission. | `2_radhakrishnatemple2.0/src/pages-ui/puja-services/registration.tsx::isSubmitting` |
| 14 | Verify Upcoming Events page renders an "No upcoming events" empty state when the events API returns an empty array. | `2_radhakrishnatemple2.0/app/upcoming-events/page.tsx` |

### Network Chaos — Resilience Scenarios
> These 5 scenarios must be adapted per component. Replace `[COMPONENT_NAME]` and `[FILE_PATH]` with the component under test.

| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| NC-1 | Verify `RegistrationForm` displays a user-friendly error toast/banner when a primary API call fails with HTTP 500 (server error). | `2_radhakrishnatemple2.0/src/pages-ui/puja-services/registration.tsx` |
| NC-2 | Verify `RegistrationForm` displays a "You are offline" banner or toast when `navigator.onLine` is false and an API call is attempted. | `2_radhakrishnatemple2.0/src/pages-ui/puja-services/registration.tsx` |
| NC-3 | Verify `RegistrationForm` shows a retry button after a network timeout (simulated 10s delay) and successfully recovers on retry. | `2_radhakrishnatemple2.0/src/pages-ui/puja-services/registration.tsx` |
| NC-4 | Verify `RegistrationForm` does not lose user-entered form data when a transient network error occurs during submission — form fields retain their values after the error. | `2_radhakrishnatemple2.0/src/pages-ui/puja-services/registration.tsx` |
| NC-5 | Verify `RegistrationForm` gracefully handles HTTP 429 (rate limit) by showing a "Please wait" message and not firing additional requests while throttled. | `2_radhakrishnatemple2.0/src/pages-ui/puja-services/registration.tsx` |

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

For 2_radhakrishnatemple2.0/src/pages-ui/puja-services/registration.tsx — generate 3 test cases:
1. Override pujaTypes to []; assert the form's service selector shows "No temple services found" or equivalent empty-state text.
2. Mock fetch to reject with TypeError('Failed to fetch') during handleSubmit; assert an error message is displayed and isSubmitting resets to false.
3. Assert the submit button has disabled=true and a spinner is visible while isSubmitting=true.

For 2_radhakrishnatemple2.0/app/upcoming-events/page.tsx — generate 1 test case:
1. Mock the events API to return []; assert the page renders "No upcoming events" or equivalent empty-state text.

Simulate Offline Mode and Simulate API Errors for all registration and event-listing endpoints.

Output the code for React Testing Library + Jest.
```

### TestSprite Prompt for Network Chaos
```text
Act as a Senior SDET. Read ../docs/00-context.md.

For 2_radhakrishnatemple2.0/src/pages-ui/puja-services/registration.tsx — generate 5 resilience test cases:
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
- Volunteering Page: `2_radhakrishnatemple2.0/app/volunteering/page.tsx` (or equivalent route)
- Yoga Fest Page: `2_radhakrishnatemple2.0/app/dallas-yoga-fest/page.tsx`
- Calendar Page: `2_radhakrishnatemple2.0/app/calendar/page.tsx`
- Accessibility (a11y) Audit:
  - `2_radhakrishnatemple2.0/src/pages-ui/puja-services/registration.tsx`
  - `2_radhakrishnatemple2.0/src/components/sunday-calendar/sunday-calendar.tsx`
  - `2_radhakrishnatemple2.0/src/pages-ui/layout/Footer.tsx`

### Phase 2 Scenarios
| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 15 | Verify Volunteering page renders volunteer opportunity cards with `Title`, `Description`, `Date`, and `Sign Up` CTA. | `2_radhakrishnatemple2.0/app/volunteering/page.tsx` |
| 16 | Verify Volunteering page renders "No volunteer opportunities" empty state when the volunteer API returns an empty array. | `2_radhakrishnatemple2.0/app/volunteering/page.tsx` |
| 17 | Verify Dallas Yoga Fest page (`/dallas-yoga-fest`) renders event schedule, speaker grid, and registration CTA. | `2_radhakrishnatemple2.0/app/dallas-yoga-fest/page.tsx` |
| 18 | Verify Dallas Yoga Fest page renders speaker bios in modal on click and modal closes correctly. | `2_radhakrishnatemple2.0/src/pages-ui/dallas-yoga-fest/` |
| 19 | Verify Calendar page renders a monthly view with events marked on their respective dates and clicking a date shows event details. | `2_radhakrishnatemple2.0/app/calendar/page.tsx` |
| 20 | Verify Calendar page renders "No events this month" empty state when no events exist for the displayed month. | `2_radhakrishnatemple2.0/app/calendar/page.tsx` |
| 21 | **[A11Y]** Verify `RegistrationForm` passes axe-core automated accessibility audit — no critical or serious violations (missing labels, low contrast, missing ARIA roles). | `2_radhakrishnatemple2.0/src/pages-ui/puja-services/registration.tsx` |
| 22 | **[A11Y]** Verify `SundayCalendar` date cells have `aria-label` with full date text (e.g., "Sunday, March 2, 2026") and keyboard navigation (arrow keys) moves focus between dates. | `2_radhakrishnatemple2.0/src/components/sunday-calendar/sunday-calendar.tsx` |
| 23 | **[A11Y]** Verify `Footer` links have descriptive `aria-label` attributes and social media icons have `alt` text or `aria-label`; tab order follows visual layout. | `2_radhakrishnatemple2.0/src/pages-ui/layout/Footer.tsx` |
| 24 | **[A11Y]** Verify all temple site form fields (`RegistrationForm`, `SundayDatePicker`) have associated `<label>` elements or `aria-labelledby` attributes for screen reader compatibility. | `2_radhakrishnatemple2.0/src/pages-ui/puja-services/registration.tsx`, `2_radhakrishnatemple2.0/src/components/sunday-calendar/sunday-date-picker.tsx` |

### TestSprite Prompt for Phase 2
```text
Act as a Senior SDET. Read ../docs/00-context.md.

For Volunteering page — generate 2 test cases:
1. Navigate to /volunteering; assert volunteer cards render with Title, Description, Sign Up CTA.
2. Mock volunteer API to return []; assert "No volunteer opportunities" empty state.

For Dallas Yoga Fest page — generate 2 test cases:
1. Navigate to /dallas-yoga-fest; assert schedule, speaker grid, and registration CTA render.
2. Click a speaker card; assert bio modal opens with speaker details; close modal; assert it dismisses.

For Calendar page — generate 2 test cases:
1. Navigate to /calendar; assert monthly grid renders with event markers.
2. Navigate to a month with no events; assert "No events this month" empty state.

For Accessibility — generate 4 test cases using axe-core:
1. Run axe() on RegistrationForm; assert zero critical/serious violations.
2. Focus SundayCalendar date cells; assert aria-label contains full date text; press arrow keys; assert focus moves.
3. Tab through Footer; assert all links are reachable and social icons have alt/aria-label.
4. Run axe() on all form fields; assert all inputs have associated labels.

Output the code for Playwright + @axe-core/playwright / React Testing Library + jest-axe.
```

## Deliverable
- [ ] Completed test files committed to the `testing/` directory.
- [ ] Each scenario from the Remediated Scenarios table covered by at least one test case.
- [ ] Each scenario from the Remediated Scenarios (Gap Analysis) table covered by at least one test case.
- [ ] All Network Chaos scenarios (NC-1 to NC-5) covered by at least one test case.
- [ ] Each Phase 2 scenario (15-24) covered by at least one test case.
- [ ] **[A11Y]** All accessibility scenarios (21-24) covered by axe-core test cases.
- [ ] All tests pass locally before submission.
