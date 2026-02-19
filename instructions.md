# 🧪 TestSprite Execution Guide — Pilot's Manual

> **Version:** 1.0 | **Last Updated:** 2026-02-17
> **Audience:** QA Engineers assigned to the JKYog Regression Suite
> **Total Scenarios:** 274 across 9 assignments (Phase 1 + Phase 2)

---

## 📖 Table of Contents

1. [Getting Started](#-1-getting-started)
2. [TestSprite & MCP Setup](#-2-testsprite--mcp-setup)
3. [Environment Variables](#-3-environment-variables-env)
4. [The Testing Workflow](#-4-the-testing-workflow-the-loop)
5. [Submission Protocol](#-5-submission-protocol-closing-the-loop)
6. [Troubleshooting](#-6-troubleshooting)
7. [Quick Reference](#-7-quick-reference)

---

## 🚀 1. Getting Started

### Before You Write a Single Test

You **must** read these two documents first. They are the foundation everything else builds on.

| Document | Path | What You'll Learn |
|----------|------|-------------------|
| Architecture Context | `testing/docs/00-context.md` | System overview, repo map, how the 4 repos connect |
| Local Dev Setup | `testing/docs/01-setup.md` | How to clone, install, and run each service locally |

### Repos in Scope

We are testing **exactly 4 repositories**. Do not reference or write tests for anything outside this list.

| # | Repo | Stack | You'll Need It If You Test... |
|---|------|-------|-------------------------------|
| 1 | `1_JKYog_2.0` | Next.js / React | Frontend pages, components, Stripe Elements, Supabase Auth |
| 2 | `2_radhakrishnatemple2.0` | Next.js / React | Temple site pages, puja services, calendar, donations |
| 3 | `3_JKYog_2.0_backend` | NestJS / TypeScript | API controllers, guards, services, payment/notification logic |
| 4 | `4_JKYog_Strapi` | Strapi v4 | CMS content types, schemas, CRUD routes, plugins |

### Your Assignment File

Each of you has a dedicated assignment file in `testing/assignments/`:

| Engineer | Assignment File |
|----------|----------------|
| Aditi | `aditi-testsprite-tasks.md` |
| Anjali | `anjali-testsprite-tasks.md` |
| Anusha | `anusha-testsprite-tasks.md` |
| Divyani | `divyani-testsprite-tasks.md` |
| Jhansi | `jhansi-testsprite-tasks.md` |
| Kanan | `kanan-testsprite-tasks.md` |
| Manasi | `manasi-testsprite-tasks.md` |
| Nishita | `nishita-testsprite-tasks.md` |
| Tanmay | `tanmay-testsprite-tasks.md` |

Open yours now. Skim the **Remediated Scenarios** table and the **Phase 2** section to understand the full scope of what you'll be building.

---

## 🔧 2. TestSprite & MCP Setup

### 2.1 Install TestSprite

TestSprite is an AI-powered test generation extension for VS Code and Cursor.

1. Open **VS Code** (or **Cursor**).
2. Go to the **Extensions** panel (`Ctrl+Shift+X` / `Cmd+Shift+X`).
3. Search for **"TestSprite"**.
4. Click **Install**.
5. Reload the editor when prompted.

After installation, you should see the TestSprite icon in your sidebar.

### 2.2 Connect to the MCP Server

The **Model Context Protocol (MCP)** server allows TestSprite to read the codebase structure directly — file trees, imports, types, and schemas — so it generates accurate tests instead of guessing.

**Steps:**

1. Open the TestSprite settings panel (click the TestSprite icon in the sidebar → gear icon).
2. Under **MCP Configuration**, set the server URL to the local MCP endpoint provided by your team lead.
3. Click **Connect** and wait for the green "Connected" indicator.
4. Verify by asking TestSprite: *"List the files in src/api/"* — it should return the actual file tree.

> 🔑 **Key Instruction:** Ensure the MCP server is running so TestSprite can read the codebase structure directly. If the connection drops, restart the MCP server before continuing.

### 2.3 Load Architecture Context

TestSprite works best when it understands the system it's testing. You must explicitly feed it the architecture document.

**How to load context:**

1. Open `testing/docs/00-context.md` in your editor.
2. Select all content (`Ctrl+A` / `Cmd+A`).
3. In the TestSprite chat panel, paste it as context or use the **"Add File to Context"** button to attach it.
4. Confirm by asking: *"What framework does repo 3 use?"* — it should answer **NestJS**.

> Do this at the **start of every session**. Context resets when you close the editor.

---

## 🔐 3. Environment Variables (`.env`)

### The Golden Rule

```
⚠️  NEVER commit .env files to the repository. Ever.
```

Your `.gitignore` already excludes them, but double-check before every commit:

```bash
git status   # .env files should NOT appear in the output
```

### Where to Get Keys

All environment variables (Stripe keys, Supabase secrets, database credentials, etc.) would be given by sivram.


1. Copy the `.env` file for each repo you need.
2. Paste into the correct location:

| Repo | `.env` File Location |
|------|---------------------|
| `1_JKYog_2.0` | `.env.local` |
| `2_radhakrishnatemple2.0` | `.env.local` |
| `3_JKYog_2.0_backend` | `.env` |
| `4_JKYog_Strapi` | `.env` |

### TestSprite & Environment Variables

TestSprite can read your local `.env` files to generate integration tests that use real API keys (e.g., Stripe test mode keys, Supabase anon keys). When it asks for permission to access environment variables:

- **Grant permission** for test-mode keys (Stripe `sk_test_*`, Supabase anon keys).
- **Deny permission** for production secrets. We never test against production.

> All integration tests must use **test-mode / sandbox** credentials only.

---

## 🔄 4. The Testing Workflow (The Loop)

This is the core execution cycle you'll repeat for every scenario in your assignment.

### Step 1 — Open Your Assignment

Open your specific file from `testing/assignments/`:

```
testing/assignments/<your-name>-testsprite-tasks.md
```

Locate the **Remediated Scenarios** table. Each row is one test scenario you need to build. The table has three columns:

| Column | What It Tells You |
|--------|-------------------|
| **#** | Scenario number (for tracking and your checklist) |
| **Scenario** | Exactly what the test must verify |
| **Exact Code Target** | The specific file and function to test |

### Step 2 — Copy the TestSprite Prompt

Your assignment file contains pre-written prompts under the **"TestSprite Prompt Strategy"** and **"TestSprite Prompt Additions"** sections. These are optimized to produce high-quality tests.

**Example prompt from an assignment:**

```text
Act as a Senior SDET. Read ../docs/00-context.md.

For 1_JKYog_2.0/src/pages-view/make-donation/donation-form/checkout-form.tsx — generate 3 test cases:
1. Click submit twice rapidly; assert stripe.confirmPayment is called exactly once.
2. Mock stripe.confirmPayment to reject with NetworkError; assert toast.error is called.
3. Assert isLoading state shows a spinner during payment processing.

Output the code for React Testing Library + Jest.
```

Copy the relevant prompt for the scenario(s) you're working on.

### Step 3 — Execute with TestSprite

1. **Navigate** to the target code file listed in the "Exact Code Target" column (e.g., `checkout-form.tsx`).
2. **Highlight** the target component or function in your editor.
3. **Open** the TestSprite chat panel.
4. **Paste** the prompt you copied in Step 2.
5. **Press Enter** and watch TestSprite generate the test file.

TestSprite will produce a complete test file with:
- Imports and mock setup
- Describe/it blocks for each scenario
- Assertions matching the prompt requirements

### Step 4 — Verify & Fix

Run the generated test immediately:

```bash
# For frontend tests (React Testing Library + Jest)
npx jest --testPathPattern="<your-test-file>"

# For backend tests (Jest + Supertest)
npx jest --testPathPattern="<your-test-file>"

# For E2E tests (Playwright)
npx playwright test <your-test-file>

# For Strapi tests
cd 4_JKYog_Strapi && npx jest --testPathPattern="<your-test-file>"
```

**If the test fails:**

| Failure Type | What to Tell TestSprite |
|-------------|------------------------|
| Wrong selector / element not found | *"Fix the selector for the submit button — it uses `data-testid='donate-btn'`"* |
| Mock not working | *"The mock for stripe.confirmPayment isn't intercepting. Use jest.spyOn instead."* |
| Import error | *"Fix the import path — the component is exported as default, not named."* |
| Assertion mismatch | *"The toast message is 'Payment failed' not 'Error'. Update the assertion."* |
| Timeout | *"Add a waitFor wrapper around the assertion — the state update is async."* |

Iterate until the test passes. This "generate → run → fix" loop is the core workflow.

### Step 5 — Repeat

Move to the next scenario in your table. Repeat Steps 2-4 for every row.

> 💡 **Pro Tip:** Group related scenarios (e.g., all `CheckoutForm` tests) into a single test file. TestSprite handles this well when you feed it multiple prompts for the same component at once.

---

## 📦 5. Submission Protocol (Closing the Loop)

### 5.1 Save Your Test Files

All generated tests must be saved in the following directory structure:

```
tests/
  e2e/
    <feature-name>/
      <component-name>.spec.ts      # Playwright E2E tests
      <component-name>.test.tsx      # React Testing Library tests
      <service-name>.spec.ts         # Jest + Supertest backend tests
      <content-type>.spec.ts         # Strapi content type tests
```

**Naming conventions:**

| Test Type | File Pattern | Example |
|-----------|-------------|---------|
| Frontend Component | `<component>.test.tsx` | `checkout-form.test.tsx` |
| Frontend E2E | `<feature>.spec.ts` | `donation-flow.spec.ts` |
| Backend API | `<controller>.spec.ts` | `payment-controller.spec.ts` |
| Strapi Content Type | `<content-type>.spec.ts` | `apparticle.spec.ts` |
| Auth Guards | `<guard-name>.spec.ts` | `supabase-guard.spec.ts` |
| Network Chaos | `<component>.chaos.test.tsx` | `subscribe.chaos.test.tsx` |

**Example directory structure for Anusha (Transactions & Events):**

```
tests/e2e/
  donation/
    checkout-form.test.tsx           # Scenarios 1-2, 11, 13
    payment.test.tsx                 # Scenarios 3-4, 12, 14
    validation.test.tsx              # Scenario 5
    checkout-form.chaos.test.tsx     # Scenarios NC-1 to NC-5
  event/
    event-card.test.tsx              # Scenarios 6-7, 15
    event-registration.spec.ts      # Phase 2: Scenarios 16-22
  live-portal/
    live-portal.test.tsx             # Phase 2: Scenarios 23-24
  paypal/
    paypal-flow.test.tsx             # Phase 2: Scenarios 25-26
```

### 5.2 Update Your Assignment Checklist

As each scenario passes, open your assignment file and check off the corresponding item in the **Deliverable** section:

**Before:**
```markdown
- [ ] Each scenario from the Remediated Scenarios table covered by at least one test case.
```

**After:**
```markdown
- [x] Each scenario from the Remediated Scenarios table covered by at least one test case.
```

### 5.3 Create Your Pull Request

When you've completed all scenarios in your assignment (Phase 1 + Phase 2), submit a PR.

**Branch naming:**
```bash
git checkout -b test/<your-name>-regression-coverage
```

**Stage and commit:**
```bash
git add tests/e2e/<your-feature-directories>/
git add testing/assignments/<your-name>-testsprite-tasks.md
git commit -m "test: <your-name> regression coverage — Phase 1 + Phase 2"
```

**PR Title Format:**
```
test: <name> regression coverage
```

**PR Body:**
```markdown
## Summary
- Completed regression test coverage for [Your Mission Name]
- Phase 1: X scenarios covered
- Phase 2: Y scenarios covered
- Total: X + Y test cases

## Test Files
- `tests/e2e/<feature>/...` (list your test files)

## Checklist
- [x] All Phase 1 scenarios passing
- [x] All Phase 2 scenarios passing
- [x] All Network Chaos scenarios passing (if applicable)
- [x] Assignment file checkboxes updated
- [x] No .env files included
- [x] All tests pass locally
```

**Push and create the PR:**
```bash
git push -u origin test/<your-name>-regression-coverage
gh pr create --title "test: <your-name> regression coverage" --body "..."
```

---

## 🛠️ 6. Troubleshooting

### TestSprite Issues

| Problem | Solution |
|---------|----------|
| TestSprite generates generic/wrong tests | Re-feed `docs/00-context.md` into context. Explicitly mention the file path and function name in your prompt. |
| MCP server disconnected | Restart the MCP server. Check that the port isn't blocked. Reconnect in TestSprite settings. |
| TestSprite doesn't know a component's props | Highlight the component's TypeScript interface/type and add it to context before prompting. |
| Generated code uses old import paths | Tell TestSprite: *"Use the import from `@/components/...` not `../../../components/...`"* |

### Test Execution Issues

| Problem | Solution |
|---------|----------|
| `Module not found` errors | Run `npm install` in the repo root. Check `tsconfig.json` path aliases. |
| Stripe/Supabase tests fail with 401 | Verify your `.env` has valid test-mode keys from 1Password. |
| Playwright tests timeout | Increase timeout: `test.setTimeout(30000)`. Ensure dev server is running. |
| Strapi tests can't connect | Ensure Strapi is running (`npm run develop`). Check `DATABASE_HOST` in `.env`. |
| Jest can't find React components | Add `@testing-library/jest-dom` to setup file. Check `jest.config.js` has correct transform rules. |

### Service Verification

Before running any tests, verify all services are up:

| Service | URL | Health Check |
|---------|-----|-------------|
| JKYog Frontend | `http://localhost:3000` | Page loads |
| Temple Frontend | `http://localhost:3000` | Page loads (run in separate terminal) |
| Backend API | `http://localhost:3001` | `GET /api` returns response |
| Strapi Admin | `http://localhost:1337/admin` | Admin panel loads |

---

## 📋 7. Quick Reference

### Assignment Distribution Summary

| Engineer | Mission | Repos | Phase 1 | Phase 2 | Total |
|----------|---------|-------|---------|---------|-------|
| Aditi | Public Pages | 1, 2 | 21 | 10 | **31** |
| Anjali | User & Learning | 1 | 20 | 13 | **33** |
| Anusha | Transactions & Events | 1 | 20 | 12 | **32** |
| Divyani | Core Navigation & Static | 2 | 19 | 10 | **29** |
| Jhansi | Interactive & Transactional | 2, 1, 3 | 20 | 11 | **31** |
| Kanan | Identity & Notification | 3 | 18 | 12 | **30** |
| Manasi | Payments & Class Platform | 3, 4 | 15 | 15 | **30** |
| Nishita | Content Validation | 4 | 16 | 14 | **30** |
| Tanmay | Slider/Testimonial/Config | 4 | 14 | 14 | **28** |
| **Total** | | | **163** | **111** | **274** |

### Testing Frameworks by Repo

| Repo | Primary Framework | Runner |
|------|------------------|--------|
| `1_JKYog_2.0` | React Testing Library + Jest | `npx jest` |
| `1_JKYog_2.0` (E2E) | Playwright | `npx playwright test` |
| `2_radhakrishnatemple2.0` | React Testing Library + Jest | `npx jest` |
| `2_radhakrishnatemple2.0` (E2E) | Playwright | `npx playwright test` |
| `3_JKYog_2.0_backend` | Jest + Supertest | `npx jest` |
| `4_JKYog_Strapi` | Jest + Supertest (Strapi env) | `npx jest` |

### Key File Paths

| What | Where |
|------|-------|
| Architecture doc | `testing/docs/00-context.md` |
| Setup guide | `testing/docs/01-setup.md` |
| Your assignment | `testing/assignments/<name>-testsprite-tasks.md` |
| Test output directory | `tests/e2e/<feature-name>/` |
| Quality reports | `09-quality-reports/` |

### The Workflow in 30 Seconds

```
1. Read docs/00-context.md + docs/01-setup.md
2. Set up local environment + .env from 1Password
3. Install TestSprite + connect MCP server
4. Open your assignment file
5. Copy a TestSprite prompt → paste into TestSprite → generate test
6. Run the test → fix failures → repeat
7. Check off scenarios in your assignment file
8. Submit PR: test/<name>-regression-coverage
```

---

> 🎯 **Remember:** The goal is not just to generate tests — it's to generate tests that **catch real bugs**. Every scenario in your assignment was designed from actual code analysis. Trust the prompts, verify the output, and ship with confidence.
>
> Happy testing! 🚀
