# Mission: Tanmay — Slider/Testimonial/GlobalConfig/Navigation

## Zero-Generic Policy
- Every scenario must cite exact schema/controller/router files.
- No generic wording like "test config" or "test navigation".

## Reference Documentation
- [Architectural Context](../docs/00-context.md)
- [Repo Setup](../docs/01-setup.md)

## Mandatory Content-Type Targets
- Slider: `4_JKYog_Strapi/src/api/carousel/content-types/carousel/schema.json` and `4_JKYog_Strapi/src/api/gift-shop-banner/content-types/gift-shop-banner/schema.json`
- Testimonial: `4_JKYog_Strapi/src/api/testimonial/content-types/testimonial/schema.json`
- GlobalConfig (implementation mapping):
  - `4_JKYog_Strapi/src/api/giftshop-header-config/content-types/giftshop-header-config/schema.json`
  - `4_JKYog_Strapi/src/api/giftshop-payment-config/content-types/giftshop-payment-config/schema.json`
- Navigation:
  - `4_JKYog_Strapi/src/api/navbar/content-types/navbar/schema.json`
  - `4_JKYog_Strapi/src/api/web-app-mega-menu/content-types/web-app-mega-menu/schema.json`

## Remediated Scenarios
| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 1 | Verify Slider `carousel.avatar` media field is required and rejects create without media. | `4_JKYog_Strapi/src/api/carousel/content-types/carousel/schema.json::attributes.avatar` |
| 2 | Verify GiftShop Main Slider stores `banner_image` media and optional `banner_url` link as expected. | `4_JKYog_Strapi/src/api/gift-shop-banner/content-types/gift-shop-banner/schema.json` |
| 3 | Verify Testimonial `Text` is required and create/update fails when empty. | `4_JKYog_Strapi/src/api/testimonial/content-types/testimonial/schema.json::attributes.Text` |
| 4 | Verify Testimonial relation wiring for `Events` (manyToMany with `appevent`) persists correctly. | `4_JKYog_Strapi/src/api/testimonial/content-types/testimonial/schema.json::attributes.Events` |
| 5 | Verify GlobalConfig header single type accepts logo media upload and returns populated media URL in API response. | `4_JKYog_Strapi/src/api/giftshop-header-config/content-types/giftshop-header-config/schema.json::attributes.logo` |
| 6 | Verify GlobalConfig payment single type persists `Googlepay` JSON and `PaypalClientId` string values. | `4_JKYog_Strapi/src/api/giftshop-payment-config/content-types/giftshop-payment-config/schema.json` |
| 7 | Verify Navigation `Navbar.Title` is required and enforces minimum length >= 1. | `4_JKYog_Strapi/src/api/navbar/content-types/navbar/schema.json::attributes.Title` |
| 8 | Verify Navigation `Navbar.Links` repeatable component (`navbar.navbar-link`) supports multi-item ordering. | `4_JKYog_Strapi/src/api/navbar/content-types/navbar/schema.json::attributes.Links` |
| 9 | Verify GiftShop Mega Menu (`menuItems` JSON) accepts valid hierarchy payload and rejects malformed JSON. | `4_JKYog_Strapi/src/api/web-app-mega-menu/content-types/web-app-mega-menu/schema.json::attributes.menuItems` |
| 10 | Verify core controllers expose CRUD for slider/testimonial/navigation/global config APIs. | `4_JKYog_Strapi/src/api/testimonial/controllers/testimonial.js`, `4_JKYog_Strapi/src/api/navbar/controllers/navbar.js`, `4_JKYog_Strapi/src/api/giftshop-header-config/controllers/giftshop-header-config.js` |

### Remediated Scenarios (Gap Analysis)
> Source: `09-quality-reports/coverage-gap-analysis.md` | Categories: RBAC, Malicious Upload, Transactional Integrity

| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 11 | Verify Strapi RBAC: an `Editor` role user can create/update carousel entries but cannot `delete` them; only `Admin` role can delete — assert 403 for Editor on DELETE /carousels/:id. | `4_JKYog_Strapi/src/api/carousel/controllers/carousel.js::createCoreController` |
| 12 | Verify carousel `avatar` media upload rejects a file with `.exe` extension disguised as `.png` (magic-byte mismatch) — Strapi returns 400 or strips the upload. | `4_JKYog_Strapi/src/api/carousel/content-types/carousel/schema.json::attributes.avatar` |
| 13 | Verify carousel `avatar` media upload rejects files exceeding Strapi's configured `sizeLimit` (default 200MB) with a clear 413 or 400 error. | `4_JKYog_Strapi/src/api/carousel/content-types/carousel/schema.json::attributes.avatar` |
| 14 | Verify bulk update of 20 testimonial entries in a single transactional batch either all succeed or all fail — partial updates do not persist if the 10th entry has invalid `Text` (empty required field). | `4_JKYog_Strapi/src/api/testimonial/controllers/testimonial.js::createCoreController` |

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

For 4_JKYog_Strapi/src/api/carousel/controllers/carousel.js — generate 1 test case:
1. Authenticate as Editor role; send DELETE /carousels/:id; assert 403 Forbidden. Authenticate as Admin; assert 200.

For 4_JKYog_Strapi/src/api/carousel/content-types/carousel/schema.json — generate 2 test cases:
1. Upload a file named 'malware.png' whose first bytes are MZ (PE executable magic bytes); assert Strapi rejects the upload.
2. Upload a 250MB image file to the avatar field; assert 413 or 400 payload-too-large error.

For 4_JKYog_Strapi/src/api/testimonial/controllers/testimonial.js — generate 1 test case:
1. Attempt to update 20 testimonials in batch where entry #10 has Text=''; assert the entire batch fails and none of the 20 updates persist.

Simulate API Errors for all Strapi CMS endpoints.

Output the code for Jest + Supertest (Strapi test environment).
```

---

## Phase 2 — Regression Expansion

### Phase 2 Mandatory Targets
- Live Stream: `4_JKYog_Strapi/src/api/live-stream/content-types/live-stream/schema.json`
- Retreat: `4_JKYog_Strapi/src/api/retreat/content-types/retreat/schema.json`
- App Challenge: `4_JKYog_Strapi/src/api/app-challenge/content-types/app-challenge/schema.json`
- App Challenge Day: `4_JKYog_Strapi/src/api/app-challenge-day/content-types/app-challenge-day/schema.json`
- REST Cache Plugin: `4_JKYog_Strapi/config/plugins.js::strapi-plugin-rest-cache`
- Custom Middleware:
  - `4_JKYog_Strapi/src/middlewares/errorHandler.js`
  - `4_JKYog_Strapi/src/middlewares/connectionMonitor.js`
- Cron Job: `4_JKYog_Strapi/src/api/normalized-class-schedule/services/normalized-class-schedule.js::syncNormalizedSchedules`
- Meilisearch Config: `4_JKYog_Strapi/config/plugins.js::meilisearch`

### Phase 2 Scenarios
| # | Scenario | Exact Code Target |
|---|----------|-------------------|
| 15 | Verify Live Stream schema enforces required `Title` and `StreamUrl`; create without `StreamUrl` returns 400. | `4_JKYog_Strapi/src/api/live-stream/content-types/live-stream/schema.json` |
| 16 | Verify Live Stream CRUD lifecycle: create → update `Title` → delete; confirm response codes and data persistence. | `4_JKYog_Strapi/src/api/live-stream/routes/live-stream.js` |
| 17 | Verify Retreat schema enforces required `title`, `start_date`/`end_date` datetime fields, and `location`; create without `title` returns 400. | `4_JKYog_Strapi/src/api/retreat/content-types/retreat/schema.json` |
| 18 | Verify Retreat CRUD lifecycle and confirm `populate=deep` returns nested event components. | `4_JKYog_Strapi/src/api/retreat/routes/retreat.js` |
| 19 | Verify App Challenge schema enforces required `Title`, `StartDate`/`EndDate`, and `LinkedChallengeDays` relation; create without `Title` returns 400. | `4_JKYog_Strapi/src/api/app-challenge/content-types/app-challenge/schema.json` |
| 20 | Verify App Challenge Day schema enforces required `DayNumber` (positive integer) and `Content` field; create with `DayNumber=0` or negative returns 400. | `4_JKYog_Strapi/src/api/app-challenge-day/content-types/app-challenge-day/schema.json` |
| 21 | Verify REST cache plugin returns cached response (matching `ETag`/`Cache-Control` headers) on repeated `GET /api/testimonials` within 1-hour TTL window. | `4_JKYog_Strapi/config/plugins.js::strapi-plugin-rest-cache` |
| 22 | Verify REST cache plugin invalidates cache on `PUT /api/testimonials/:id` (update) and `DELETE /api/testimonials/:id` — subsequent GET returns fresh data. | `4_JKYog_Strapi/config/plugins.js::strapi-plugin-rest-cache` |
| 23 | **[BUG CANDIDATE]** Verify REST cache plugin invalidates cache on `POST /api/testimonials` (create) — the current configuration only invalidates on update/delete, so a newly created testimonial may not appear in cached GET responses until TTL expires. Document if this is a bug. | `4_JKYog_Strapi/config/plugins.js::strapi-plugin-rest-cache` |
| 24 | Verify `errorHandler` middleware catches `ECONNRESET` errors and returns HTTP 503 with `{ error: 'Service temporarily unavailable' }` instead of crashing the server. | `4_JKYog_Strapi/src/middlewares/errorHandler.js` |
| 25 | Verify `errorHandler` middleware catches Strapi `ApplicationError` and returns HTTP 400 with the original error message. | `4_JKYog_Strapi/src/middlewares/errorHandler.js` |
| 26 | Verify `connectionMonitor` middleware tracks HTTP request count and resets hourly; confirm `requestCount` increments on each API call. | `4_JKYog_Strapi/src/middlewares/connectionMonitor.js` |
| 27 | Verify `syncNormalizedSchedules` cron job converts `OnlineClassSchedule` timezone-aware entries to UTC `NormalizedClassSchedule` entries — spot-check at least 3 timezone conversions (EST, PST, IST). | `4_JKYog_Strapi/src/api/normalized-class-schedule/services/normalized-class-schedule.js::syncNormalizedSchedules` |
| 28 | **[SECURITY]** Verify Meilisearch API key in `config/plugins.js` is sourced from environment variable and not hardcoded — assert `process.env.MEILISEARCH_API_KEY` is referenced (or flag hardcoded key as a finding). | `4_JKYog_Strapi/config/plugins.js::meilisearch` |

### TestSprite Prompt for Phase 2
```text
Act as a Senior SDET. Read ../docs/00-context.md.

For Live Stream content type — generate 2 test cases:
1. POST /live-streams with valid Title and StreamUrl; assert 200. POST without StreamUrl; assert 400.
2. Full CRUD lifecycle: create → update → delete → GET returns 404.

For Retreat content type — generate 2 test cases:
1. POST /retreats with valid title, start_date, end_date, location; assert 200. POST without title; assert 400.
2. GET /retreats/:id?populate=deep; assert nested components populated.

For App Challenge content types — generate 2 test cases:
1. POST /app-challenges with valid Title, StartDate, EndDate; assert 200. POST without Title; assert 400.
2. POST /app-challenge-days with DayNumber=0; assert 400. POST with DayNumber=1 and Content; assert 200.

For REST cache plugin — generate 3 test cases:
1. GET /api/testimonials twice within 60s; assert second response has matching ETag or is faster (cache hit).
2. PUT /api/testimonials/:id then GET; assert fresh data (cache invalidated).
3. POST /api/testimonials then GET list; document whether new entry appears (test for cache-create invalidation bug).

For custom middlewares — generate 2 test cases:
1. Simulate ECONNRESET error in a route handler; assert 503 response (not 500 crash).
2. Send 5 sequential API requests; assert connectionMonitor requestCount incremented to 5.

For syncNormalizedSchedules — generate 1 test case:
1. Create OnlineClassSchedule entries in EST, PST, and IST timezones; trigger cron; assert NormalizedClassSchedule entries have correct UTC conversion.

Output the code for Jest + Supertest (Strapi test environment).
```

## Deliverable
- [ ] Completed test files committed to the `testing/` directory.
- [ ] Each scenario from the Remediated Scenarios table covered by at least one test case.
- [ ] Each scenario from the Remediated Scenarios (Gap Analysis) table covered by at least one test case.
- [ ] Each Phase 2 scenario (15-28) covered by at least one test case.
- [ ] **[SECURITY]** Scenario 28 (Meilisearch Hardcoded Key) test MUST flag the finding.
- [ ] All tests pass locally before submission.
