@echo off
title RDP Wrapper Installer
cd /d "%~dp0"

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ===============================================
    echo    Dit script moet als Administrator draaien!
    echo ===============================================
    echo    Klik met rechtermuisknop ^> Als administrator uitvoeren
    echo.
    pause
    exit /b 1
)

echo ========================================
echo    RDP Wrapper Installatie
echo ========================================
echo.

set "DEST=%ProgramFiles%\RDP Wrapper"

:: Stap 1: Download RDP Wrapper
echo [1/4] RDP Wrapper downloaden...
if not exist "%TEMP%\rdpwrap" mkdir "%TEMP%\rdpwrap"
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/stascorp/rdpwrap/releases/download/v1.6.2/RDPWrap-v1.6.2.zip' -OutFile '%TEMP%\rdpwrap\rdpwrap.zip' -UseBasicParsing" >nul 2>&1
if errorlevel 1 (
    echo [!] Download mislukt - download handmatig van https://github.com/stascorp/rdpwrap/releases
    pause
    exit /b 1
)
echo [OK]

:: Stap 2: Uitpakken naar Program Files
echo [2/4] Installeren naar %DEST%...
if not exist "%DEST%" mkdir "%DEST%"
powershell -Command "Expand-Archive -Path '%TEMP%\rdpwrap\rdpwrap.zip' -DestinationPath '%TEMP%\rdpwrap\' -Force" >nul 2>&1
copy /Y "%TEMP%\rdpwrap\RDPWInst.exe" "%DEST%\" >nul
copy /Y "%TEMP%\rdpwrap\RDPConf.exe" "%DEST%\" >nul
copy /Y "%TEMP%\rdpwrap\RDPCheck.exe" "%DEST%\" >nul
echo [OK]

:: Stap 3: Configuratie downloaden
echo [3/4] Configuratie ophalen...
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/sebaxakerhtc/rdpwrap.ini/master/rdpwrap.ini' -OutFile '%DEST%\rdpwrap.ini' -UseBasicParsing" >nul 2>&1
echo [OK]

:: Stap 4: Service installeren en starten
echo [4/4] Service installeren en starten...
"%DEST%\RDPWInst.exe" -i >nul 2>&1
net stop TermService >nul 2>&1
net start TermService >nul 2>&1
echo [OK]

:: Afronden
echo.
echo ========================================
echo    Installatie voltooid!
echo ========================================
echo.
echo RDP Wrapper status:  %DEST%\RDPConf.exe
echo.
echo Vanaf je Mac:
echo   1. Microsoft Remote Desktop uit Mac App Store
echo   2. Verbind naar het IP van deze computer
echo.
pause
