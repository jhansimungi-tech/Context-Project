# Test Automation Research Summary: JKYog & Radha Krishna Temple

This document summarizes the research and recommendations for stabilizing the regression suite for the JKYog multi-repo ecosystem (Temple Frontend, Main Frontend, Backend API, and Strapi CMS).

---

## 1. Analysis of Current Failure Categories

The current suite faces a **34.8% pass rate** due to several systemic bottlenecks. Below are the recommended fixes:

| Category | Root Cause | Recommendation |
|----------|------------|----------------|
| **Donation API** | Backend/API unreachable | **Network Stubbing:** Use Playwright's `page.route` to intercept API calls and return local JSON fixtures. |
| **Authentication** | Magic-link/Passwordless | **Auth Bypass:** Implement a test-only login endpoint or inject pre-authenticated cookies into the browser context. |
| **Zoom Integration** | SDK Timeouts | **SDK Mocking:** Stub the Zoom Web SDK init functions to simulate a "joined" state without launching real meetings. |
| **Backend Auth** | 500 instead of 401 | **Exception Mapping:** Ensure NestJS/Express guards throw `UnauthorizedException` to be caught by global filters. |
| **Logic/UX** | Modal/Date Assertion Mismatch | **Behavior Alignment:** Assert modal visibility/detachment rather than page content; test fixed-date cards instead of calendar pickers. |

---

## 2. Comparative Testing Approaches

Based on the research, four distinct automation strategies were identified to replace or augment the current TestSprite implementation:

### A. Code-First Framework (Playwright/Cypress)

| | |
|---|---|
| **Best For** | Deep integration, complex auth flows, and multi-repo orchestration |
| **Key Advantage** | Full control over the network layer and "Heal-on-Failure" logic through code |
| **Cost** | Free (Open-source); you only pay for CI/CD infrastructure |

### B. No-Code/Visual Testing (Rainforest QA)

| | |
|---|---|
| **Best For** | High-level smoke tests and non-technical stakeholder visibility |
| **Key Advantage** | Uses visual AI to "see" the page like a human; excellent for cross-browser visual verification |
| **Cost** | Usage-based (Avg. ~$94k/year); scales with test-hours |

### C. Low-Code SaaS (Testsigma)

| | |
|---|---|
| **Best For** | Rapid test creation without deep coding skills while maintaining structured reporting |
| **Key Advantage** | Built-in cloud grid and self-healing locators |
| **Cost** | Subscription-based; typically mid-to-high five figures |

### D. Model-Based Enterprise (Tricentis Tosca)

| | |
|---|---|
| **Best For** | Large-scale enterprise environments with non-web components (SAP, Legacy) |
| **Key Advantage** | High reusability through "Scanning" UI modules |
| **Cost** | High ($10k–$70k+ per license); best for large corporate budgets |

---

## 3. Recommended Multi-App CI Strategy

To manage the four repositories (Temple, Main, API, CMS), a layered orchestration is recommended:

1. **Orchestration:** Use `docker-compose` or Playwright's `webServer` config to start all three local ports (3000, 3001, 3002) before the suite begins.
2. **Tagging:** Use `@smoke`, `@regression`, and `@api` tags to separate fast, mocked tests from slow, integration-heavy tests.
3. **Environment Stability:** Use a dedicated "Test/Staging" Strapi instance with seeded data to ensure "Sponsorship" and "Seva" sections always have content to assert against.

---

## 4. Summary Table of Tools

| Tool | Approach | User Persona | Cost |
|------|----------|-------------|------|
| **Playwright** | Code-First | Developers / SDET | $0 (Open Source) |
| **TestSprite** | Recorder/Low-Code | QA Testers | Commercial Subscription |
| **Testsigma** | Low-Code SaaS | Manual Testers / QA | Quote-based (Mid-tier) |
| **Tosca** | Model-Based | Enterprise QA | Very High (Enterprise) |
| **Rainforest QA** | Visual/No-Code | Product / QA | Usage-based ($/hr) |

---

## 5. Practical Alternatives to TestSprite

Here are practical alternatives to how the tests were automated with TestSprite, focusing on avoiding the specific issues encountered.

### 5.1 Use Code-First Playwright Tests with Fixtures

Instead of relying on TestSprite's recorded flows, move to code-first Playwright tests with shared fixtures and helpers. This gives you control over auth, mocking, multi-repo setup, and flakiness.

**Key patterns:**

- Create **page-object–lite helpers** (functions, not heavy page-object classes) for common flows like "donate Seva", "sponsor Puja", "manage subscription".
- Use Playwright fixtures for:
  - "logged-in temple user"
  - "logged-in main-site user"
  - "mocked Seva API"

so every test starts from a known, stable state.

This avoids brittle, recorder-style steps and lets you programmatically solve the magic-link, backend, and Zoom issues instead of fighting the tool.

### 5.2 Replace Backend Dependencies with Explicit Mocks/Stubs

Instead of letting the tool depend on whatever happens to be running, explicitly mock network calls in the test code.

**Alternatives:**

- **Playwright API mocking** for donation/Seva, sponsorship, ticket availability:
  - `page.route('**/api/seva-opportunities', ...)` with fixture JSON.
  - Similar for sponsorship lists, ticket products, etc.
- **Component or Storybook tests** for complex UI (like date cards, stepper) that mount the component and mock API via props or Storybook stories, tested with Playwright component runner or Cypress component testing.

**Result:** Your tests don't fail just because localhost:3001 or Strapi weren't up or seeded.

### 5.3 Explicit Test-Only Auth Mechanisms

Instead of trying to drive the real magic-link UI from a recorder tool, introduce test-only auth flows and call them directly from code tests.

**Alternatives:**

- **Test-only login endpoints:** `POST /test/login` that sets auth cookies for a known user, only enabled in `NODE_ENV=test`.
- Playwright/Cypress `request.post` this endpoint, then inject cookies into the browser context.
- Bypass email entirely for most regression tests; keep a small separate suite that validates the real magic-link via MailSlurp/Mailosaur when needed.

This sidesteps TestSprite's limitation with passwordless flows and gives you deterministic logins.

### 5.4 Use a Different Tooling Mix for Different Layers

Split the problem instead of forcing everything through one E2E tool.

**Examples:**

- **API tests** (backend/Strapi) with pytest + requests or Playwright's `APIRequestContext`:
  - Validate 401 vs 500, CSRF, data contracts without a browser.
- **UI-only tests** (Next.js frontends) with Playwright or Cypress:
  - Focus on rendering, navigation, and basic flows using mocked APIs.
- **No-/low-code tool only for smoke:**
  - Keep something like TestSprite / Testsigma / mabl for a few high-level smoke checks across production; put the detailed regression in code-based tests where you can mock and control state.

This reduces the burden on any one tool and avoids TestSprite's constraints around ports, logins, and special UIs.

### 5.5 Strengthen Locators and Reduce Flakiness

Instead of recorder-generated selectors, adopt a locator strategy and flake-defense patterns.

**Alternatives:**

- Use **stable attributes:** `data-testid="donation-stepper"`, `data-testid="sponsorship-card"`, etc., and `getByRole` where possible.
- Add a **"page contract" check** at the start of each test (e.g., key sections are visible) and abort early if it fails instead of letting follow-up steps cascade.
- In CI, use: retries, `--repeat-each` on new tests to detect flakiness before merging, and Playwright traces/video for debugging.

This directly addresses the kind of brittle failures often seen with recorder-based suites.

### 5.6 Alternative Frameworks and Services (If You Want Less Code)

If you still want something higher-level than raw Playwright, there are platforms that layer on top with better control than TestSprite.

**Examples:**

- **Testsigma / testRigor / RainforestQA:** Codeless/low-code tests with API mocking, self-healing locators, and CI integration.
- Can be combined with Playwright/Cypress for the trickier auth, Zoom, multi-URL, and port-specific flows.
- Use such a tool for simple temple/main smoke journeys, and keep complex regression tests in Playwright where you fully control auth and network.

### 5.7 Multi-App Orchestration Without TestSprite

Instead of letting TestSprite drive against random ports, control startup and routing in code.

**Alternatives:**

- Use Playwright's **multi-project config** with `webServer` entries to start temple (3000), main app (3002), backend (3001), Strapi, or run all four via `docker-compose` before tests.
- **Tag tests** (`@temple`, `@main`, `@backend`) and run them in separate CI jobs or matrix entries with the right services started.

This avoids the "target not running" timeouts TestSprite saw and gives you explicit control over environment setup.

---

## 6. Alternative Automation Approaches (Beyond TestSprite)

A condensed reference for migration from TestSprite to code-first automation:

| # | Approach | Key Points |
|---|----------|------------|
| 1 | **Code-First Playwright Test Suite** | Reusable helpers for donation, sponsorship, profile. Fixtures for logged-in temple/main users and mocked Seva/sponsorship/ticket APIs. Full control over auth, mocks, timing, multi-repo env. Stronger locators (`data-testid`, roles). |
| 2 | **Explicit Mocking of Backend & External Services** | Intercept donation/Seva, sponsorship, ticket endpoints. Mock Zoom Web SDK instead of real Zoom in main regression. Keep a small, slower suite for real integrations. |
| 3 | **Test-Only Auth Flows** | `POST /test/login` → sets session cookies. Use in tests for authenticated state. Reserve real magic-link tests for a separate suite against a test inbox. |
| 4 | **Layered Test Strategy** | API tests (pytest, APIRequestContext). UI tests (Playwright/Cypress). Optional low-/no-code (Rainforest QA, Testsigma) for high-level smoke. |
| 5 | **Strong Locator & Flake-Resistance Strategy** | Prefer `data-testid`, `getByRole`. Use retries, `--repeat-each`. Capture traces, videos, logs for failing tests in CI. |

---

## 7. Multi-App E2E Strategy (Temple, Main, Backend, Strapi)

### Goals

Run tests against:

- **Temple frontend** — Next.js, `localhost:3000`
- **Main frontend** — Next.js, `localhost:3002`
- **Backend API** — Nest/Express, `localhost:3001`
- **Strapi CMS** — port depends on config

### Recommended Setup

Use a code-based test runner (e.g., Playwright) with **multiple projects**:

| Project | baseURL |
|---------|---------|
| `temple-frontend` | `http://localhost:3000` |
| `main-frontend` | `http://localhost:3002` |
| `backend-api` | `http://localhost:3001` |

**Service startup:** Use `webServer` config per project, or `docker-compose up` in CI before tests.

**Tag tests by scope:** `@temple`, `@main`, `@backend`, `@zoom-optional`, `@real-api`.

**CI pipeline:**

| Suite | Trigger | Scope |
|-------|---------|-------|
| **Fast suite** | Every PR | Mocked APIs, no Zoom |
| **Full suite** | Nightly or before release | Real APIs, Zoom, staging |

---

*Research summary derived from analysis of JKYog regression test failures and industry best practices.*
