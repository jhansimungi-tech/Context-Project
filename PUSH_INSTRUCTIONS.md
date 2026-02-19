# Required Push Sequence — Next Steps

The commit is ready on branch `test/jhansi-regression-rearrangement`. To push and create the PR, run the following.

## Prerequisites

1. **Git remote** — Add your GitHub (or GitLab, etc.) remote if not already configured:
   ```powershell
   git remote add origin https://github.com/<org>/<repo>.git
   ```

2. **GitHub CLI (`gh`)** — Required for `gh pr create`. Install from: https://cli.github.com/
   - Ensure you're authenticated: `gh auth status`

---

## Step 4: Push branch

```powershell
cd "c:\JK Yog Testing\Context-Project-main"
git push -u origin test/jhansi-regression-rearrangement
```

---

## Step 5: Create PR

```powershell
gh pr create --title "test(repos): regression coverage for v2 layout migration" --body-file "testing/pr_body_regression_rearrangement.md"
```

---

## One-liner (after remote is set)

```powershell
cd "c:\JK Yog Testing\Context-Project-main"; git push -u origin test/jhansi-regression-rearrangement; gh pr create --title "test(repos): regression coverage for v2 layout migration" --body-file "testing/pr_body_regression_rearrangement.md"
```

---

## Or run the full script

```powershell
cd "c:\JK Yog Testing\Context-Project-main"
.\testing\push_and_pr.ps1
```

*(Note: Steps 1–3 are already done. The script will re-stage if needed, then run push and PR create.)*
