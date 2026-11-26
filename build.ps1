# 多版本构建：python build.py [--only 1.21.3 ...]
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
$py = Get-Command python3 -ErrorAction SilentlyContinue
if (-not $py) { $py = Get-Command python -ErrorAction SilentlyContinue }
if (-not $py) { Write-Error "需要 Python 3 来构建多版本 zip；也可直接使用仓库 dist/ 下的现成 zip。"; exit 1 }
& $py.Source build.py @args
