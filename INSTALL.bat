@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title GitHub CLI - Installer

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

echo.
echo ============================================
echo   GitHub CLI - One-Click Installer
echo ============================================
echo   Path: %SCRIPT_DIR%
echo ============================================
echo.

REM === [1/5] Check if gh is already installed ===
echo [1/5] Checking if GitHub CLI is already installed...
where gh >nul 2>&1
if not errorlevel 1 (
    for /f "tokens=*" %%i in ('gh --version 2^>nul') do echo       Already installed: %%i
    echo.
    set "REINSTALL="
    set /p "REINSTALL=  Already installed. Upgrade? [y/N]: "
    if /i not "!REINSTALL!"=="y" (
        echo.
        echo       Use RUN.bat to manage GitHub CLI.
        pause
        endlocal
        exit /b 0
    )
    echo       Proceeding with upgrade...
)

REM === [2/5] Detect package managers ===
echo.
echo [2/5] Detecting package managers...
set "HAS_WINGET=0"
set "HAS_SCOOP=0"

where winget >nul 2>&1
if not errorlevel 1 (
    set "HAS_WINGET=1"
    for /f "tokens=*" %%i in ('winget --version 2^>nul') do echo       winget: %%i [OK]
)

where scoop >nul 2>&1
if not errorlevel 1 (
    set "HAS_SCOOP=1"
    echo       scoop: available [OK]
)

REM --- If no PM found, exit with message ---
if "!HAS_WINGET!"=="1" goto :PM_FOUND
if "!HAS_SCOOP!"=="1" goto :PM_FOUND

echo.
echo       [ERROR] No package manager found.
echo.
echo       Please install one of the following:
echo         - winget: built into Windows 10 22H2+ and Windows 11
echo         - Scoop:  https://scoop.sh
echo.
echo       Or download the MSI installer manually from:
echo       https://github.com/cli/cli/releases/latest
echo.
pause
endlocal
exit /b 2

:PM_FOUND
REM === Determine install method - flat logic ===
set "INSTALL_METHOD="
if "!HAS_WINGET!"=="1" if "!HAS_SCOOP!"=="0" set "INSTALL_METHOD=winget"
if "!HAS_WINGET!"=="0" if "!HAS_SCOOP!"=="1" set "INSTALL_METHOD=scoop"

REM --- Both available: ask user ---
if "!HAS_WINGET!"=="1" if "!HAS_SCOOP!"=="1" (
    echo.
    echo   Both winget and scoop are available.
    echo   [1] winget - recommended
    echo   [2] scoop
    echo.
    set "PM_CHOICE="
    set /p "PM_CHOICE=  Select [1-2]: "
    if "!PM_CHOICE!"=="2" (
        set "INSTALL_METHOD=scoop"
    ) else (
        set "INSTALL_METHOD=winget"
    )
)

REM === [3/5] Install ===
echo.
echo [3/5] Installing GitHub CLI via !INSTALL_METHOD!...
echo.

set "INSTALL_OK=0"

if "!INSTALL_METHOD!"=="winget" (
    call winget install --id GitHub.cli --source winget --accept-source-agreements --accept-package-agreements
    if not errorlevel 1 set "INSTALL_OK=1"
)

if "!INSTALL_METHOD!"=="scoop" (
    call scoop install gh
    if not errorlevel 1 set "INSTALL_OK=1"
)

if "!INSTALL_OK!"=="0" (
    echo.
    echo       [ERROR] Installation failed.
    echo       Try running as Administrator or use a different method.
    echo.
    pause
    endlocal
    exit /b 3
)

REM === [4/5] Refresh PATH ===
echo.
echo [4/5] Refreshing PATH...

set "GH_FOUND=0"
where gh >nul 2>&1
if not errorlevel 1 set "GH_FOUND=1"

if "!GH_FOUND!"=="0" if exist "%LOCALAPPDATA%\Microsoft\WindowsApps\gh.exe" set "GH_FOUND=1"

if "!GH_FOUND!"=="0" if exist "%ProgramFiles%\GitHub CLI\gh.exe" (
    set "PATH=%ProgramFiles%\GitHub CLI;%PATH%"
    set "GH_FOUND=1"
)

if "!GH_FOUND!"=="0" if exist "%ProgramFiles(x86)%\GitHub CLI\gh.exe" (
    set "PATH=%ProgramFiles(x86)%\GitHub CLI;%PATH%"
    set "GH_FOUND=1"
)

if "!GH_FOUND!"=="0" if exist "%USERPROFILE%\scoop\apps\gh\current\bin\gh.exe" (
    set "PATH=%USERPROFILE%\scoop\apps\gh\current\bin;%PATH%"
    set "GH_FOUND=1"
)

REM === [5/5] Verify ===
echo.
echo [5/5] Verifying installation...
if "!GH_FOUND!"=="1" (
    for /f "tokens=*" %%i in ('gh --version 2^>nul') do echo       %%i
    echo       Installation verified [OK]
) else (
    echo       [WARNING] gh not found in current session.
    echo       Restart your terminal or PC for PATH to update.
)

echo.
echo ============================================
echo   INSTALLATION COMPLETE!
echo ============================================
echo   Next steps:
echo     1. Run RUN.bat to start using GitHub CLI
echo     2. Use Auth Management to login
echo.
echo   If gh is not recognized, restart terminal.
echo ============================================
echo.
pause
endlocal
exit /b 0
