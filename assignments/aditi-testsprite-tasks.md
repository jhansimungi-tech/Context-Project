# Mission: Aditi — Public Pages

## Zero-Generic Policy
- Every scenario must reference an exact file and component/function.
- Never use generic wording such as "test the page" or "test the form".

## Reference Documentation
- [Architectural Context](../docs/00-context.md)
- [Repo Setup](../docs/01-setup.md)

## Mandatory Component Targets
- HeroBanner: `1_JKYog_2.0/src/pages-view/online-classes/hero-banner/index.tsx::HeroBanner`
- Footer: `1_JKYog_2.0/src/components/layout/footer/index.tsx::Footer`
- AboutTeamGrid (implementation mapping): `2_radhakrishnatemple2.0/src/pages-ui/prem-yoga/TeamSection.tsx::InstructorsSection`

## Remediated Scenarios
| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 1 | Verify `HeroBanner` renders featured online classes and updates `setClassesTitle` when class context changes. | `1_JKYog_2.0/src/pages-view/online-classes/hero-banner/index.tsx::HeroBanner` |
| 2 | Verify hero carousel controls in `HeroBanner` switch cards without layout shift at mobile and desktop breakpoints. | `1_JKYog_2.0/src/pages-view/online-classes/hero-banner/class-carousel/index.tsx::ClassCarousel` |
| 3 | Verify `Footer` renders `RightPart`, `LeftPart`, and `Policy` blocks with expected navigation links. | `1_JKYog_2.0/src/components/layout/footer/index.tsx::Footer` |
| 4 | Verify footer newsletter invalid email handling blocks submit and shows validation feedback. | `1_JKYog_2.0/src/components/layout/footer/right-part/subscribe.tsx::Subscribe` |
| 5 | Verify footer newsletter valid email submission sends request and shows success state. | `1_JKYog_2.0/src/components/layout/footer/right-part/subscribe.tsx::Subscribe` |
| 6 | Verify `AboutTeamGrid` mapping (`InstructorsSection`) renders full instructor card grid and hover CTA behavior. | `2_radhakrishnatemple2.0/src/pages-ui/prem-yoga/TeamSection.tsx::InstructorsSection` |
| 7 | Verify About page composition renders `HeroSection`, `Holistic`, `Journey`, and `Volunteer` sections in sequence. | `1_JKYog_2.0/app/about/page.tsx::About` |
| 8 | Verify dynamic event route renders event detail payload for valid slug. | `1_JKYog_2.0/app/events/[slug]/page.tsx` |
| 9 | Verify dynamic CMS slug route returns Not Found UI for missing content. | `1_JKYog_2.0/app/[slug]/page.tsx` |
| 10 | Verify 404 route renders branded not-found content and recovery navigation. | `1_JKYog_2.0/app/not-found.tsx` |

### Remediated Scenarios (Gap Analysis)
> Source: `09-quality-reports/coverage-gap-analysis.md` | Categories: Auth Route Guard, Network Resilience, Empty States, XSS

| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 11 | Verify unauthenticated access to `/profile` and `/dashboard` routes is redirected to the sign-in flow by the Supabase middleware session check. | `1_JKYog_2.0/src/utils/supabase/middleware.ts::updateSession` |
| 12 | Verify `Subscribe` component displays a network-error message when the newsletter signup API call fails due to offline connectivity. | `1_JKYog_2.0/src/components/layout/footer/right-part/subscribe.tsx::Subscribe` |
| 13 | Verify `HeroBanner` renders a loading skeleton while `featuredOnlineClasses` data is being fetched (prop is undefined/null during initial load). | `1_JKYog_2.0/src/pages-view/online-classes/hero-banner/index.tsx::HeroBanner` |
| 14 | Verify `HeroBanner` renders an "No classes available" empty state when `featuredOnlineClasses` prop is an empty array. | `1_JKYog_2.0/src/pages-view/online-classes/hero-banner/index.tsx::HeroBanner` |
| 15 | Verify `InstructorsSection` renders an "No instructors found" empty state when the instructors data array is empty. | `2_radhakrishnatemple2.0/src/pages-ui/prem-yoga/TeamSection.tsx::InstructorsSection` |
| 16 | Verify footer newsletter `Subscribe` component rejects email addresses containing XSS payloads in the local part (e.g., `"<script>alert(1)</script>"@example.com`) and does not render unsanitized error messages. | `1_JKYog_2.0/src/components/layout/footer/right-part/subscribe.tsx::Subscribe` |

### Network Chaos — Resilience Scenarios
> These 5 scenarios must be adapted per component. Replace `[COMPONENT_NAME]` and `[FILE_PATH]` with the component under test.

| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| NC-1 | Verify `Subscribe` displays a user-friendly error toast/banner when a primary API call fails with HTTP 500 (server error). | `1_JKYog_2.0/src/components/layout/footer/right-part/subscribe.tsx` |
| NC-2 | Verify `Subscribe` displays a "You are offline" banner or toast when `navigator.onLine` is false and an API call is attempted. | `1_JKYog_2.0/src/components/layout/footer/right-part/subscribe.tsx` |
| NC-3 | Verify `Subscribe` shows a retry button after a network timeout (simulated 10s delay) and successfully recovers on retry. | `1_JKYog_2.0/src/components/layout/footer/right-part/subscribe.tsx` |
| NC-4 | Verify `Subscribe` does not lose user-entered form data when a transient network error occurs during submission — form fields retain their values after the error. | `1_JKYog_2.0/src/components/layout/footer/right-part/subscribe.tsx` |
| NC-5 | Verify `Subscribe` gracefully handles HTTP 429 (rate limit) by showing a "Please wait" message and not firing additional requests while throttled. | `1_JKYog_2.0/src/components/layout/footer/right-part/subscribe.tsx` |

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

For 1_JKYog_2.0/src/utils/supabase/middleware.ts — generate 1 test case:
1. Simulate a request to /profile without any Supabase session cookies; assert the middleware does not set a valid session and downstream page renders sign-in redirect.

For 1_JKYog_2.0/src/components/layout/footer/right-part/subscribe.tsx — generate 1 test case:
1. Mock fetch to reject with TypeError('Failed to fetch'); submit a valid email; assert an error message appears in the UI.

For 1_JKYog_2.0/src/pages-view/online-classes/hero-banner/index.tsx — generate 2 test cases:
1. Render HeroBanner with featuredOnlineClasses=undefined; assert a loading skeleton or placeholder is visible.
2. Render HeroBanner with featuredOnlineClasses=[]; assert "No classes available" or equivalent empty-state text is shown.

For 2_radhakrishnatemple2.0/src/pages-ui/prem-yoga/TeamSection.tsx — generate 1 test case:
1. Render InstructorsSection with instructors=[]; assert "No instructors found" or equivalent empty-state text is shown.

Simulate Offline Mode and Simulate API Errors for newsletter and page-data endpoints.

Output the code for React Testing Library + Jest / Playwright.
```

### TestSprite Prompt for Network Chaos
```text
Act as a Senior SDET. Read ../docs/00-context.md.

For 1_JKYog_2.0/src/components/layout/footer/right-part/subscribe.tsx — generate 5 resilience test cases:
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
- Donations Landing Page: `1_JKYog_2.0/app/donations/page.tsx`
- Online Classes Page: `1_JKYog_2.0/src/pages-view/online-classes/` (index + subcomponents)
- Retreats Page: `1_JKYog_2.0/app/retreats/page.tsx`
- Social Media Page: `1_JKYog_2.0/app/social-media/page.tsx`

### Phase 2 Scenarios
| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 17 | Verify Donations landing page (`/donations`) renders donation categories, suggested amounts, and a "Make a Donation" CTA that navigates to `/make-donation`. | `1_JKYog_2.0/app/donations/page.tsx` |
| 18 | Verify Donations page renders an empty state or fallback when the donation categories API returns an empty array. | `1_JKYog_2.0/app/donations/page.tsx` |
| 19 | Verify Online Classes page renders class listing cards with `Title`, `InstructorName`, `Schedule`, and `JoinNow` CTA for each class. | `1_JKYog_2.0/src/pages-view/online-classes/index.tsx` |
| 20 | Verify Online Classes page filters by `OnlineClassCategory` and the category selector updates the displayed class list. | `1_JKYog_2.0/src/pages-view/online-classes/index.tsx` |
| 21 | Verify Online Classes page renders schedule entries with correct timezone display and "Join via Zoom" link for active classes. | `1_JKYog_2.0/src/pages-view/online-classes/index.tsx` |
| 22 | Verify Online Classes page renders "No classes available" empty state when the classes API returns an empty array. | `1_JKYog_2.0/src/pages-view/online-classes/index.tsx` |
| 23 | Verify Retreats page (`/retreats`) renders retreat cards with `title`, `location`, `date range`, and `Register` CTA linking to the correct event registration route. | `1_JKYog_2.0/app/retreats/page.tsx` |
| 24 | Verify Retreats page renders "No retreats available" empty state when the retreats API returns an empty array. | `1_JKYog_2.0/app/retreats/page.tsx` |
| 25 | Verify Social Media page (`/social-media`) renders embedded social feed widgets (YouTube, Instagram) and links open in new tabs. | `1_JKYog_2.0/app/social-media/page.tsx` |
| 26 | Verify all new pages (`/donations`, `/online-classes`, `/retreats`, `/social-media`) include `Header` and `Footer` layout components and do not flash unstyled content (FOUC). | `1_JKYog_2.0/src/components/layout/` |

### TestSprite Prompt for Phase 2
```text
Act as a Senior SDET. Read ../docs/00-context.md.

For 1_JKYog_2.0/app/donations/page.tsx — generate 2 test cases:
1. Navigate to /donations; assert donation category cards render with amounts and "Make a Donation" CTA.
2. Mock donations API to return []; assert empty state message is displayed.

For 1_JKYog_2.0/src/pages-view/online-classes/index.tsx — generate 3 test cases:
1. Navigate to /online-classes; assert class cards render with Title, InstructorName, Schedule.
2. Select a category filter; assert displayed classes match the selected category.
3. Mock classes API to return []; assert "No classes available" empty state.

For 1_JKYog_2.0/app/retreats/page.tsx — generate 2 test cases:
1. Navigate to /retreats; assert retreat cards render with title, location, date range.
2. Mock retreats API to return []; assert "No retreats available" empty state.

For 1_JKYog_2.0/app/social-media/page.tsx — generate 1 test case:
1. Navigate to /social-media; assert social feed widgets render and external links have target="_blank".

Output the code for Playwright / React Testing Library + Jest.
```

## Deliverable
- [ ] Completed test files committed to the `testing/` directory.
- [ ] Each scenario from the Remediated Scenarios table covered by at least one test case.
- [ ] Each scenario from the Remediated Scenarios (Gap Analysis) table covered by at least one test case.
- [ ] All Network Chaos scenarios (NC-1 to NC-5) covered by at least one test case.
- [ ] Each Phase 2 scenario (17-26) covered by at least one test case.
- [ ] All tests pass locally before submission.
