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

*Research summary derived from analysis of JKYog regression test failures and industry best practices.*
