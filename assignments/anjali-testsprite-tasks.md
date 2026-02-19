# Mission: Anjali — User & Learning

## Zero-Generic Policy
- Every scenario must cite an exact file plus function/component.
- No generic statements like "test login" or "test profile".

## Reference Documentation
- [Architectural Context](../docs/00-context.md)
- [Repo Setup](../docs/01-setup.md)

## Mandatory Component Targets
- LoginForm (implementation mapping): `1_JKYog_2.0/src/components/modal/sign-in-view.tsx::SignInView`
- UserProfileCard (implementation mapping): `1_JKYog_2.0/src/pages-view/profile/right-part/family-tab/member-card.tsx::MemberCard` and `::UserCard`
- ClassProgressWidget (implementation mapping): `1_JKYog_2.0/src/pages-view/courses/components/LessonProgressTracker.tsx::LessonProgressTracker`

## Remediated Scenarios
| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 1 | Verify `LoginForm` mapping (`SignInView`) enforces valid email before calling `supabase.auth.signInWithOtp`. | `1_JKYog_2.0/src/components/modal/sign-in-view.tsx::onSignInFormSubmit` |
| 2 | Verify OTP verification enforces 6-digit numeric token and blocks invalid formats. | `1_JKYog_2.0/src/components/modal/sign-in-view.tsx::onVerifySubmit` |
| 3 | Verify OAuth sign-in builds `redirectTo` correctly for `google` and `apple` providers. | `1_JKYog_2.0/src/components/modal/sign-in-view.tsx::signInWithOAuth` |
| 4 | Verify `UserProfileCard` mapping (`MemberCard`) delete action calls `deleteFamilyMember(id)` and refreshes store data. | `1_JKYog_2.0/src/pages-view/profile/right-part/family-tab/member-card.tsx::MemberCard` |
| 5 | Verify `UserProfileCard` mapping (`UserCard`) renders avatar/name from `useUserStore().accountDetails`. | `1_JKYog_2.0/src/pages-view/profile/right-part/family-tab/member-card.tsx::UserCard` |
| 6 | Verify profile details validation rejects malformed personal data before submit. | `1_JKYog_2.0/src/pages-view/profile/right-part/details-tab/validation.ts` |
| 7 | Verify `ClassProgressWidget` mapping (`LessonProgressTracker`) renders completion toast from `completionToast` props path. | `1_JKYog_2.0/src/pages-view/courses/components/LessonProgressTracker.tsx::LessonProgressTracker` |
| 8 | Verify `LessonProgressTracker` context fallback path reads `useLessonPlayer()` without crashing when provider exists. | `1_JKYog_2.0/src/pages-view/courses/components/LessonProgressTracker.tsx::LessonProgressTrackerFromContext` |
| 9 | Verify lesson-level progress API updates persist and hydrate on reload. | `1_JKYog_2.0/src/api/lms-progress/index.ts` |
| 10 | Verify lesson route renders tracked progress and guarded lesson player state. | `1_JKYog_2.0/app/courses/[slug]/[module]/[lesson]/page.tsx` |

### Remediated Scenarios (Gap Analysis)
> Source: `09-quality-reports/coverage-gap-analysis.md` | Categories: Session Expiry, Network Resilience, Empty States, OAuth Failure

| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 11 | Verify `SignInView` detects an expired Supabase session during an active page session and redirects the user to the sign-in modal with an "Session expired" toast message. | `1_JKYog_2.0/src/components/modal/sign-in-view.tsx::onVerifySubmit` |
| 12 | Verify `onSignInFormSubmit` displays a network-error toast when `supabase.auth.signInWithOtp` rejects due to offline connectivity (simulated `TypeError: Failed to fetch`). | `1_JKYog_2.0/src/components/modal/sign-in-view.tsx::onSignInFormSubmit` |
| 13 | Verify `LessonProgressTracker` renders a loading/skeleton state when `useLessonPlayer()` context returns `completionToast` as undefined during initial hydration. | `1_JKYog_2.0/src/pages-view/courses/components/LessonProgressTracker.tsx::LessonProgressTrackerFromContext` |
| 14 | Verify the lessons list container renders an "No lessons available" empty state when the lessons API returns an empty array. | `1_JKYog_2.0/src/api/lms-progress/index.ts` |
| 15 | Verify `signInWithOAuth` handles provider failure (Google/Apple returning error in redirect callback) by displaying an error toast instead of a blank screen. | `1_JKYog_2.0/src/components/modal/sign-in-view.tsx::signInWithOAuth` |

### Network Chaos — Resilience Scenarios
> These 5 scenarios must be adapted per component. Replace `[COMPONENT_NAME]` and `[FILE_PATH]` with the component under test.

| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| NC-1 | Verify `SignInView` displays a user-friendly error toast/banner when a primary API call fails with HTTP 500 (server error). | `1_JKYog_2.0/src/components/modal/sign-in-view.tsx` |
| NC-2 | Verify `SignInView` displays a "You are offline" banner or toast when `navigator.onLine` is false and an API call is attempted. | `1_JKYog_2.0/src/components/modal/sign-in-view.tsx` |
| NC-3 | Verify `SignInView` shows a retry button after a network timeout (simulated 10s delay) and successfully recovers on retry. | `1_JKYog_2.0/src/components/modal/sign-in-view.tsx` |
| NC-4 | Verify `SignInView` does not lose user-entered form data when a transient network error occurs during submission — form fields retain their values after the error. | `1_JKYog_2.0/src/components/modal/sign-in-view.tsx` |
| NC-5 | Verify `SignInView` gracefully handles HTTP 429 (rate limit) by showing a "Please wait" message and not firing additional requests while throttled. | `1_JKYog_2.0/src/components/modal/sign-in-view.tsx` |

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

For 1_JKYog_2.0/src/components/modal/sign-in-view.tsx — generate 3 test cases:
1. Mock supabase.auth.getSession to return { data: { session: null } } after initial auth; assert the UI shows "Session expired" toast and redirects to sign-in.
2. Mock supabase.auth.signInWithOtp to reject with TypeError('Failed to fetch'); assert toast.error is called with a network-related message and the form remains submittable.
3. Mock supabase.auth.signInWithOAuth to reject with an error; assert toast.error is called and the component does not crash.

For 1_JKYog_2.0/src/pages-view/courses/components/LessonProgressTracker.tsx — generate 1 test case:
1. Render LessonProgressTrackerFromContext with useLessonPlayer returning { completionToast: undefined }; assert no crash and a loading/skeleton state is visible or component gracefully renders nothing.

For 1_JKYog_2.0/src/api/lms-progress/index.ts — generate 1 test case:
1. Mock the lessons API to return []; assert the parent component renders "No lessons available" text.

Simulate Offline Mode and Simulate API Errors for all auth and lesson-progress endpoints.

Output the code for React Testing Library + Jest.
```

### TestSprite Prompt for Network Chaos
```text
Act as a Senior SDET. Read ../docs/00-context.md.

For 1_JKYog_2.0/src/components/modal/sign-in-view.tsx — generate 5 resilience test cases:
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
- Courses/LMS Browsing Page: `1_JKYog_2.0/app/courses/page.tsx` and `1_JKYog_2.0/src/pages-view/courses/`
- LMS Enrollment API: `1_JKYog_2.0/src/api/courses/` (enrollment check, my-courses)
- Profile Page (Full Coverage): `1_JKYog_2.0/src/pages-view/profile/` (all tabs — details, family, donations, registrations)
- SMEX Dashboard: `1_JKYog_2.0/src/pages-view/smex-dashboard/`
- SMEX Series/Video: `1_JKYog_2.0/src/pages-view/smex-series/` and `1_JKYog_2.0/src/pages-view/smex-video/`

### Phase 2 Scenarios
| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 16 | Verify Courses page (`/courses`) renders course cards with `Title`, `Description`, `Thumbnail`, and `Enroll` CTA for each course. | `1_JKYog_2.0/app/courses/page.tsx` |
| 17 | Verify Courses page shows "Enrolled" badge instead of "Enroll" CTA for courses where the user has an active enrollment. | `1_JKYog_2.0/src/pages-view/courses/index.tsx` |
| 18 | Verify Courses page renders "No courses available" empty state when the courses API returns an empty array. | `1_JKYog_2.0/app/courses/page.tsx` |
| 19 | Verify LMS enrollment check API (`/api/lms/enrollment/check/:courseStrapiId`) returns `enrolled: true/false` for the authenticated user. | `1_JKYog_2.0/src/api/courses/` |
| 20 | Verify LMS my-courses API (`/api/lms/enrollment/my-courses`) returns only courses the authenticated user is enrolled in. | `1_JKYog_2.0/src/api/courses/` |
| 21 | Verify Profile page Details tab renders all personal information fields (name, email, phone, avatar) from `useUserStore().accountDetails`. | `1_JKYog_2.0/src/pages-view/profile/right-part/details-tab/` |
| 22 | Verify Profile page Donations tab renders a list of past donations fetched from `/api/transaction/get-donations-history`. | `1_JKYog_2.0/src/pages-view/profile/right-part/` |
| 23 | Verify Profile page Registrations tab renders a list of past event registrations fetched from the registrations API. | `1_JKYog_2.0/src/pages-view/profile/right-part/` |
| 24 | Verify SMEX Dashboard (`/smex-dashboard`) renders active subscription status, upcoming meetings, and past recordings. | `1_JKYog_2.0/src/pages-view/smex-dashboard/index.tsx` |
| 25 | Verify SMEX Dashboard shows subscription gate/modal for unauthenticated or non-subscribed users. | `1_JKYog_2.0/src/pages-view/smex-dashboard/index.tsx` |
| 26 | Verify SMEX Series page renders video cards grouped by series with `Title`, `Duration`, and `Play` CTA. | `1_JKYog_2.0/src/pages-view/smex-series/index.tsx` |
| 27 | Verify SMEX Video page plays the selected video and renders `Title`, `Description`, and related videos sidebar. | `1_JKYog_2.0/src/pages-view/smex-video/index.tsx` |
| 28 | Verify SMEX Video page shows subscription gate when a non-subscribed user attempts to play gated content. | `1_JKYog_2.0/src/pages-view/smex-video/index.tsx` |

### TestSprite Prompt for Phase 2
```text
Act as a Senior SDET. Read ../docs/00-context.md.

For 1_JKYog_2.0/app/courses/page.tsx — generate 3 test cases:
1. Navigate to /courses; assert course cards render with Title, Description, Thumbnail, Enroll CTA.
2. Mock enrollment check to return enrolled=true for course A; assert "Enrolled" badge appears.
3. Mock courses API to return []; assert "No courses available" empty state.

For Profile page — generate 3 test cases:
1. Navigate to /profile; click Details tab; assert personal info fields render from useUserStore.
2. Click Donations tab; assert donation history list renders from transactions API.
3. Click Registrations tab; assert event registration list renders from registrations API.

For SMEX pages — generate 3 test cases:
1. Navigate to /smex-dashboard as subscribed user; assert subscription status, upcoming meetings, and recordings.
2. Navigate to /smex-dashboard as non-subscribed user; assert subscription gate/modal appears.
3. Navigate to /smex-video/:id as non-subscribed user; assert subscription gate blocks playback.

Output the code for Playwright / React Testing Library + Jest.
```

## Deliverable
- [ ] Completed test files committed to the `testing/` directory.
- [ ] Each scenario from the Remediated Scenarios table covered by at least one test case.
- [ ] Each scenario from the Remediated Scenarios (Gap Analysis) table covered by at least one test case.
- [ ] All Network Chaos scenarios (NC-1 to NC-5) covered by at least one test case.
- [ ] Each Phase 2 scenario (16-28) covered by at least one test case.
- [ ] All tests pass locally before submission.
