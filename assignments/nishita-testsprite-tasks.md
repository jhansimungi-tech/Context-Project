# Mission: Nishita — Content Validation (Article/Blog/Faq/Event)

## Zero-Generic Policy
- Every scenario must reference an exact content-type schema/controller file.
- No generic wording like "test content".

## Reference Documentation
- [Architectural Context](../docs/00-context.md)
- [Repo Setup](../docs/01-setup.md)

## Mandatory Content-Type Targets
- Article: `4_JKYog_Strapi/src/api/apparticle/content-types/apparticle/schema.json`
- Blog: `4_JKYog_Strapi/src/api/web-app-blog/content-types/web-app-blog/schema.json`
- Faq: `4_JKYog_Strapi/src/api/web-app-faq/content-types/web-app-faq/schema.json`
- Event: `4_JKYog_Strapi/src/api/event/content-types/event/schema.json`

## Remediated Scenarios
| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 1 | Verify `ArticleTitle` enforces required/minLength/maxLength constraints (1..256 chars). | `4_JKYog_Strapi/src/api/apparticle/content-types/apparticle/schema.json::attributes.ArticleTitle` |
| 2 | Verify `ArticleSlug` uniqueness and regex rule `^[a-zA-Z0-9-]+$` reject invalid slugs. | `4_JKYog_Strapi/src/api/apparticle/content-types/apparticle/schema.json::attributes.ArticleSlug` |
| 3 | Verify `ImageURL` requires HTTPS/HTTP pattern and rejects malformed URLs. | `4_JKYog_Strapi/src/api/apparticle/content-types/apparticle/schema.json::attributes.ImageURL` |
| 4 | Verify `Language` enum only accepts `en` or `hi` and defaults to `en`. | `4_JKYog_Strapi/src/api/apparticle/content-types/apparticle/schema.json::attributes.Language` |
| 5 | Verify `LinkedTopics` relation is required and fails save when omitted. | `4_JKYog_Strapi/src/api/apparticle/content-types/apparticle/schema.json::attributes.LinkedTopics` |
| 6 | Verify Blog `poster` media field accepts only declared allowed types and handles multi-upload. | `4_JKYog_Strapi/src/api/web-app-blog/content-types/web-app-blog/schema.json::attributes.poster` |
| 7 | Verify Blog `time` field enforces datetime serialization in create/update payloads. | `4_JKYog_Strapi/src/api/web-app-blog/content-types/web-app-blog/schema.json::attributes.time` |
| 8 | Verify FAQ `Questions` and `Answer` persist correctly through core controller CRUD calls. | `4_JKYog_Strapi/src/api/web-app-faq/controllers/web-app-faq.js::createCoreController` |
| 9 | Verify Event `title` is mandatory and create fails without it. | `4_JKYog_Strapi/src/api/event/content-types/event/schema.json::attributes.title` |
| 10 | Verify Event `timezone` accepts only declared enum members (HAST..SGT). | `4_JKYog_Strapi/src/api/event/content-types/event/schema.json::attributes.timezone` |
| 11 | Verify Event `recurrence` accepts only None/Daily/Weekly/Monthly/Yearly/Custom values. | `4_JKYog_Strapi/src/api/event/content-types/event/schema.json::attributes.recurrence` |
| 12 | Verify Event rich-text fields (`Body`, `cost_description`, `event_description_section`) save CKEditor HTML correctly. | `4_JKYog_Strapi/src/api/event/content-types/event/schema.json` |

### Remediated Scenarios (Gap Analysis)
> Source: `09-quality-reports/coverage-gap-analysis.md` | Categories: XSS Sanitization, RBAC, Race Conditions, Transactional Integrity

| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 13 | Verify Article `ArticleBody` rich-text field sanitizes XSS payloads (`<script>alert(1)</script>`, `<img onerror=...>`) on create — stored content must not contain executable script tags. | `4_JKYog_Strapi/src/api/apparticle/content-types/apparticle/schema.json::attributes.ArticleBody` |
| 14 | Verify Strapi RBAC: an `Editor` role user can create/update articles but cannot `delete` them; only `Admin` role can delete — assert 403 for Editor on DELETE /apparticles/:id. | `4_JKYog_Strapi/src/api/apparticle/routes/apparticle.js::createCoreRouter` |
| 15 | Verify two concurrent POST /apparticles requests with the same `ArticleSlug` value — the second request must receive a uniqueness violation error (409 or 400) and not create a duplicate. | `4_JKYog_Strapi/src/api/apparticle/content-types/apparticle/schema.json::attributes.ArticleSlug` |
| 16 | Verify bulk create of 50 FAQ entries in a single transactional batch either all succeed or all fail — partial inserts do not persist on validation failure of the 25th item. | `4_JKYog_Strapi/src/api/web-app-faq/controllers/web-app-faq.js::createCoreController` |

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

For 4_JKYog_Strapi/src/api/apparticle/content-types/apparticle/schema.json — generate 2 test cases:
1. POST /apparticles with ArticleBody containing '<script>alert("xss")</script>' and '<img src=x onerror=alert(1)>'; assert the stored ArticleBody has script tags stripped or escaped.
2. Fire two concurrent POST /apparticles with identical ArticleSlug='test-duplicate-slug'; assert the second request returns 400 or 409 uniqueness error.

For 4_JKYog_Strapi/src/api/apparticle/routes/apparticle.js — generate 1 test case:
1. Authenticate as Editor role; send DELETE /apparticles/:id; assert 403 Forbidden. Then authenticate as Admin; assert 200 OK.

For 4_JKYog_Strapi/src/api/web-app-faq/controllers/web-app-faq.js — generate 1 test case:
1. Submit a batch of 50 FAQ entries where entry #25 has an intentionally invalid Questions field (empty string); assert zero entries are persisted (transactional rollback).

Simulate API Errors for all Strapi content-type endpoints.

Output the code for Jest + Supertest (Strapi test environment).
```

---

## Phase 2 — Regression Expansion

### Phase 2 Mandatory Targets
- LMS Course: `4_JKYog_Strapi/src/api/app-lms-course/content-types/app-lms-course/schema.json`
- LMS Module: `4_JKYog_Strapi/src/api/app-lms-module/content-types/app-lms-module/schema.json`
- LMS Lesson: `4_JKYog_Strapi/src/api/app-lms-lesson/content-types/app-lms-lesson/schema.json`
- App Video: `4_JKYog_Strapi/src/api/app-video/content-types/app-video/schema.json`
- App Audio: `4_JKYog_Strapi/src/api/app-audio/content-types/app-audio/schema.json`
- App Event: `4_JKYog_Strapi/src/api/app-event/content-types/app-event/schema.json`
- App Book: `4_JKYog_Strapi/src/api/app-book/content-types/app-book/schema.json`

### Phase 2 Scenarios
| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 17 | Verify LMS Course schema enforces required `Title`, `Description`, and `LinkedModules` relation; create without `Title` returns 400. | `4_JKYog_Strapi/src/api/app-lms-course/content-types/app-lms-course/schema.json` |
| 18 | Verify LMS Course CRUD: `POST /app-lms-courses` creates a course; `PUT` updates; `DELETE` removes — full lifecycle. | `4_JKYog_Strapi/src/api/app-lms-course/routes/app-lms-course.js` |
| 19 | Verify LMS Module schema enforces required `Title` and `LinkedLessons` relation; create without `LinkedLessons` returns 400. | `4_JKYog_Strapi/src/api/app-lms-module/content-types/app-lms-module/schema.json` |
| 20 | Verify LMS Module CRUD: `POST /app-lms-modules` creates a module linked to a course; `PUT` updates ordering; `DELETE` cascades or orphans cleanly. | `4_JKYog_Strapi/src/api/app-lms-module/routes/app-lms-module.js` |
| 21 | Verify LMS Lesson schema enforces required `Title` and validates `VideoUrl` format; lesson `Type` enum accepts only declared values (video/quiz/review). | `4_JKYog_Strapi/src/api/app-lms-lesson/content-types/app-lms-lesson/schema.json` |
| 22 | Verify LMS Lesson CRUD: `POST /app-lms-lessons` creates a lesson linked to a module; `PUT` updates content; `GET` with `populate=deep` returns full nested structure. | `4_JKYog_Strapi/src/api/app-lms-lesson/routes/app-lms-lesson.js` |
| 23 | Verify App Video schema enforces required `Title`, `VideoUrl`, and `LinkedTopics` relation; `Duration` field accepts only positive integers. | `4_JKYog_Strapi/src/api/app-video/content-types/app-video/schema.json` |
| 24 | Verify App Video CRUD: create with valid payload, update `Title`, delete — verify lifecycle and response codes (201/200/200). | `4_JKYog_Strapi/src/api/app-video/routes/app-video.js` |
| 25 | Verify App Audio schema enforces required `Title` and `AudioFile` media field; create without `AudioFile` returns 400. | `4_JKYog_Strapi/src/api/app-audio/content-types/app-audio/schema.json` |
| 26 | Verify App Audio CRUD lifecycle and confirm `populate=AudioFile` returns media URL with CloudFront CDN path. | `4_JKYog_Strapi/src/api/app-audio/routes/app-audio.js` |
| 27 | Verify App Event schema enforces required `title`, `start_date`/`end_date` datetime fields, and `location` string; create without `title` returns 400. | `4_JKYog_Strapi/src/api/app-event/content-types/app-event/schema.json` |
| 28 | Verify App Event ticketing components (`event-ticket`, `event-addon`, `event-signup`) are populated correctly via `populate=deep` on GET. | `4_JKYog_Strapi/src/api/app-event/content-types/app-event/schema.json` |
| 29 | Verify App Book schema enforces required `Title`, `Author`, and `CoverImage` media; create without `Author` returns 400. | `4_JKYog_Strapi/src/api/app-book/content-types/app-book/schema.json` |
| 30 | Verify App Book CRUD lifecycle and confirm `populate=CoverImage` returns CloudFront CDN media URL. | `4_JKYog_Strapi/src/api/app-book/routes/app-book.js` |

### TestSprite Prompt for Phase 2
```text
Act as a Senior SDET. Read ../docs/00-context.md.

For LMS content types — generate 6 test cases:
1. POST /app-lms-courses with valid Title+Description; assert 200. POST without Title; assert 400.
2. POST /app-lms-modules linked to a course; assert 200. POST without LinkedLessons; assert 400.
3. POST /app-lms-lessons with Type='video' and valid VideoUrl; assert 200. POST with Type='invalid'; assert 400.
4. Full LMS nested query: GET /app-lms-courses/:id?populate=deep; assert modules and lessons are populated.
5. DELETE /app-lms-courses/:id; assert module/lesson relations are handled cleanly (no orphaned references).
6. PUT /app-lms-modules/:id with reordered LinkedLessons; assert updated ordering persists.

For App Video — generate 2 test cases:
1. POST /app-videos with valid Title, VideoUrl, LinkedTopics; assert 200. POST with Duration=-1; assert 400.
2. Full CRUD lifecycle: create → update Title → delete → GET returns 404.

For App Audio — generate 2 test cases:
1. POST /app-audios with valid Title and AudioFile media; assert 200. POST without AudioFile; assert 400.
2. GET /app-audios/:id?populate=AudioFile; assert media URL contains CloudFront CDN path.

For App Event — generate 2 test cases:
1. POST /app-events with valid title, start_date, end_date; assert 200. POST without title; assert 400.
2. GET /app-events/:id?populate=deep; assert ticketing components (event-ticket, event-addon) are populated.

For App Book — generate 2 test cases:
1. POST /app-books with valid Title, Author, CoverImage; assert 200. POST without Author; assert 400.
2. GET /app-books/:id?populate=CoverImage; assert CDN media URL is returned.

Output the code for Jest + Supertest (Strapi test environment).
```

## Deliverable
- [ ] Completed test files committed to the `testing/` directory.
- [ ] Each scenario from the Remediated Scenarios table covered by at least one test case.
- [ ] Each scenario from the Remediated Scenarios (Gap Analysis) table covered by at least one test case.
- [ ] Each Phase 2 scenario (17-30) covered by at least one test case.
- [ ] All tests pass locally before submission.
