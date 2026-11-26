# 构建数据包 zip： dist\threebody.zip
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
New-Item -ItemType Directory -Force -Path dist | Out-Null
$zip = Join-Path (Get-Location) "dist\threebody.zip"
if (Test-Path $zip) { Remove-Item $zip }
Compress-Archive -Path pack.mcmeta, data -DestinationPath $zip
Write-Host "built $zip"
