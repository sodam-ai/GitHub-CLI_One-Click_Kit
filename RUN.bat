@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title GitHub CLI - 제어판

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

REM === gh 확인 - PATH 폴백 포함 ===
set "GH_OK=0"
where gh >nul 2>&1
if not errorlevel 1 set "GH_OK=1"

if "!GH_OK!"=="0" if exist "%ProgramFiles%\GitHub CLI\gh.exe" (
    set "PATH=%ProgramFiles%\GitHub CLI;%PATH%"
    set "GH_OK=1"
)
if "!GH_OK!"=="0" if exist "%ProgramFiles(x86)%\GitHub CLI\gh.exe" (
    set "PATH=%ProgramFiles(x86)%\GitHub CLI;%PATH%"
    set "GH_OK=1"
)
if "!GH_OK!"=="0" if exist "%USERPROFILE%\scoop\apps\gh\current\bin\gh.exe" (
    set "PATH=%USERPROFILE%\scoop\apps\gh\current\bin;%PATH%"
    set "GH_OK=1"
)

if "!GH_OK!"=="0" (
    echo.
    echo   [오류] GitHub CLI 가 설치되어 있지 않습니다.
    echo   먼저 INSTALL.bat 을 실행해 주세요.
    echo.
    pause
    endlocal
    exit /b 1
)

REM === 로그인 상태 ===
set "AUTH_STATUS=로그인 안 됨"
gh auth status >nul 2>&1
if not errorlevel 1 set "AUTH_STATUS=로그인됨"

REM === 현재 폴더가 GitHub 저장소인지 ===
set "REPO_CTX=주의: 이 폴더는 GitHub 저장소가 아닙니다 - 저장소 기능은 owner/repo 를 직접 입력하세요"
if exist "%SCRIPT_DIR%\.git" set "REPO_CTX=현재 폴더에서 GitHub 저장소를 감지했습니다"

:MAIN_MENU
cls
echo.
echo ============================================
echo   GitHub CLI - 제어판
echo ============================================
for /f "tokens=*" %%i in ('gh --version 2^>nul') do echo   %%i
echo   로그인 상태: !AUTH_STATUS!
echo ============================================
echo.
echo   --- 기본 ---
echo    [1] 로그인 관리          - GitHub 계정 로그인/로그아웃
echo    [2] 저장소 작업          - 코드 저장소 만들기/복제/관리
echo    [3] 풀 리퀘스트 작업     - 코드 변경 제안 [Pull Request]
echo    [4] 이슈 작업            - 할 일/버그 등 이슈 관리
echo.
echo   --- 콘텐츠 ---
echo    [5] Gist 작업            - 코드 조각/메모 빠르게 공유
echo    [6] 릴리스 작업          - 배포 버전 관리 [Release]
echo    [7] 워크플로 / Actions   - 자동화 작업 실행/확인
echo.
echo   --- 관리 ---
echo    [8] SSH / GPG 키 관리    - 안전한 접속/서명용 열쇠
echo    [9] 확장 기능 관리       - gh 확장 프로그램
echo   [10] 설정 / 별칭          - 환경설정과 명령 단축키
echo.
echo   --- 유틸리티 ---
echo   [11] GitHub 검색          - 저장소/이슈/코드 검색
echo   [12] Codespace 작업       - 클라우드 개발 환경
echo   [13] API 호출             - GitHub API 직접 호출 [고급]
echo   [14] 버전 확인 / 업데이트 - gh 버전 확인과 업데이트
echo   [15] 직접 명령 입력       - gh 명령 직접 입력 [고급]
echo.
echo   --- 도움 ---
echo   [16] 문제 해결            - 안 될 때 여기! 자동 점검과 해결 안내
echo   [17] 쉬운 시작            - 처음이세요? 1-2-3 단계로 안내 [추천]
echo.
echo    [0] 종료
echo.
if "!AUTH_STATUS!"=="로그인 안 됨" echo   [추천] 처음이시면 [17] 쉬운 시작 을, 또는 [1] 로그인 관리 를 이용하세요.
echo.
set "MC="
set /p "MC=  선택 [0-17]: "
if "!MC!"=="1" goto :AUTH_MENU
if "!MC!"=="2" goto :REPO_MENU
if "!MC!"=="3" goto :PR_MENU
if "!MC!"=="4" goto :ISSUE_MENU
if "!MC!"=="5" goto :GIST_MENU
if "!MC!"=="6" goto :RELEASE_MENU
if "!MC!"=="7" goto :WORKFLOW_MENU
if "!MC!"=="8" goto :SSH_MENU
if "!MC!"=="9" goto :EXT_MENU
if "!MC!"=="10" goto :CONFIG_MENU
if "!MC!"=="11" goto :SEARCH_MENU
if "!MC!"=="12" goto :CODESPACE_MENU
if "!MC!"=="13" goto :API_MENU
if "!MC!"=="14" goto :VERSION_MENU
if "!MC!"=="15" goto :DIRECT_CMD
if "!MC!"=="16" goto :DIAGNOSE
if "!MC!"=="17" goto :WIZARD
if "!MC!"=="0" goto :EXIT_APP
echo.
echo   [안내] 0 부터 17 사이의 번호를 입력해 주세요.
pause
goto :MAIN_MENU

REM =============================================
:AUTH_MENU
cls
echo.
echo ============================================
echo   로그인 관리 [Auth]
echo ============================================
echo   GitHub 계정에 로그인하거나 로그아웃합니다.
echo   로그인 상태: !AUTH_STATUS!
echo ============================================
echo.
echo   [1] 로그인 - 브라우저      - 가장 쉬움. 웹 브라우저로 로그인
echo   [2] 로그인 - 토큰          - 토큰 문자열로 로그인
echo   [3] 로그인 - Enterprise    - 회사용 GitHub 서버 로그인
echo   [4] 로그인 상태 확인
echo   [5] 로그아웃
echo   [6] 토큰 보기
echo   [7] 토큰 새로고침
echo   [8] 계정 전환
echo.
echo   [0] 뒤로
echo.
set "CH="
set /p "CH=  선택 [0-8]: "
if "!CH!"=="1" (
    echo.
    echo   [안내] 잠시 후 화면에 8자리 코드가 나옵니다.
    echo          1. 그 코드를 복사하거나 적어두세요.
    echo          2. 자동으로 열리는 브라우저에 코드를 붙여넣으세요.
    echo          3. Authorize 승인 버튼을 누르면 끝납니다.
    echo.
    call gh auth login --web
    call gh auth status >nul 2>&1
    if not errorlevel 1 set "AUTH_STATUS=로그인됨"
    echo.
    pause
    goto :AUTH_MENU
)
if "!CH!"=="2" (
    echo.
    echo   토큰 발급 주소: https://github.com/settings/tokens
    echo.
    call gh auth login
    call gh auth status >nul 2>&1
    if not errorlevel 1 set "AUTH_STATUS=로그인됨"
    echo.
    pause
    goto :AUTH_MENU
)
if "!CH!"=="3" (
    echo.
    set "GHE="
    set /p "GHE=  Enterprise 호스트 이름 입력: "
    if not "!GHE!"=="" call gh auth login --hostname "!GHE!"
    echo.
    pause
    goto :AUTH_MENU
)
if "!CH!"=="4" (
    echo.
    call gh auth status
    echo.
    pause
    goto :AUTH_MENU
)
if "!CH!"=="5" (
    echo.
    call gh auth logout
    set "AUTH_STATUS=로그인 안 됨"
    echo.
    pause
    goto :AUTH_MENU
)
if "!CH!"=="6" (
    echo.
    call gh auth token
    echo.
    pause
    goto :AUTH_MENU
)
if "!CH!"=="7" (
    echo.
    call gh auth refresh
    echo.
    pause
    goto :AUTH_MENU
)
if "!CH!"=="8" (
    echo.
    call gh auth switch
    echo.
    pause
    goto :AUTH_MENU
)
if "!CH!"=="0" goto :MAIN_MENU
goto :AUTH_MENU

REM =============================================
:REPO_MENU
cls
echo.
echo ============================================
echo   저장소 작업 [Repository]
echo ============================================
echo   코드 저장소를 만들고 복제하고 관리합니다.
echo   !REPO_CTX!
echo ============================================
echo.
echo   [1] 저장소 복제 [clone]    - 저장소를 내 PC 로 내려받기
echo   [2] 새 저장소 만들기
echo   [3] 내 저장소 목록
echo   [4] 저장소 정보 보기
echo   [5] 저장소 포크 [fork]
echo   [6] 저장소 이름 변경
echo   [7] 저장소 삭제            - 영구 삭제 [주의]
echo   [8] 브라우저에서 열기
echo   [9] 내 활동 대시보드
echo  [10] 저장소 보관 [archive]
echo.
echo   [0] 뒤로
echo.
set "CH="
set /p "CH=  선택 [0-10]: "
if "!CH!"=="1" (
    echo.
    set "V="
    set /p "V=  복제할 저장소 입력 - owner/repo 또는 URL: "
    if not "!V!"=="" call gh repo clone "!V!"
    echo.
    pause
    goto :REPO_MENU
)
if "!CH!"=="2" (
    echo.
    call gh repo create
    echo.
    pause
    goto :REPO_MENU
)
if "!CH!"=="3" (
    echo.
    call gh repo list --limit 30
    echo.
    pause
    goto :REPO_MENU
)
if "!CH!"=="4" (
    echo.
    set "V="
    set /p "V=  저장소 입력 또는 Enter 로 현재 저장소: "
    if "!V!"=="" ( call gh repo view ) else ( call gh repo view "!V!" )
    echo.
    pause
    goto :REPO_MENU
)
if "!CH!"=="5" (
    echo.
    set "V="
    set /p "V=  포크할 저장소 입력 - owner/repo: "
    if not "!V!"=="" call gh repo fork "!V!"
    echo.
    pause
    goto :REPO_MENU
)
if "!CH!"=="6" (
    echo.
    set "V="
    set /p "V=  저장소 입력 - owner/repo: "
    if not "!V!"=="" (
        set "V2="
        set /p "V2=  새 이름 입력: "
        if not "!V2!"=="" call gh repo rename "!V2!" -R "!V!"
    )
    echo.
    pause
    goto :REPO_MENU
)
if "!CH!"=="7" goto :REPO_DELETE
if "!CH!"=="8" (
    echo.
    call gh browse
    echo.
    pause
    goto :REPO_MENU
)
if "!CH!"=="9" (
    echo.
    call gh status
    echo.
    pause
    goto :REPO_MENU
)
if "!CH!"=="10" (
    echo.
    set "V="
    set /p "V=  보관할 저장소 입력 - owner/repo: "
    if not "!V!"=="" call gh repo archive "!V!"
    echo.
    pause
    goto :REPO_MENU
)
if "!CH!"=="0" goto :MAIN_MENU
goto :REPO_MENU

:REPO_DELETE
echo.
set "V="
set /p "V=  삭제할 저장소 입력 - owner/repo: "
if "!V!"=="" goto :REPO_MENU
echo.
echo   [경고] 이 저장소를 영구히 삭제합니다. 되돌릴 수 없습니다.
echo   [참고] 저장소 삭제에는 delete_repo 권한이 있는 토큰이 필요합니다.
set "DC="
set /p "DC=  정말 삭제하려면 YES 를 입력하세요: "
if /i "!DC!"=="YES" ( call gh repo delete "!V!" --yes ) else ( echo   취소되었습니다. )
echo.
pause
goto :REPO_MENU

REM =============================================
:PR_MENU
cls
echo.
echo ============================================
echo   풀 리퀘스트 작업 [Pull Request]
echo ============================================
echo   코드 변경 제안을 만들고 검토하고 합칩니다.
echo   !REPO_CTX!
echo ============================================
echo.
echo   [1] PR 목록         [7] PR 다시 열기
echo   [2] PR 만들기       [8] PR 변경내용 [diff]
echo   [3] PR 보기         [9] PR 상태
echo   [4] PR 체크아웃    [10] 검토 준비완료 표시
echo   [5] PR 병합 [merge][11] PR 리뷰
echo   [6] PR 닫기        [12] PR 검사 [checks]
echo.
echo   [0] 뒤로
echo.
set "CH="
set /p "CH=  선택 [0-12]: "
if "!CH!"=="1" ( echo. & call gh pr list & echo. & pause & goto :PR_MENU )
if "!CH!"=="2" ( echo. & call gh pr create & echo. & pause & goto :PR_MENU )
if "!CH!"=="9" ( echo. & call gh pr status & echo. & pause & goto :PR_MENU )
if "!CH!"=="3" goto :PR_INPUT_VIEW
if "!CH!"=="4" goto :PR_INPUT_CO
if "!CH!"=="5" goto :PR_INPUT_MERGE
if "!CH!"=="6" goto :PR_INPUT_CLOSE
if "!CH!"=="7" goto :PR_INPUT_REOPEN
if "!CH!"=="8" goto :PR_INPUT_DIFF
if "!CH!"=="10" goto :PR_INPUT_READY
if "!CH!"=="11" goto :PR_INPUT_REVIEW
if "!CH!"=="12" goto :PR_INPUT_CHECKS
if "!CH!"=="0" goto :MAIN_MENU
goto :PR_MENU

:PR_INPUT_VIEW
echo.
set "V="
set /p "V=  PR 번호 입력: "
if not "!V!"=="" call gh pr view "!V!"
echo.
pause
goto :PR_MENU
:PR_INPUT_CO
echo.
set "V="
set /p "V=  체크아웃할 PR 번호 입력: "
if not "!V!"=="" call gh pr checkout "!V!"
echo.
pause
goto :PR_MENU
:PR_INPUT_MERGE
echo.
set "V="
set /p "V=  병합할 PR 번호 입력: "
if not "!V!"=="" call gh pr merge "!V!"
echo.
pause
goto :PR_MENU
:PR_INPUT_CLOSE
echo.
set "V="
set /p "V=  닫을 PR 번호 입력: "
if not "!V!"=="" call gh pr close "!V!"
echo.
pause
goto :PR_MENU
:PR_INPUT_REOPEN
echo.
set "V="
set /p "V=  다시 열 PR 번호 입력: "
if not "!V!"=="" call gh pr reopen "!V!"
echo.
pause
goto :PR_MENU
:PR_INPUT_DIFF
echo.
set "V="
set /p "V=  변경내용을 볼 PR 번호 입력: "
if not "!V!"=="" call gh pr diff "!V!"
echo.
pause
goto :PR_MENU
:PR_INPUT_READY
echo.
set "V="
set /p "V=  준비완료로 표시할 PR 번호 입력: "
if not "!V!"=="" call gh pr ready "!V!"
echo.
pause
goto :PR_MENU
:PR_INPUT_REVIEW
echo.
set "V="
set /p "V=  리뷰할 PR 번호 입력: "
if not "!V!"=="" call gh pr review "!V!"
echo.
pause
goto :PR_MENU
:PR_INPUT_CHECKS
echo.
set "V="
set /p "V=  검사 결과를 볼 PR 번호 입력: "
if not "!V!"=="" call gh pr checks "!V!"
echo.
pause
goto :PR_MENU

REM =============================================
:ISSUE_MENU
cls
echo.
echo ============================================
echo   이슈 작업 [Issue]
echo ============================================
echo   할 일/버그/문의 등 이슈를 만들고 관리합니다.
echo   !REPO_CTX!
echo ============================================
echo.
echo   [1] 이슈 목록        [7] 댓글 달기
echo   [2] 이슈 만들기      [8] 이슈 상태
echo   [3] 이슈 보기        [9] 이슈 고정 [pin]
echo   [4] 이슈 닫기       [10] 이슈 이동 [transfer]
echo   [5] 이슈 다시 열기  [11] 라벨 관리
echo   [6] 이슈 수정
echo.
echo   [0] 뒤로
echo.
set "CH="
set /p "CH=  선택 [0-11]: "
if "!CH!"=="1" ( echo. & call gh issue list & echo. & pause & goto :ISSUE_MENU )
if "!CH!"=="2" ( echo. & call gh issue create & echo. & pause & goto :ISSUE_MENU )
if "!CH!"=="8" ( echo. & call gh issue status & echo. & pause & goto :ISSUE_MENU )
if "!CH!"=="3" goto :ISS_VIEW
if "!CH!"=="4" goto :ISS_CLOSE
if "!CH!"=="5" goto :ISS_REOPEN
if "!CH!"=="6" goto :ISS_EDIT
if "!CH!"=="7" goto :ISS_COMMENT
if "!CH!"=="9" goto :ISS_PIN
if "!CH!"=="10" goto :ISS_TRANSFER
if "!CH!"=="11" goto :ISS_LABEL
if "!CH!"=="0" goto :MAIN_MENU
goto :ISSUE_MENU

:ISS_VIEW
echo.
set "V="
set /p "V=  이슈 번호 입력: "
if not "!V!"=="" call gh issue view "!V!"
echo.
pause
goto :ISSUE_MENU
:ISS_CLOSE
echo.
set "V="
set /p "V=  닫을 이슈 번호 입력: "
if not "!V!"=="" call gh issue close "!V!"
echo.
pause
goto :ISSUE_MENU
:ISS_REOPEN
echo.
set "V="
set /p "V=  다시 열 이슈 번호 입력: "
if not "!V!"=="" call gh issue reopen "!V!"
echo.
pause
goto :ISSUE_MENU
:ISS_EDIT
echo.
set "V="
set /p "V=  수정할 이슈 번호 입력: "
if not "!V!"=="" call gh issue edit "!V!"
echo.
pause
goto :ISSUE_MENU
:ISS_COMMENT
echo.
set "V="
set /p "V=  이슈 번호 입력: "
if not "!V!"=="" (
    set "V2="
    set /p "V2=  댓글 내용 입력: "
    if not "!V2!"=="" call gh issue comment "!V!" --body "!V2!"
)
echo.
pause
goto :ISSUE_MENU
:ISS_PIN
echo.
set "V="
set /p "V=  고정할 이슈 번호 입력: "
if not "!V!"=="" call gh issue pin "!V!"
echo.
pause
goto :ISSUE_MENU
:ISS_TRANSFER
echo.
set "V="
set /p "V=  이슈 번호 입력: "
if not "!V!"=="" (
    set "V2="
    set /p "V2=  옮길 대상 저장소 - owner/repo: "
    if not "!V2!"=="" call gh issue transfer "!V!" "!V2!"
)
echo.
pause
goto :ISSUE_MENU
:ISS_LABEL
echo.
echo   [a] 라벨 목록   [b] 라벨 만들기   [c] 라벨 삭제
echo.
set "V="
set /p "V=  선택: "
if /i "!V!"=="a" call gh label list
if /i "!V!"=="b" call gh label create
if /i "!V!"=="c" goto :ISS_LABEL_DEL
echo.
pause
goto :ISSUE_MENU
:ISS_LABEL_DEL
echo.
set "V2="
set /p "V2=  삭제할 라벨 이름 입력: "
if "!V2!"=="" goto :ISSUE_MENU
echo   [경고] 라벨 삭제는 되돌릴 수 없습니다.
set "DC="
set /p "DC=  삭제하려면 YES 를 입력하세요: "
if /i "!DC!"=="YES" ( call gh label delete "!V2!" --yes ) else ( echo   취소되었습니다. )
echo.
pause
goto :ISSUE_MENU

REM =============================================
:GIST_MENU
cls
echo.
echo ============================================
echo   Gist 작업
echo ============================================
echo   코드 조각이나 메모를 빠르게 올려 공유합니다.
echo ============================================
echo.
echo   [1] 내 Gist 목록
echo   [2] Gist 만들기 - 비공개
echo   [3] Gist 만들기 - 공개
echo   [4] Gist 보기
echo   [5] Gist 수정
echo   [6] Gist 삭제              - 영구 삭제 [주의]
echo   [7] Gist 복제 [clone]
echo.
echo   [0] 뒤로
echo.
set "CH="
set /p "CH=  선택 [0-7]: "
if "!CH!"=="1" ( echo. & call gh gist list & echo. & pause & goto :GIST_MENU )
if "!CH!"=="2" goto :GIST_CREATE
if "!CH!"=="3" goto :GIST_PUB
if "!CH!"=="4" goto :GIST_VIEW
if "!CH!"=="5" goto :GIST_EDIT
if "!CH!"=="6" goto :GIST_DEL
if "!CH!"=="7" goto :GIST_CLONE
if "!CH!"=="0" goto :MAIN_MENU
goto :GIST_MENU
:GIST_CREATE
echo.
set "V="
set /p "V=  파일 경로 입력: "
if not "!V!"=="" call gh gist create "!V!"
echo.
pause
goto :GIST_MENU
:GIST_PUB
echo.
set "V="
set /p "V=  파일 경로 입력: "
if not "!V!"=="" call gh gist create "!V!" --public
echo.
pause
goto :GIST_MENU
:GIST_VIEW
echo.
set "V="
set /p "V=  Gist ID 또는 URL 입력: "
if not "!V!"=="" call gh gist view "!V!"
echo.
pause
goto :GIST_MENU
:GIST_EDIT
echo.
set "V="
set /p "V=  수정할 Gist ID 입력: "
if not "!V!"=="" call gh gist edit "!V!"
echo.
pause
goto :GIST_MENU
:GIST_DEL
echo.
set "V="
set /p "V=  삭제할 Gist ID 입력: "
if "!V!"=="" goto :GIST_MENU
echo   [경고] 이 Gist 를 영구히 삭제합니다. 되돌릴 수 없습니다.
set "DC="
set /p "DC=  삭제하려면 YES 를 입력하세요: "
if /i "!DC!"=="YES" ( call gh gist delete "!V!" --yes ) else ( echo   취소되었습니다. )
echo.
pause
goto :GIST_MENU
:GIST_CLONE
echo.
set "V="
set /p "V=  복제할 Gist ID 입력: "
if not "!V!"=="" call gh gist clone "!V!"
echo.
pause
goto :GIST_MENU

REM =============================================
:RELEASE_MENU
cls
echo.
echo ============================================
echo   릴리스 작업 [Release]
echo ============================================
echo   배포 버전을 만들고 파일을 올리고 내려받습니다.
echo   !REPO_CTX!
echo ============================================
echo.
echo   [1] 목록   [2] 만들기  [3] 보기
echo   [4] 내려받기  [5] 수정  [6] 삭제 [주의]
echo.
echo   [0] 뒤로
echo.
set "CH="
set /p "CH=  선택 [0-6]: "
if "!CH!"=="1" ( echo. & call gh release list & echo. & pause & goto :RELEASE_MENU )
if "!CH!"=="2" goto :REL_CREATE
if "!CH!"=="3" goto :REL_VIEW
if "!CH!"=="4" goto :REL_DL
if "!CH!"=="5" goto :REL_EDIT
if "!CH!"=="6" goto :REL_DEL
if "!CH!"=="0" goto :MAIN_MENU
goto :RELEASE_MENU
:REL_CREATE
echo.
set "V="
set /p "V=  태그 이름 입력 - 예: v1.0.0: "
if not "!V!"=="" call gh release create "!V!"
echo.
pause
goto :RELEASE_MENU
:REL_VIEW
echo.
set "V="
set /p "V=  태그 입력 또는 Enter 로 최신: "
if "!V!"=="" ( call gh release view ) else ( call gh release view "!V!" )
echo.
pause
goto :RELEASE_MENU
:REL_DL
echo.
set "V="
set /p "V=  내려받을 태그 입력: "
if not "!V!"=="" call gh release download "!V!"
echo.
pause
goto :RELEASE_MENU
:REL_EDIT
echo.
set "V="
set /p "V=  수정할 태그 입력: "
if not "!V!"=="" call gh release edit "!V!"
echo.
pause
goto :RELEASE_MENU
:REL_DEL
echo.
set "V="
set /p "V=  삭제할 태그 입력: "
if "!V!"=="" goto :RELEASE_MENU
echo   [경고] 이 릴리스를 영구히 삭제합니다. 되돌릴 수 없습니다.
set "DC="
set /p "DC=  삭제하려면 YES 를 입력하세요: "
if /i "!DC!"=="YES" ( call gh release delete "!V!" --yes ) else ( echo   취소되었습니다. )
echo.
pause
goto :RELEASE_MENU

REM =============================================
:WORKFLOW_MENU
cls
echo.
echo ============================================
echo   워크플로 / GitHub Actions
echo ============================================
echo   자동화 작업의 실행 기록을 보고 다시 실행합니다.
echo   !REPO_CTX!
echo ============================================
echo.
echo   [1] 실행 목록     [6] 워크플로 목록
echo   [2] 실행 보기     [7] 워크플로 실행
echo   [3] 실행 실시간보기 [8] 결과물 내려받기
echo   [4] 실패만 재실행  [9] 로그 보기
echo   [5] 실행 취소
echo.
echo   [0] 뒤로
echo.
set "CH="
set /p "CH=  선택 [0-9]: "
if "!CH!"=="1" ( echo. & call gh run list & echo. & pause & goto :WORKFLOW_MENU )
if "!CH!"=="6" ( echo. & call gh workflow list & echo. & pause & goto :WORKFLOW_MENU )
if "!CH!"=="2" goto :WF_VIEW
if "!CH!"=="3" goto :WF_WATCH
if "!CH!"=="4" goto :WF_RERUN
if "!CH!"=="5" goto :WF_CANCEL
if "!CH!"=="7" goto :WF_RUN
if "!CH!"=="8" goto :WF_DL
if "!CH!"=="9" goto :WF_LOG
if "!CH!"=="0" goto :MAIN_MENU
goto :WORKFLOW_MENU
:WF_VIEW
echo.
set "V="
set /p "V=  실행 ID 입력: "
if not "!V!"=="" call gh run view "!V!"
echo.
pause
goto :WORKFLOW_MENU
:WF_WATCH
echo.
set "V="
set /p "V=  실시간으로 볼 실행 ID 입력: "
if not "!V!"=="" call gh run watch "!V!"
echo.
pause
goto :WORKFLOW_MENU
:WF_RERUN
echo.
set "V="
set /p "V=  다시 실행할 실행 ID 입력: "
if not "!V!"=="" call gh run rerun "!V!" --failed
echo.
pause
goto :WORKFLOW_MENU
:WF_CANCEL
echo.
set "V="
set /p "V=  취소할 실행 ID 입력: "
if not "!V!"=="" call gh run cancel "!V!"
echo.
pause
goto :WORKFLOW_MENU
:WF_RUN
echo.
set "V="
set /p "V=  워크플로 이름 또는 파일명 입력: "
if not "!V!"=="" call gh workflow run "!V!"
echo.
pause
goto :WORKFLOW_MENU
:WF_DL
echo.
set "V="
set /p "V=  결과물을 내려받을 실행 ID 입력: "
if not "!V!"=="" call gh run download "!V!"
echo.
pause
goto :WORKFLOW_MENU
:WF_LOG
echo.
set "V="
set /p "V=  로그를 볼 실행 ID 입력: "
if not "!V!"=="" call gh run view "!V!" --log
echo.
pause
goto :WORKFLOW_MENU

REM =============================================
:SSH_MENU
cls
echo.
echo ============================================
echo   SSH / GPG 키 관리
echo ============================================
echo   안전한 접속용 SSH 키와 서명용 GPG 키를 관리합니다.
echo ============================================
echo.
echo   [1] SSH 키 목록     [4] GPG 키 목록
echo   [2] SSH 키 추가     [5] GPG 키 추가
echo   [3] SSH 키 삭제     [6] GPG 키 삭제
echo.
echo   [주의] 3, 6 번 삭제는 되돌릴 수 없습니다. 삭제 전 YES 확인을 받습니다.
echo.
echo   [0] 뒤로
echo.
set "CH="
set /p "CH=  선택 [0-6]: "
if "!CH!"=="1" ( echo. & call gh ssh-key list & echo. & pause & goto :SSH_MENU )
if "!CH!"=="4" ( echo. & call gh gpg-key list & echo. & pause & goto :SSH_MENU )
if "!CH!"=="2" goto :SSH_ADD
if "!CH!"=="3" goto :SSH_DEL
if "!CH!"=="5" goto :GPG_ADD
if "!CH!"=="6" goto :GPG_DEL
if "!CH!"=="0" goto :MAIN_MENU
goto :SSH_MENU
:SSH_ADD
echo.
set "V="
set /p "V=  공개키 파일 경로 입력: "
if not "!V!"=="" call gh ssh-key add "!V!"
echo.
pause
goto :SSH_MENU
:SSH_DEL
echo.
set "V="
set /p "V=  삭제할 SSH 키 ID 입력: "
if "!V!"=="" goto :SSH_MENU
echo   [경고] 이 SSH 키를 삭제합니다. 되돌릴 수 없습니다.
set "DC="
set /p "DC=  삭제하려면 YES 를 입력하세요: "
if /i "!DC!"=="YES" ( call gh ssh-key delete "!V!" --yes ) else ( echo   취소되었습니다. )
echo.
pause
goto :SSH_MENU
:GPG_ADD
echo.
set "V="
set /p "V=  GPG 키 파일 경로 입력: "
if not "!V!"=="" call gh gpg-key add "!V!"
echo.
pause
goto :SSH_MENU
:GPG_DEL
echo.
set "V="
set /p "V=  삭제할 GPG 키 ID 입력: "
if "!V!"=="" goto :SSH_MENU
echo   [경고] 이 GPG 키를 삭제합니다. 되돌릴 수 없습니다.
set "DC="
set /p "DC=  삭제하려면 YES 를 입력하세요: "
if /i "!DC!"=="YES" ( call gh gpg-key delete "!V!" --yes ) else ( echo   취소되었습니다. )
echo.
pause
goto :SSH_MENU

REM =============================================
:EXT_MENU
cls
echo.
echo ============================================
echo   확장 기능 관리 [Extension]
echo ============================================
echo   gh 에 기능을 더하는 확장 프로그램을 관리합니다.
echo ============================================
echo.
echo   [1] 목록    [2] 설치  [3] 업그레이드
echo   [4] 전체 업그레이드  [5] 제거
echo   [6] 만들기  [7] 둘러보기 [browse]
echo.
echo   [0] 뒤로
echo.
set "CH="
set /p "CH=  선택 [0-7]: "
if "!CH!"=="1" ( echo. & call gh extension list & echo. & pause & goto :EXT_MENU )
if "!CH!"=="4" ( echo. & call gh extension upgrade --all & echo. & pause & goto :EXT_MENU )
if "!CH!"=="6" ( echo. & call gh extension create & echo. & pause & goto :EXT_MENU )
if "!CH!"=="7" ( echo. & call gh extension browse & echo. & pause & goto :EXT_MENU )
if "!CH!"=="2" goto :EXT_INST
if "!CH!"=="3" goto :EXT_UPG
if "!CH!"=="5" goto :EXT_RM
if "!CH!"=="0" goto :MAIN_MENU
goto :EXT_MENU
:EXT_INST
echo.
set "V="
set /p "V=  확장 기능 입력 - owner/gh-ext-name: "
if not "!V!"=="" call gh extension install "!V!"
echo.
pause
goto :EXT_MENU
:EXT_UPG
echo.
set "V="
set /p "V=  확장 기능 이름 입력: "
if not "!V!"=="" call gh extension upgrade "!V!"
echo.
pause
goto :EXT_MENU
:EXT_RM
echo.
set "V="
set /p "V=  제거할 확장 기능 이름 입력: "
if not "!V!"=="" call gh extension remove "!V!"
echo.
pause
goto :EXT_MENU

REM =============================================
:CONFIG_MENU
cls
echo.
echo ============================================
echo   설정 / 별칭 [Config / Alias]
echo ============================================
echo   gh 환경설정과 자주 쓰는 명령 단축키를 관리합니다.
echo ============================================
echo.
echo   [1] 설정 목록      [5] 별칭 만들기
echo   [2] 설정 보기      [6] 별칭 삭제
echo   [3] 설정 변경      [7] 별칭 가져오기
echo   [4] 별칭 목록
echo.
echo   [0] 뒤로
echo.
set "CH="
set /p "CH=  선택 [0-7]: "
if "!CH!"=="1" ( echo. & call gh config list & echo. & pause & goto :CONFIG_MENU )
if "!CH!"=="4" ( echo. & call gh alias list & echo. & pause & goto :CONFIG_MENU )
if "!CH!"=="2" goto :CFG_GET
if "!CH!"=="3" goto :CFG_SET
if "!CH!"=="5" goto :ALIAS_SET
if "!CH!"=="6" goto :ALIAS_DEL
if "!CH!"=="7" goto :ALIAS_IMP
if "!CH!"=="0" goto :MAIN_MENU
goto :CONFIG_MENU
:CFG_GET
echo.
set "V="
set /p "V=  설정 키 - editor, git_protocol, browser, pager: "
if not "!V!"=="" call gh config get "!V!"
echo.
pause
goto :CONFIG_MENU
:CFG_SET
echo.
set "V="
set /p "V=  설정 키 입력: "
if not "!V!"=="" (
    set "V2="
    set /p "V2=  값 입력: "
    if not "!V2!"=="" call gh config set "!V!" "!V2!"
)
echo.
pause
goto :CONFIG_MENU
:ALIAS_SET
echo.
set "V="
set /p "V=  별칭 이름 입력: "
if not "!V!"=="" (
    set "V2="
    set /p "V2=  명령 - 예: issue list --label=bug: "
    if not "!V2!"=="" call gh alias set "!V!" "!V2!"
)
echo.
pause
goto :CONFIG_MENU
:ALIAS_DEL
echo.
set "V="
set /p "V=  삭제할 별칭 이름 입력: "
if not "!V!"=="" call gh alias delete "!V!"
echo.
pause
goto :CONFIG_MENU
:ALIAS_IMP
echo.
set "V="
set /p "V=  별칭 파일 경로 입력: "
if not "!V!"=="" call gh alias import "!V!"
echo.
pause
goto :CONFIG_MENU

REM =============================================
:SEARCH_MENU
cls
echo.
echo ============================================
echo   GitHub 검색 [Search]
echo ============================================
echo   GitHub 전체에서 저장소/이슈/코드 등을 검색합니다.
echo ============================================
echo.
echo   [1] 저장소  [2] 이슈  [3] PR
echo   [4] 코드    [5] 커밋
echo.
echo   [0] 뒤로
echo.
set "CH="
set /p "CH=  선택 [0-5]: "
if "!CH!"=="1" goto :S_REPOS
if "!CH!"=="2" goto :S_ISSUES
if "!CH!"=="3" goto :S_PRS
if "!CH!"=="4" goto :S_CODE
if "!CH!"=="5" goto :S_COMMITS
if "!CH!"=="0" goto :MAIN_MENU
goto :SEARCH_MENU
:S_REPOS
echo.
set "V="
set /p "V=  검색어 입력: "
if not "!V!"=="" call gh search repos "!V!"
echo.
pause
goto :SEARCH_MENU
:S_ISSUES
echo.
set "V="
set /p "V=  검색어 입력: "
if not "!V!"=="" call gh search issues "!V!"
echo.
pause
goto :SEARCH_MENU
:S_PRS
echo.
set "V="
set /p "V=  검색어 입력: "
if not "!V!"=="" call gh search prs "!V!"
echo.
pause
goto :SEARCH_MENU
:S_CODE
echo.
set "V="
set /p "V=  검색어 입력: "
if not "!V!"=="" call gh search code "!V!"
echo.
pause
goto :SEARCH_MENU
:S_COMMITS
echo.
set "V="
set /p "V=  검색어 입력: "
if not "!V!"=="" call gh search commits "!V!"
echo.
pause
goto :SEARCH_MENU

REM =============================================
:CODESPACE_MENU
cls
echo.
echo ============================================
echo   Codespace 작업
echo ============================================
echo   인터넷에 있는 클라우드 개발 환경을 다룹니다.
echo ============================================
echo.
echo   [1] 목록    [2] 만들기  [3] SSH 접속
echo   [4] VS Code [5] 중지    [6] 삭제
echo   [7] 로그
echo.
echo   [0] 뒤로
echo.
set "CH="
set /p "CH=  선택 [0-7]: "
if "!CH!"=="1" ( echo. & call gh codespace list & echo. & pause & goto :CODESPACE_MENU )
if "!CH!"=="2" ( echo. & call gh codespace create & echo. & pause & goto :CODESPACE_MENU )
if "!CH!"=="3" ( echo. & call gh codespace ssh & echo. & pause & goto :CODESPACE_MENU )
if "!CH!"=="4" ( echo. & call gh codespace code & echo. & pause & goto :CODESPACE_MENU )
if "!CH!"=="5" ( echo. & call gh codespace stop & echo. & pause & goto :CODESPACE_MENU )
if "!CH!"=="6" ( echo. & call gh codespace delete & echo. & pause & goto :CODESPACE_MENU )
if "!CH!"=="7" ( echo. & call gh codespace logs & echo. & pause & goto :CODESPACE_MENU )
if "!CH!"=="0" goto :MAIN_MENU
goto :CODESPACE_MENU

REM =============================================
:API_MENU
cls
echo.
echo ============================================
echo   GitHub API 호출 [고급]
echo ============================================
echo   GitHub API 를 직접 호출합니다. 개발자용 고급 기능입니다.
echo   예시: /user 또는 /repos/owner/repo
echo ============================================
echo.
echo   [1] GET 요청
echo   [2] POST 요청
echo   [3] 로그인한 내 정보 보기
echo   [4] 사용량 제한 보기 [rate limit]
echo   [5] GraphQL 질의
echo.
echo   [0] 뒤로
echo.
set "CH="
set /p "CH=  선택 [0-5]: "
if "!CH!"=="3" ( echo. & call gh api /user & echo. & pause & goto :API_MENU )
if "!CH!"=="4" ( echo. & call gh api /rate_limit & echo. & pause & goto :API_MENU )
if "!CH!"=="1" goto :API_GET
if "!CH!"=="2" goto :API_POST
if "!CH!"=="5" goto :API_GQL
if "!CH!"=="0" goto :MAIN_MENU
goto :API_MENU
:API_GET
echo.
set "V="
set /p "V=  API 경로 입력 - 예: /user: "
if not "!V!"=="" call gh api "!V!"
echo.
pause
goto :API_MENU
:API_POST
echo.
set "V="
set /p "V=  API 경로 입력: "
if not "!V!"=="" call gh api "!V!" --method POST
echo.
pause
goto :API_MENU
:API_GQL
echo.
set "V="
set /p "V=  GraphQL 질의 입력: "
if not "!V!"=="" call gh api graphql -f query="!V!"
echo.
pause
goto :API_MENU

REM =============================================
:VERSION_MENU
cls
echo.
echo ============================================
echo   버전 확인 / 업데이트
echo ============================================
echo.
echo   --- 설치된 버전 ---
for /f "tokens=*" %%i in ('gh --version 2^>nul') do echo   %%i
echo.
where winget >nul 2>&1
if not errorlevel 1 (
    echo   --- winget 패키지 정보 ---
    call winget list --id GitHub.cli --source winget 2>nul
    echo.
)
echo ============================================
echo.
echo   [1] winget 로 업데이트
echo   [2] scoop 으로 업데이트
echo   [3] 자세한 버전 정보
echo.
echo   [0] 뒤로
echo.
set "CH="
set /p "CH=  선택 [0-3]: "
if "!CH!"=="1" goto :VER_WINGET
if "!CH!"=="2" goto :VER_SCOOP
if "!CH!"=="3" goto :VER_DETAIL
if "!CH!"=="0" goto :MAIN_MENU
goto :VERSION_MENU
:VER_WINGET
echo.
echo   --- 업데이트 전 ---
for /f "tokens=*" %%i in ('gh --version 2^>nul') do echo   %%i
echo.
call winget upgrade --id GitHub.cli --source winget --accept-source-agreements --accept-package-agreements
echo.
echo   --- 업데이트 후 ---
for /f "tokens=*" %%i in ('gh --version 2^>nul') do echo   %%i
echo.
echo   [안내] 버전이 그대로면 터미널을 다시 시작하세요.
echo.
pause
goto :VERSION_MENU
:VER_SCOOP
echo.
echo   --- 업데이트 전 ---
for /f "tokens=*" %%i in ('gh --version 2^>nul') do echo   %%i
echo.
call scoop update gh
echo.
echo   --- 업데이트 후 ---
for /f "tokens=*" %%i in ('gh --version 2^>nul') do echo   %%i
echo.
pause
goto :VERSION_MENU
:VER_DETAIL
echo.
call gh version
echo.
call gh --version
echo.
pause
goto :VERSION_MENU

REM =============================================
:DIRECT_CMD
cls
echo.
echo ============================================
echo   직접 명령 입력 [고급]
echo ============================================
echo   gh 를 뺀 나머지 명령을 그대로 입력하세요.
echo   예시: repo list --limit 10
echo   메인 메뉴로 돌아가려면 back 을 입력하세요.
echo ============================================
echo.
:DIRECT_CMD_LOOP
set "V="
set /p "V=  gh > "
if /i "!V!"=="back" goto :MAIN_MENU
if /i "!V!"=="exit" goto :MAIN_MENU
if /i "!V!"=="quit" goto :MAIN_MENU
if "!V!"=="" goto :DIRECT_CMD_LOOP
echo.
call gh !V!
echo.
goto :DIRECT_CMD_LOOP

REM =============================================
:DIAGNOSE
cls
echo.
echo ============================================
echo   문제 해결 - 자동 점검
echo ============================================
echo   안 되는 게 있으면 아래 결과의 [해결] 안내를 따라 하세요.
echo ============================================
echo.
echo   [1] GitHub CLI 설치 확인...
where gh >nul 2>&1
if not errorlevel 1 (
    for /f "tokens=*" %%i in ('gh --version 2^>nul') do echo       정상: %%i
) else (
    echo       문제: gh 를 찾을 수 없습니다.
    echo       해결: INSTALL.bat 을 실행하거나 터미널을 다시 시작하세요.
)
echo.
echo   [2] 인터넷 연결 확인...
ping -n 1 github.com >nul 2>&1
if not errorlevel 1 (
    echo       정상: 인터넷에 연결되어 있습니다.
) else (
    echo       문제: 인터넷 연결이 확인되지 않습니다.
    echo       해결: 와이파이 또는 랜선을 확인하세요. 회사망이면 방화벽일 수 있습니다.
)
echo.
echo   [3] 로그인 상태 확인...
gh auth status >nul 2>&1
if not errorlevel 1 (
    echo       정상: 로그인되어 있습니다.
) else (
    echo       문제: 로그인되어 있지 않습니다.
    echo       해결: 메인 메뉴 [1] 로그인 관리 에서 로그인하세요.
)
echo.
echo   [4] 현재 폴더 확인...
if exist "%SCRIPT_DIR%\.git" (
    echo       정상: 현재 폴더는 GitHub 저장소입니다.
) else (
    echo       참고: 현재 폴더는 저장소가 아닙니다.
    echo             저장소 기능은 owner/repo 를 직접 입력하면 됩니다.
)
echo.
echo ============================================
echo   점검이 끝났습니다.
echo ============================================
echo.
set "SAVELOG="
set /p "SAVELOG=  이 결과를 파일로 저장할까요? 도움 요청 시 유용합니다 [y/N]: "
if /i not "!SAVELOG!"=="y" goto :DIAG_END
set "LOGFILE=%SCRIPT_DIR%\gh-help-log.txt"
echo GitHub CLI 문제 해결 점검 결과 > "!LOGFILE!"
gh --version >> "!LOGFILE!" 2>&1
echo. >> "!LOGFILE!"
echo [auth status] >> "!LOGFILE!"
gh auth status >> "!LOGFILE!" 2>&1
echo       저장됨: !LOGFILE!
:DIAG_END
echo.
pause
goto :MAIN_MENU

REM =============================================
:WIZARD
cls
echo.
echo ============================================
echo   쉬운 시작 - 처음이신 분들을 위한 안내
echo ============================================
echo   딱 3단계만 따라 하면 됩니다.
echo ============================================
echo.
echo   [1단계] 로그인 확인
gh auth status >nul 2>&1
if not errorlevel 1 goto :WIZ_LOGGEDIN
echo       아직 로그인되어 있지 않습니다.
set "W1="
set /p "W1=  지금 로그인할까요? [Y/n]: "
if /i "!W1!"=="n" goto :WIZ_STEP2
echo.
echo   [안내] 잠시 후 8자리 코드가 나옵니다.
echo          복사 -^> 자동으로 열리는 브라우저에 붙여넣기 -^> Authorize 클릭.
echo.
call gh auth login --web
call gh auth status >nul 2>&1
if not errorlevel 1 set "AUTH_STATUS=로그인됨"
goto :WIZ_STEP2
:WIZ_LOGGEDIN
echo       이미 로그인되어 있습니다. 좋아요!
:WIZ_STEP2
echo.
echo   [2단계] 무엇을 해볼까요?
echo       [1] 남의 코드를 내 PC 로 받기   [clone]
echo       [2] 내 저장소 새로 만들기
echo       [3] 지금은 둘러보기만 하기
echo.
set "W2="
set /p "W2=  선택 [1-3]: "
if "!W2!"=="1" goto :WIZ_CLONE
if "!W2!"=="2" goto :WIZ_CREATE
goto :WIZ_DONE
:WIZ_CLONE
echo.
set "W3="
set /p "W3=  받을 저장소 입력 - 예: owner/repo 또는 주소: "
if not "!W3!"=="" call gh repo clone "!W3!"
goto :WIZ_DONE
:WIZ_CREATE
echo.
echo   화면 안내에 따라 이름과 공개/비공개를 고르면 됩니다.
call gh repo create
goto :WIZ_DONE
:WIZ_DONE
echo.
echo ============================================
echo   끝났습니다! 이제 메인 메뉴에서 더 많은 기능을 쓸 수 있어요.
echo ============================================
echo.
pause
goto :MAIN_MENU

:EXIT_APP
echo.
echo   이용해 주셔서 감사합니다.
echo.
endlocal
exit /b 0
