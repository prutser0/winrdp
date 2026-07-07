<#
.SYNOPSIS
    RDP Wrapper Installer — Enable Remote Desktop on Windows Home
.DESCRIPTION
    Downloads RDP Wrapper Library by Stas'M and applies the community
    rdpwrap.ini to enable RDP + multi-session on Windows 11/10 Home.
    Must be run as Administrator.
#>

#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$tmpDir = "$env:TEMP\rdpwrap-install"
$destDir = "${env:ProgramFiles}\RDP Wrapper"

Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║    RDP Wrapper Installer v1.0        ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# --- Admin check ---
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "✗ Dit script moet als Administrator worden uitgevoerd!" -ForegroundColor Red
    exit 1
}

# --- Stap 1: Download RDP Wrapper ---
Write-Host "[1/4] RDP Wrapper downloaden..." -ForegroundColor Yellow
if (Test-Path $tmpDir) { Remove-Item $tmpDir -Recurse -Force }
New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null

$rdpwrapUrl = "https://github.com/stascorp/rdpwrap/releases/download/v1.6.2/RDPWrap-v1.6.2.zip"
$zipPath = "$tmpDir\rdpwrap.zip"

try {
    Invoke-WebRequest -Uri $rdpwrapUrl -OutFile $zipPath -UseBasicParsing
    Write-Host "  ✓ Gedownload" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Download mislukt: $_" -ForegroundColor Red
    exit 1
}

# --- Stap 2: Uitpakken ---
Write-Host "[2/4] Uitpakken naar $destDir ..." -ForegroundColor Yellow
Expand-Archive -Path $zipPath -DestinationPath $tmpDir -Force

if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
Copy-Item "$tmpDir\RDPWInst.exe" "$destDir\" -Force
Copy-Item "$tmpDir\RDPConf.exe" "$destDir\" -Force
Copy-Item "$tmpDir\RDPCheck.exe" "$destDir\" -Force
Write-Host "  ✓ Geïnstalleerd" -ForegroundColor Green

# --- Stap 3: rdpwrap.ini downloaden ---
Write-Host "[3/4] Configuratie (rdpwrap.ini) ophalen..." -ForegroundColor Yellow
$iniUrl = "https://raw.githubusercontent.com/sebaxakerhtc/rdpwrap.ini/master/rdpwrap.ini"
try {
    Invoke-WebRequest -Uri $iniUrl -OutFile "$destDir\rdpwrap.ini" -UseBasicParsing
    Write-Host "  ✓ Configuratie gedownload" -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Kon configuratie niet downloaden, gebruik standaard ini" -ForegroundColor Yellow
}

# --- Stap 4: Service installeren & starten ---
Write-Host "[4/4] Service installeren en starten..." -ForegroundColor Yellow
& "$destDir\RDPWInst.exe" -i | Out-Null

# Service herstarten
Restart-Service -Name TermService -Force -ErrorAction SilentlyContinue
Write-Host "  ✓ Service gestart" -ForegroundColor Green

# --- Controle ---
Start-Sleep -Seconds 2
$listener = netstat -ano | Select-String ":3389"
if ($listener) {
    Write-Host ""
    Write-Host "✅ RDP werkt! Poort 3389 luistert." -ForegroundColor Green
    Write-Host ""
    Write-Host "Open RDPConf om te controleren: $destDir\RDPConf.exe" -ForegroundColor White
    & "$destDir\RDPConf.exe"
} else {
    Write-Host ""
    Write-Host "⚠ RDP lijkt nog niet te luisteren." -ForegroundColor Yellow
    Write-Host "  Open RDPConf: $destDir\RDPConf.exe" -ForegroundColor White
}

Write-Host ""
Write-Host "Vanaf je Mac:" -ForegroundColor Cyan
Write-Host "  1. Installeer 'Microsoft Remote Desktop' uit de Mac App Store" -ForegroundColor White
Write-Host "  2. Voeg een nieuwe PC toe met het IP-adres van deze computer" -ForegroundColor White
$ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" -and $_.PrefixOrigin -ne "WellKnown" }).IPAddress
Write-Host "  IP: $ip" -ForegroundColor Green
