# Commit local site changes and push to GitHub (Pages deploys on push to main).
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

$gh = 'C:\Users\Administrator\AppData\Local\gh-cli\bin\gh.exe'
if (Test-Path $gh) {
  $env:PATH = "$(Split-Path $gh);$env:PATH"
}

git add -A
$status = git status --porcelain
if (-not $status) {
  $ahead = git rev-list --count '@{u}..HEAD' 2>$null
  if ($ahead -and [int]$ahead -gt 0) {
    git push origin HEAD
    Write-Host 'Pushed existing commits. GitHub Pages will redeploy.'
  } else {
    Write-Host 'Nothing to deploy.'
  }
  exit 0
}

$msg = if ($args.Count -gt 0) { $args -join ' ' } else { "Update Optimus Pepe site $(Get-Date -Format 'yyyy-MM-dd HH:mm')" }
git -c user.name='AAAA-web-deploy' -c user.email='AAAA-web-deploy@users.noreply.github.com' commit -m $msg
git push -u origin HEAD
Write-Host 'Pushed. GitHub Pages deploy starts automatically.'
