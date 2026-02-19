# Required Push Sequence — per testing/instructions_v2.md §5.3
# Run from: Context-Project-main (project root)
# Prerequisites: git, gh CLI. If no remote: git remote add origin <url>

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

# 0) Ensure git repo (run `git init` and `git remote add origin <url>` if needed)
if (-not (Test-Path ".git")) {
    Write-Host "ERROR: Not a git repository. Run: git init" -ForegroundColor Red
    exit 1
}

# 1) Verify current change set
Write-Host "=== 1) Git status ===" -ForegroundColor Cyan
git status

# 2) Stage regression artifacts for all affected repos
Write-Host "`n=== 2) Staging artifacts ===" -ForegroundColor Cyan
git add testing/repos/repo1_jkyog_2_0/testplan/
git add testing/repos/repo1_jkyog_2_0/tests/
git add testing/repos/repo1_jkyog_2_0/reports/raw_report.md
git add testing/repos/repo1_jkyog_2_0/results/test_results.json

git add testing/repos/repo2_radhakrishnatemple2_0/testplan/
git add testing/repos/repo2_radhakrishnatemple2_0/tests/
git add testing/repos/repo2_radhakrishnatemple2_0/reports/raw_report.md
git add testing/repos/repo2_radhakrishnatemple2_0/results/test_results.json

git add testing/repos/repo3_jkyog_2_0_backend/testplan/
git add testing/repos/repo3_jkyog_2_0_backend/tests/
git add testing/repos/repo3_jkyog_2_0_backend/reports/raw_report.md
git add testing/repos/repo3_jkyog_2_0_backend/results/test_results.json

git add testing/regression_compiled/latest/
git add testing/instructions_v2.md
git add testing/pr_body_regression_rearrangement.md
git add testsprite_tests/README.md

# 3) Commit
Write-Host "`n=== 3) Commit ===" -ForegroundColor Cyan
git commit -m "test(repos): regression coverage - v2 layout migration for repo1, repo2, repo3"

# 4) Create branch and push (requires remote and auth)
Write-Host "`n=== 4) Push branch ===" -ForegroundColor Cyan
$branch = "test/jhansi-regression-rearrangement"
$currentBranch = git branch --show-current 2>$null
if ($currentBranch -ne $branch) {
    git checkout -b $branch 2>$null
}
git push -u origin $branch

# 5) Create PR (requires gh CLI)
Write-Host "`n=== 5) Create PR ===" -ForegroundColor Cyan
gh pr create `
  --title "test(repos): regression coverage for v2 layout migration" `
  --body-file "testing/pr_body_regression_rearrangement.md"

Write-Host "`nDone." -ForegroundColor Green
