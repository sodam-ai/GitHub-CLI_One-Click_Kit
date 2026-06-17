@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title GitHub CLI - 제거 도구

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

echo.
echo ============================================
echo   GitHub CLI - 안전 제거 도구
echo ============================================
echo.

REM === 설치 여부 확인 ===
where gh >nul 2>&1
if errorlevel 1 (
    echo   [안내] GitHub CLI 가 설치되어 있지 않습니다.
    echo   제거할 항목이 없습니다.
    echo.
    pause
    endlocal
    exit /b 0
)

echo   현재 설치된 버전:
for /f "tokens=*" %%i in ('gh --version 2^>nul') do echo   %%i
echo.

echo   --- 현재 로그인 상태 ---
call gh auth status 2>nul
echo.

REM === 설정 백업 여부 확인 ===
set "DO_BACKUP=0"
if exist "%USERPROFILE%\.config\gh" (
    echo   [안내] gh 설정 파일을 찾았습니다.
    set "BC="
    set /p "BC=  제거하기 전에 설정을 백업할까요? [y/N]: "
    if /i "!BC!"=="y" set "DO_BACKUP=1"
    echo.
)

REM === 최종 확인 ===
echo ============================================
echo   [경고] 아래 작업이 진행됩니다:
echo     1. 모든 GitHub 계정에서 로그아웃
echo     2. GitHub CLI 제거
echo     3. gh 설정과 캐시 데이터 삭제
echo ============================================
echo.
set "CONFIRM="
set /p "CONFIRM=  제거하려면 YES 를 입력하세요: "
if /i not "!CONFIRM!"=="YES" (
    echo.
    echo   제거를 취소했습니다.
    echo.
    pause
    endlocal
    exit /b 0
)

REM === 백업 ===
if "!DO_BACKUP!"=="1" (
    echo.
    echo [0/4] 설정을 백업합니다...
    set "BACKUP_DIR=%SCRIPT_DIR%\gh-config-backup"
    if not exist "!BACKUP_DIR!" mkdir "!BACKUP_DIR!"
    xcopy "%USERPROFILE%\.config\gh\*" "!BACKUP_DIR!\" /E /I /Y >nul 2>&1
    echo       백업 위치: !BACKUP_DIR!
)

echo.
echo [1/4] GitHub 에서 로그아웃합니다...
call gh auth logout 2>nul
echo       로그아웃 완료.

echo.
echo [2/4] GitHub CLI 를 제거합니다...

set "UNINSTALLED=0"

where winget >nul 2>&1
if not errorlevel 1 (
    call winget uninstall --id GitHub.cli --source winget --accept-source-agreements 2>nul
    set "UNINSTALLED=1"
    echo       winget 제거 완료.
)

if "!UNINSTALLED!"=="0" (
    where scoop >nul 2>&1
    if not errorlevel 1 (
        call scoop uninstall gh 2>nul
        set "UNINSTALLED=1"
        echo       scoop 제거 완료.
    )
)

if "!UNINSTALLED!"=="0" (
    echo       [주의] 제거할 수 있는 패키지 관리자를 찾지 못했습니다.
    echo       다음 경로에서 직접 제거해 주세요:
    echo       설정 - 앱 - 설치된 앱 - GitHub CLI
)

echo.
echo [3/4] 설정과 캐시를 정리합니다...

if exist "%APPDATA%\GitHub CLI" (
    rmdir /s /q "%APPDATA%\GitHub CLI" 2>nul
    echo       설정 데이터 삭제 완료.
)
if exist "%USERPROFILE%\.config\gh" (
    rmdir /s /q "%USERPROFILE%\.config\gh" 2>nul
    echo       .config/gh 데이터 삭제 완료.
)
if exist "%LOCALAPPDATA%\GitHub CLI" (
    rmdir /s /q "%LOCALAPPDATA%\GitHub CLI" 2>nul
    echo       로컬 앱 데이터 삭제 완료.
)
if exist "%USERPROFILE%\.local\share\gh" (
    rmdir /s /q "%USERPROFILE%\.local\share\gh" 2>nul
    echo       확장 데이터 삭제 완료.
)
if exist "%USERPROFILE%\.local\state\gh" (
    rmdir /s /q "%USERPROFILE%\.local\state\gh" 2>nul
    echo       상태 데이터 삭제 완료.
)

echo.
echo [4/4] 제거를 확인합니다...
where gh >nul 2>&1
if errorlevel 1 (
    echo       GitHub CLI 가 제거되었습니다 [확인됨]
) else (
    echo       [주의] gh 가 아직 PATH 에서 발견됩니다.
    echo       터미널이나 PC 를 다시 시작하면 반영됩니다.
)

echo.
echo ============================================
echo   제거 완료
echo ============================================
echo   GitHub CLI 가 안전하게 제거되었습니다.
echo   PATH 반영을 위해 터미널을 다시 시작하세요.
echo ============================================
echo.
pause
endlocal
exit /b 0
