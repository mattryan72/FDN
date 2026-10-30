# tools\apply.ps1 - mechanical apply of staged files (FDN v9.01)
# Usage (from the repo root):
#   powershell -ExecutionPolicy Bypass -File tools\apply.ps1 -Manifest <path> [-DryRun]
# Manifest CSV columns: staged_path, target_path, orig_sha256, new_sha256, new_lines, backup_suffix
#   staged_path : absolute, or relative to the manifest folder
#   target_path : relative to the repo root (the folder above tools\)
#   orig_sha256 : expected current hash of the target, or NEW (target must not exist)
#   backup_suffix: backup is written as <target>.bak<suffix> (e.g. -m06c)
# All checks run first; if any fails nothing is changed. Byte-exact Copy-Item only.
# No git commands. Exit code 0 = OK, 1 = failure.
param(
    [Parameter(Mandatory=$true)][string]$Manifest,
    [switch]$DryRun
)
$ErrorActionPreference = 'Stop'

function Get-Sha([string]$p) { return (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToUpper() }
function Get-Lines([string]$p) {
    $b = [System.IO.File]::ReadAllBytes($p)
    $n = 0
    foreach ($x in $b) { if ($x -eq 10) { $n++ } }
    return $n
}
function Short([string]$h) { if ($h.Length -ge 16) { return $h.Substring(0,16) } return $h }

$repo = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
if (-not (Test-Path -LiteralPath $Manifest)) { Write-Host "FAIL manifest not found: $Manifest"; exit 1 }
$manDir = Split-Path -Parent (Resolve-Path -LiteralPath $Manifest).Path
$rows = @(Import-Csv -LiteralPath $Manifest)
if ($rows.Count -eq 0) { Write-Host "FAIL manifest has no rows"; exit 1 }

Write-Host "Repo    : $repo"
Write-Host "Manifest: $Manifest ($($rows.Count) rows)"
if ($DryRun) { Write-Host "Mode    : DRY RUN (nothing is changed)" } else { Write-Host "Mode    : APPLY" }
Write-Host ""

# ---------- phase 1: checks ----------
$plan = @()
$errors = 0
foreach ($r in $rows) {
    $staged = $r.staged_path
    if (-not [System.IO.Path]::IsPathRooted($staged)) { $staged = Join-Path $manDir $staged }
    $target = Join-Path $repo $r.target_path
    $orig = ($r.orig_sha256).Trim().ToUpper()
    $new = ($r.new_sha256).Trim().ToUpper()
    $lines = [int]$r.new_lines
    $action = ''
    $msg = ''
    if (-not (Test-Path -LiteralPath $staged)) {
        $action = 'ERROR'; $msg = "staged file missing: $staged"
    } else {
        $sh = Get-Sha $staged
        $sl = Get-Lines $staged
        if ($sh -ne $new) { $action = 'ERROR'; $msg = "staged hash $(Short $sh) <> manifest $(Short $new)" }
        elseif ($sl -ne $lines) { $action = 'ERROR'; $msg = "staged lines $sl <> manifest $lines" }
    }
    if ($action -eq '') {
        $exists = Test-Path -LiteralPath $target
        if ($exists) { $th = Get-Sha $target } else { $th = '' }
        if ($exists -and ($th -eq $new)) { $action = 'SKIP'; $msg = 'already applied' }
        elseif ($orig -eq 'NEW') {
            if ($exists) { $action = 'ERROR'; $msg = "NEW file already exists with other content ($(Short $th))" }
            else { $action = 'APPLY'; $msg = 'new file' }
        } else {
            if (-not $exists) { $action = 'ERROR'; $msg = 'target missing' }
            elseif ($th -ne $orig) { $action = 'ERROR'; $msg = "target hash $(Short $th) <> expected orig $(Short $orig)" }
            else {
                $bak = $target + '.bak' + $r.backup_suffix
                if (Test-Path -LiteralPath $bak) {
                    $bh = Get-Sha $bak
                    if ($bh -ne $orig) { $action = 'ERROR'; $msg = "backup exists with other content: $bak" }
                    else { $action = 'APPLY'; $msg = 'replace (backup already present, kept)' }
                } else { $action = 'APPLY'; $msg = 'replace' }
            }
        }
    }
    if ($action -eq 'ERROR') { $errors++ }
    $plan += New-Object PSObject -Property @{ Target=$r.target_path; TargetFull=$target; Staged=$staged; Orig=$orig; New=$new; Lines=$lines; Suffix=$r.backup_suffix; Action=$action; Msg=$msg; Status=''; Hash=''; Got=0 }
}
Write-Host "Checks:"
foreach ($p in $plan) { Write-Host ("  {0,-6} {1}  - {2}" -f $p.Action, $p.Target, $p.Msg) }
Write-Host ""
if ($errors -gt 0) {
    Write-Host "FAIL: $errors check(s) failed. Nothing was changed."
    exit 1
}
if ($DryRun) {
    Write-Host "DRY RUN OK: all checks passed. Nothing was changed."
    exit 0
}

# ---------- phase 2: apply ----------
$fail = 0
foreach ($p in $plan) {
    if ($p.Action -eq 'SKIP') { $p.Status = 'SKIPPED'; $p.Hash = $p.New; $p.Got = Get-Lines $p.TargetFull; continue }
    try {
        if ($p.Orig -ne 'NEW') {
            $bak = $p.TargetFull + '.bak' + $p.Suffix
            if (-not (Test-Path -LiteralPath $bak)) { Copy-Item -LiteralPath $p.TargetFull -Destination $bak }
        } else {
            $dir = Split-Path -Parent $p.TargetFull
            if (-not (Test-Path -LiteralPath $dir)) { throw "target folder missing: $dir" }
        }
        Copy-Item -LiteralPath $p.Staged -Destination $p.TargetFull -Force
        $p.Hash = Get-Sha $p.TargetFull
        $p.Got = Get-Lines $p.TargetFull
        if (($p.Hash -eq $p.New) -and ($p.Got -eq $p.Lines)) { $p.Status = 'APPLIED' }
        else { $p.Status = 'MISMATCH'; $fail++ }
    } catch {
        $p.Status = 'ERROR: ' + $_.Exception.Message; $fail++
    }
}

# ---------- phase 3: check_source ----------
$txt = @()
foreach ($p in $plan) { if ($p.Target -like '*.txt') { $txt += ($p.Target -replace '\\','/') } }
$csRc = 0
$checker = Join-Path $repo 'tools\check_source.py'
if (($txt.Count -gt 0) -and (Test-Path -LiteralPath $checker)) {
    Write-Host "check_source:"
    Push-Location $repo
    try { & python tools/check_source.py @txt; $csRc = $LASTEXITCODE } finally { Pop-Location }
    if ($csRc -ne 0) { $fail++ }
    Write-Host ""
}

Write-Host "Result:"
Write-Host ("  {0,-48} {1,-9} {2,-16} {3}" -f 'file','status','sha256','lines')
foreach ($p in $plan) { Write-Host ("  {0,-48} {1,-9} {2,-16} {3}" -f $p.Target, $p.Status, (Short $p.Hash), $p.Got) }
if ($fail -gt 0) { Write-Host "FAIL: $fail problem(s). Backups (.bak<suffix>) are next to the targets."; exit 1 }
Write-Host "OK: all files applied and verified."
exit 0
