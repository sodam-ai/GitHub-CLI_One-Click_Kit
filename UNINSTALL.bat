@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title GitHub CLI - Uninstaller

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

echo.
echo ============================================
echo   GitHub CLI - Safe Uninstaller
echo ============================================
echo.

REM === Check if installed ===
where gh >nul 2>&1
if errorlevel 1 (
    echo   [INFO] GitHub CLI is not installed.
    echo   Nothing to uninstall.
    echo.
    pause
    endlocal
    exit /b 0
)

echo   Currently installed:
for /f "tokens=*" %%i in ('gh --version 2^>nul') do echo   %%i
echo.

echo   --- Current Auth Status ---
call gh auth status 2>nul
echo.

REM === Ask about config backup ===
set "DO_BACKUP=0"
if exist "%USERPROFILE%\.config\gh" (
    echo   [INFO] gh configuration found.
    set "BC="
    set /p "BC=  Backup config before uninstall? [y/N]: "
    if /i "!BC!"=="y" set "DO_BACKUP=1"
    echo.
)

REM === Confirmation ===
echo ============================================
echo   [WARNING] This will:
echo     1. Logout from all GitHub accounts
echo     2. Uninstall GitHub CLI
echo     3. Remove gh config and cache data
echo ============================================
echo.
set "CONFIRM="
set /p "CONFIRM=  Type YES to confirm uninstall: "
if /i not "!CONFIRM!"=="YES" (
    echo.
    echo   Uninstall cancelled.
    echo.
    pause
    endlocal
    exit /b 0
)

REM === Backup ===
if "!DO_BACKUP!"=="1" (
    echo.
    echo [0/4] Backing up configuration...
    set "BACKUP_DIR=%SCRIPT_DIR%\gh-config-backup"
    if not exist "!BACKUP_DIR!" mkdir "!BACKUP_DIR!"
    xcopy "%USERPROFILE%\.config\gh\*" "!BACKUP_DIR!\" /E /I /Y >nul 2>&1
    echo       Backed up to: !BACKUP_DIR!
)

echo.
echo [1/4] Logging out from GitHub...
call gh auth logout 2>nul
echo       Logout done.

echo.
echo [2/4] Uninstalling GitHub CLI...

set "UNINSTALLED=0"

where winget >nul 2>&1
if not errorlevel 1 (
    call winget uninstall --id GitHub.cli --source winget --accept-source-agreements 2>nul
    set "UNINSTALLED=1"
    echo       winget uninstall done.
)

if "!UNINSTALLED!"=="0" (
    where scoop >nul 2>&1
    if not errorlevel 1 (
        call scoop uninstall gh 2>nul
        set "UNINSTALLED=1"
        echo       scoop uninstall done.
    )
)

if "!UNINSTALLED!"=="0" (
    echo       [WARNING] No package manager could uninstall.
    echo       Please uninstall manually:
    echo       Settings - Apps - Installed apps - GitHub CLI
)

echo.
echo [3/4] Cleaning config and cache...

if exist "%APPDATA%\GitHub CLI" (
    rmdir /s /q "%APPDATA%\GitHub CLI" 2>nul
    echo       Removed config data.
)
if exist "%USERPROFILE%\.config\gh" (
    rmdir /s /q "%USERPROFILE%\.config\gh" 2>nul
    echo       Removed .config/gh data.
)
if exist "%LOCALAPPDATA%\GitHub CLI" (
    rmdir /s /q "%LOCALAPPDATA%\GitHub CLI" 2>nul
    echo       Removed local app data.
)
if exist "%USERPROFILE%\.local\share\gh" (
    rmdir /s /q "%USERPROFILE%\.local\share\gh" 2>nul
    echo       Removed extension data.
)
if exist "%USERPROFILE%\.local\state\gh" (
    rmdir /s /q "%USERPROFILE%\.local\state\gh" 2>nul
    echo       Removed state data.
)

echo.
echo [4/4] Verifying removal...
where gh >nul 2>&1
if errorlevel 1 (
    echo       GitHub CLI has been removed [OK]
) else (
    echo       [WARNING] gh still found in PATH.
    echo       Restart terminal or PC for changes.
)

echo.
echo ============================================
echo   UNINSTALL COMPLETE!
echo ============================================
echo   GitHub CLI has been safely removed.
echo   Restart terminal for PATH to update.
echo ============================================
echo.
pause
endlocal
exit /b 0
