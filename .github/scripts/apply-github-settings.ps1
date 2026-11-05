#Requires -Version 7
<#
.SYNOPSIS
Applies the standard GitHub settings to a repository with the gh CLI.

.DESCRIPTION
- Pull requests: squash merges only (PR title and body become the commit),
  "Update branch" button on, head branches deleted after merging.
- Security: Dependabot alerts and security updates; private vulnerability
  reporting on public repositories.
- A "Protect main" ruleset on the default branch: no deletion, no force
  pushes, changes only through pull requests, and the required CI checks
  must pass. It applies to admins too.

Safe to run again: it updates the existing ruleset instead of adding another.
Rulesets on private repositories need GitHub Pro; the script warns and
continues if GitHub refuses.

.EXAMPLE
pwsh .github/scripts/apply-github-settings.ps1
Applies the settings to the repository in the current folder.

.EXAMPLE
pwsh .github/scripts/apply-github-settings.ps1 -Repo LuisBadal0/LubaTV -RequiredChecks version, build -DryRun
Shows what would change in another repository without changing it.
#>
param(
    [string]$Repo,
    # Job names in the CI workflow that must pass before merging. A matrix job
    # reports one check per entry, such as "build (windows-latest)".
    [string[]]$RequiredChecks = @('version', 'build'),
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { throw 'The GitHub CLI (gh) is required.' }
if (-not $Repo) { $Repo = gh repo view --json nameWithOwner --jq .nameWithOwner }
$info = gh api "repos/$Repo" | ConvertFrom-Json
Write-Host "Repository: $Repo ($($info.visibility), default branch $($info.default_branch))"

function Invoke-GitHub {
    param([string]$What, [string]$Method, [string]$Path, [object]$Body, [switch]$Optional)
    if ($DryRun) {
        Write-Host "[dry run] $What"
        Write-Host "          $Method $Path"
        if ($Body) { Write-Host (($Body | ConvertTo-Json -Depth 10) -replace '(?m)^', '          ') }
        return
    }
    try {
        if ($Body) {
            $null = $Body | ConvertTo-Json -Depth 10 | gh api -X $Method $Path --input - 2>&1
        } else {
            $null = gh api -X $Method $Path 2>&1
        }
        Write-Host "OK   $What"
    } catch {
        if (-not $Optional) { throw "Failed: $What. $_" }
        Write-Warning "Skipped: $What. $_"
    }
}

Invoke-GitHub 'Squash merges only, delete branches after merging' PATCH "repos/$Repo" @{
    allow_squash_merge          = $true
    allow_merge_commit          = $false
    allow_rebase_merge          = $false
    squash_merge_commit_title   = 'PR_TITLE'
    squash_merge_commit_message = 'PR_BODY'
    delete_branch_on_merge      = $true
    allow_update_branch         = $true
}

Invoke-GitHub 'Dependabot alerts' PUT "repos/$Repo/vulnerability-alerts" -Optional
Invoke-GitHub 'Dependabot security updates' PUT "repos/$Repo/automated-security-fixes" -Optional
if ($info.visibility -eq 'public') {
    Invoke-GitHub 'Private vulnerability reporting' PUT "repos/$Repo/private-vulnerability-reporting" -Optional
}

$ruleName = 'Protect main'
$ruleset = @{
    name        = $ruleName
    target      = 'branch'
    enforcement = 'active'
    conditions  = @{ ref_name = @{ include = @('~DEFAULT_BRANCH'); exclude = @() } }
    rules       = @(
        @{ type = 'deletion' }
        @{ type = 'non_fast_forward' }
        @{
            type       = 'pull_request'
            parameters = @{
                required_approving_review_count   = 0
                dismiss_stale_reviews_on_push     = $false
                require_code_owner_review         = $false
                require_last_push_approval        = $false
                required_review_thread_resolution = $false
                allowed_merge_methods             = @('squash')
            }
        }
    )
}
if ($RequiredChecks.Count -gt 0) {
    $ruleset.rules += @{
        type       = 'required_status_checks'
        parameters = @{
            strict_required_status_checks_policy = $false
            required_status_checks               = @($RequiredChecks | ForEach-Object { @{ context = $_ } })
        }
    }
}

$existing = $null
try {
    $existing = gh api "repos/$Repo/rulesets" 2>$null | ConvertFrom-Json | Where-Object name -EQ $ruleName | Select-Object -First 1
} catch { }
$checks = if ($RequiredChecks.Count) { $RequiredChecks -join ', ' } else { 'none' }
if ($existing) {
    Invoke-GitHub "Update ruleset '$ruleName' (required checks: $checks)" PUT "repos/$Repo/rulesets/$($existing.id)" $ruleset -Optional
} else {
    Invoke-GitHub "Create ruleset '$ruleName' (required checks: $checks)" POST "repos/$Repo/rulesets" $ruleset -Optional
}

$protection = $null
try { $protection = gh api "repos/$Repo/branches/$($info.default_branch)/protection" 2>$null } catch { }
if ($protection) {
    Write-Host "Note: $($info.default_branch) also has classic branch protection. The ruleset replaces it;"
    Write-Host "      remove it in Settings > Branches once the ruleset works, so the rules live in one place."
}
