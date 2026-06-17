@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title GitHub CLI - 설치 도구

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

echo.
echo ============================================
echo   GitHub CLI - 원클릭 설치 도구
echo ============================================
echo   설치 위치: %SCRIPT_DIR%
echo ============================================
echo.
echo   GitHub CLI 는 GitHub 를 명령어로 다루는 공식 도구입니다.
echo   이 창은 설치만 담당합니다. 설치 후 RUN.bat 으로 사용하세요.
echo.

REM === [1/5] 이미 설치되어 있는지 확인 ===
echo [1/5] GitHub CLI 가 이미 설치되어 있는지 확인합니다...
where gh >nul 2>&1
if not errorlevel 1 (
    for /f "tokens=*" %%i in ('gh --version 2^>nul') do echo       이미 설치됨: %%i
    echo.
    set "REINSTALL="
    set /p "REINSTALL=  이미 설치되어 있습니다. 최신 버전으로 업그레이드할까요? [y/N]: "
    if /i not "!REINSTALL!"=="y" (
        echo.
        echo       RUN.bat 을 실행하면 GitHub CLI 를 사용할 수 있습니다.
        pause
        endlocal
        exit /b 0
    )
    echo       업그레이드를 진행합니다...
)

REM === 관리자 권한 확인 ===
net session >nul 2>&1
if not errorlevel 1 goto :ADMIN_OK
echo.
echo   [안내] 지금은 관리자 권한이 아닙니다.
echo   GitHub CLI 설치는 보통 관리자 권한이 있어야 끝까지 진행됩니다.
echo.
echo   [1] 관리자 권한으로 다시 시작  - 권장. 허용 창이 뜨면 [예] 를 누르세요
echo   [2] 그냥 계속하기
echo.
set "ADM="
set /p "ADM=  선택 [1-2]: "
if "!ADM!"=="2" goto :ADMIN_OK
echo.
echo   권한을 올려 다시 시작합니다... 잠시 후 새 창이 열립니다.
echo   이 창은 닫혀도 됩니다.
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
endlocal
exit /b 0
:ADMIN_OK

REM === 인터넷 연결 확인 - 소프트 경고 ===
echo.
echo [확인] 인터넷 연결을 점검합니다...
ping -n 1 github.com >nul 2>&1
if errorlevel 1 (
    echo       [주의] 인터넷 연결이 확인되지 않습니다.
    echo       GitHub CLI 설치에는 인터넷이 필요합니다.
    echo       연결을 확인한 뒤 계속하세요. 연결돼 있어도 일부 환경에서는 이 경고가 나올 수 있습니다.
    echo.
    pause
)

REM === [2/5] 패키지 관리자 확인 ===
echo.
echo [2/5] 프로그램 설치 도구를 확인합니다... [winget 또는 scoop]
set "HAS_WINGET=0"
set "HAS_SCOOP=0"

where winget >nul 2>&1
if not errorlevel 1 (
    set "HAS_WINGET=1"
    for /f "tokens=*" %%i in ('winget --version 2^>nul') do echo       winget: %%i [확인됨]
)

where scoop >nul 2>&1
if not errorlevel 1 (
    set "HAS_SCOOP=1"
    echo       scoop: 사용 가능 [확인됨]
)

REM --- 설치 도구가 없으면 안내 후 종료 ---
if "!HAS_WINGET!"=="1" goto :PM_FOUND
if "!HAS_SCOOP!"=="1" goto :PM_FOUND

echo.
echo       [안내] winget 과 scoop 을 찾지 못했습니다.
echo       GitHub CLI 공식 설치 파일 .msi 를 직접 받아 설치할 수 있습니다.
echo.
set "DLGO="
set /p "DLGO=  자동으로 받아서 설치할까요? [Y/n]: "
if /i "!DLGO!"=="n" goto :MANUAL_GUIDE

REM --- 아키텍처 판별 ---
set "ARCHTAG=amd64"
if /i "%PROCESSOR_ARCHITECTURE%"=="ARM64" set "ARCHTAG=arm64"

echo.
echo       최신 설치 파일을 내려받습니다... [!ARCHTAG!]
set "MSIPATH=%TEMP%\gh_latest_!ARCHTAG!.msi"

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; try { $r=Invoke-RestMethod -Uri 'https://api.github.com/repos/cli/cli/releases/latest' -Headers @{'User-Agent'='gh-oneclick-kit'}; $a=$r.assets | Where-Object { $_.name -like '*windows_!ARCHTAG!.msi' } | Select-Object -First 1; if(-not $a){ throw 'msi asset not found' }; Invoke-WebRequest -Uri $a.browser_download_url -OutFile '!MSIPATH!' -UseBasicParsing; exit 0 } catch { Write-Host $_.Exception.Message; exit 1 }"

if errorlevel 1 goto :DL_FAIL
if not exist "!MSIPATH!" goto :DL_FAIL

echo       설치 파일을 실행합니다... 잠시 기다려 주세요.
call msiexec /i "!MSIPATH!" /passive
echo.
echo       설치 파일 실행을 마쳤습니다.
goto :AFTER_INSTALL

:DL_FAIL
echo.
echo       [주의] 자동 설치에 실패했습니다.

:MANUAL_GUIDE
echo.
echo       아래 페이지에서 설치 파일을 직접 받아 더블클릭하세요:
echo       https://github.com/cli/cli/releases/latest
echo       파일 이름에 windows_amd64.msi 가 들어간 파일을 받으세요.
start "" "https://github.com/cli/cli/releases/latest"
echo.
pause
endlocal
exit /b 2

:PM_FOUND
REM === 설치 방법 결정 ===
set "INSTALL_METHOD="
if "!HAS_WINGET!"=="1" if "!HAS_SCOOP!"=="0" set "INSTALL_METHOD=winget"
if "!HAS_WINGET!"=="0" if "!HAS_SCOOP!"=="1" set "INSTALL_METHOD=scoop"

REM --- 둘 다 있으면 사용자에게 선택 ---
if "!HAS_WINGET!"=="1" if "!HAS_SCOOP!"=="1" (
    echo.
    echo   winget 과 scoop 을 둘 다 사용할 수 있습니다.
    echo   [1] winget - 권장
    echo   [2] scoop
    echo.
    set "PM_CHOICE="
    set /p "PM_CHOICE=  선택 [1-2]: "
    if "!PM_CHOICE!"=="2" (
        set "INSTALL_METHOD=scoop"
    ) else (
        set "INSTALL_METHOD=winget"
    )
)

REM === [3/5] 설치 ===
echo.
echo [3/5] !INSTALL_METHOD! 로 GitHub CLI 를 설치합니다...
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
    echo       [오류] 설치에 실패했습니다.
    echo       관리자 권한으로 실행하거나 다른 방법을 사용해 보세요.
    echo.
    pause
    endlocal
    exit /b 3
)

:AFTER_INSTALL
REM === [4/5] PATH 새로고침 ===
echo.
echo [4/5] PATH 를 새로고침합니다...

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

REM === [5/5] 확인 ===
echo.
echo [5/5] 설치를 확인합니다...
if "!GH_FOUND!"=="1" (
    for /f "tokens=*" %%i in ('gh --version 2^>nul') do echo       %%i
    echo       설치가 확인되었습니다 [확인됨]
) else (
    echo       [주의] 현재 창에서는 gh 를 찾지 못했습니다.
    echo       터미널이나 PC 를 다시 시작하면 PATH 가 적용됩니다.
)

echo.
echo ============================================
echo   설치 완료
echo ============================================
echo   다음 단계:
echo     1. RUN.bat 을 실행해 GitHub CLI 를 시작하세요
echo     2. 메뉴 [1] 로그인 관리 에서 로그인하세요
echo.
echo   gh 명령을 인식하지 못하면 터미널을 다시 시작하세요.
echo ============================================
echo.
if "!GH_FOUND!"=="1" (
    set "GO="
    set /p "GO=  지금 바로 GitHub CLI 를 시작할까요? [Y/n]: "
    if /i not "!GO!"=="n" (
        echo       GitHub CLI 를 시작합니다...
        start "" "%SCRIPT_DIR%\RUN.bat"
        endlocal
        exit /b 0
    )
)
pause
endlocal
exit /b 0
