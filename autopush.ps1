# Kaiju Blitz - auto commit & push watcher
# Watches this repo and, whenever a file changes, commits it and pushes to
# origin/main so the GitHub Pages site redeploys automatically.
#
# Run it with start-autopush.cmd (keeps a window open) or install it to run
# at logon with install-autopush-task.cmd. See README-autopush.md.

$ErrorActionPreference = 'Continue'
$RepoPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $RepoPath

$Interval = 5            # seconds between checks
$Branch   = 'main'
$LogFile  = Join-Path $RepoPath 'autopush.log'

function Log($msg) {
    $line = "{0}  {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $msg
    Write-Host $line
    Add-Content -Path $LogFile -Value $line
}

# Sanity checks
if (-not (Test-Path (Join-Path $RepoPath '.git'))) {
    Log "ERROR: $RepoPath is not a git repository. Aborting."
    exit 1
}

Log "Auto-push watcher started in $RepoPath (checking every $Interval s). Press Ctrl+C to stop."

while ($true) {
    try {
        $status = (& git status --porcelain) -join "`n"
        if ($status.Trim().Length -gt 0) {
            Log "Change detected:`n$status"
            & git add -A | Out-Null
            $stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            & git commit -m "auto: update $stamp" | Out-Null

            & git push origin $Branch 2>&1 | ForEach-Object { Log $_ }
            if ($LASTEXITCODE -ne 0) {
                Log "Push rejected - trying 'git pull --rebase' then pushing again..."
                & git pull --rebase origin $Branch 2>&1 | ForEach-Object { Log $_ }
                & git push origin $Branch 2>&1 | ForEach-Object { Log $_ }
            }
            if ($LASTEXITCODE -eq 0) { Log "Pushed OK. GitHub Pages will update within ~1 minute." }
            else { Log "Push FAILED (exit $LASTEXITCODE). See messages above." }
        }
    }
    catch {
        Log "ERROR: $($_.Exception.Message)"
    }
    Start-Sleep -Seconds $Interval
}
