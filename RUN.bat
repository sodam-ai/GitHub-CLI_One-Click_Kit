@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title GitHub CLI - Control Panel

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

REM === Check gh with PATH fallbacks ===
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
    echo   [ERROR] GitHub CLI is not installed.
    echo   Please run INSTALL.bat first.
    echo.
    pause
    endlocal
    exit /b 1
)

REM === Auth status ===
set "AUTH_STATUS=Not logged in"
gh auth status >nul 2>&1
if not errorlevel 1 set "AUTH_STATUS=Logged in"

:MAIN_MENU
cls
echo.
echo ============================================
echo   GitHub CLI - Control Panel
echo ============================================
for /f "tokens=*" %%i in ('gh --version 2^>nul') do echo   %%i
echo   Auth: !AUTH_STATUS!
echo ============================================
echo.
echo   --- Core ---
echo    [1] Auth Management
echo    [2] Repository Operations
echo    [3] Pull Request Operations
echo    [4] Issue Operations
echo.
echo   --- Content ---
echo    [5] Gist Operations
echo    [6] Release Operations
echo    [7] Workflow / Actions
echo.
echo   --- Management ---
echo    [8] SSH / GPG Key Management
echo    [9] Extension Management
echo   [10] Configuration / Alias
echo.
echo   --- Utilities ---
echo   [11] Search GitHub
echo   [12] Codespace Operations
echo   [13] API Call
echo   [14] Version Check and Update
echo   [15] Direct Command Input
echo.
echo    [0] Exit
echo.
set "MC="
set /p "MC=  Select [0-15]: "
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
if "!MC!"=="0" goto :EXIT_APP
goto :MAIN_MENU

REM =============================================
:AUTH_MENU
cls
echo.
echo ============================================
echo   Auth Management
echo ============================================
echo.
echo   [1] Login - Browser
echo   [2] Login - Token
echo   [3] Login - GitHub Enterprise
echo   [4] Auth Status
echo   [5] Logout
echo   [6] View Token
echo   [7] Refresh Auth Token
echo   [8] Switch Account
echo.
echo   [0] Back
echo.
set "CH="
set /p "CH=  Select [0-8]: "
if "!CH!"=="1" (
    echo.
    call gh auth login --web
    call gh auth status >nul 2>&1
    if not errorlevel 1 set "AUTH_STATUS=Logged in"
    echo.
    pause
    goto :AUTH_MENU
)
if "!CH!"=="2" (
    echo.
    echo   Get a token from: https://github.com/settings/tokens
    echo.
    call gh auth login
    call gh auth status >nul 2>&1
    if not errorlevel 1 set "AUTH_STATUS=Logged in"
    echo.
    pause
    goto :AUTH_MENU
)
if "!CH!"=="3" (
    echo.
    set "GHE="
    set /p "GHE=  Enter Enterprise hostname: "
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
    set "AUTH_STATUS=Not logged in"
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
echo   Repository Operations
echo ============================================
echo.
echo   [1] Clone Repository
echo   [2] Create New Repository
echo   [3] List My Repositories
echo   [4] View Repository Info
echo   [5] Fork Repository
echo   [6] Rename Repository
echo   [7] Delete Repository
echo   [8] Browse in Browser
echo   [9] Dashboard
echo  [10] Archive Repository
echo.
echo   [0] Back
echo.
set "CH="
set /p "CH=  Select [0-10]: "
if "!CH!"=="1" (
    echo.
    set "V="
    set /p "V=  Enter repo - owner/repo or URL: "
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
    set /p "V=  Enter repo or Enter for current: "
    if "!V!"=="" ( call gh repo view ) else ( call gh repo view "!V!" )
    echo.
    pause
    goto :REPO_MENU
)
if "!CH!"=="5" (
    echo.
    set "V="
    set /p "V=  Enter repo to fork - owner/repo: "
    if not "!V!"=="" call gh repo fork "!V!"
    echo.
    pause
    goto :REPO_MENU
)
if "!CH!"=="6" (
    echo.
    set "V="
    set /p "V=  Enter repo - owner/repo: "
    if not "!V!"=="" (
        set "V2="
        set /p "V2=  Enter new name: "
        if not "!V2!"=="" call gh repo rename "!V2!" -R "!V!"
    )
    echo.
    pause
    goto :REPO_MENU
)
if "!CH!"=="7" (
    echo.
    set "V="
    set /p "V=  Enter repo to delete - owner/repo: "
    if not "!V!"=="" (
        echo   [WARNING] This will PERMANENTLY delete!
        call gh repo delete "!V!" --confirm
    )
    echo.
    pause
    goto :REPO_MENU
)
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
    set /p "V=  Enter repo to archive - owner/repo: "
    if not "!V!"=="" call gh repo archive "!V!"
    echo.
    pause
    goto :REPO_MENU
)
if "!CH!"=="0" goto :MAIN_MENU
goto :REPO_MENU

REM =============================================
:PR_MENU
cls
echo.
echo ============================================
echo   Pull Request Operations
echo ============================================
echo.
echo   [1] List PRs        [7] Reopen PR
echo   [2] Create PR       [8] PR Diff
echo   [3] View PR         [9] PR Status
echo   [4] Checkout PR    [10] Mark Ready
echo   [5] Merge PR       [11] Review PR
echo   [6] Close PR       [12] PR Checks
echo.
echo   [0] Back
echo.
set "CH="
set /p "CH=  Select [0-12]: "
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
set /p "V=  Enter PR number: "
if not "!V!"=="" call gh pr view "!V!"
echo.
pause
goto :PR_MENU
:PR_INPUT_CO
echo.
set "V="
set /p "V=  Enter PR number to checkout: "
if not "!V!"=="" call gh pr checkout "!V!"
echo.
pause
goto :PR_MENU
:PR_INPUT_MERGE
echo.
set "V="
set /p "V=  Enter PR number to merge: "
if not "!V!"=="" call gh pr merge "!V!"
echo.
pause
goto :PR_MENU
:PR_INPUT_CLOSE
echo.
set "V="
set /p "V=  Enter PR number to close: "
if not "!V!"=="" call gh pr close "!V!"
echo.
pause
goto :PR_MENU
:PR_INPUT_REOPEN
echo.
set "V="
set /p "V=  Enter PR number to reopen: "
if not "!V!"=="" call gh pr reopen "!V!"
echo.
pause
goto :PR_MENU
:PR_INPUT_DIFF
echo.
set "V="
set /p "V=  Enter PR number for diff: "
if not "!V!"=="" call gh pr diff "!V!"
echo.
pause
goto :PR_MENU
:PR_INPUT_READY
echo.
set "V="
set /p "V=  Enter PR number to mark ready: "
if not "!V!"=="" call gh pr ready "!V!"
echo.
pause
goto :PR_MENU
:PR_INPUT_REVIEW
echo.
set "V="
set /p "V=  Enter PR number to review: "
if not "!V!"=="" call gh pr review "!V!"
echo.
pause
goto :PR_MENU
:PR_INPUT_CHECKS
echo.
set "V="
set /p "V=  Enter PR number for checks: "
if not "!V!"=="" call gh pr checks "!V!"
echo.
pause
goto :PR_MENU

REM =============================================
:ISSUE_MENU
cls
echo.
echo ============================================
echo   Issue Operations
echo ============================================
echo.
echo   [1] List Issues      [7] Comment
echo   [2] Create Issue     [8] Issue Status
echo   [3] View Issue       [9] Pin Issue
echo   [4] Close Issue     [10] Transfer Issue
echo   [5] Reopen Issue    [11] Label Management
echo   [6] Edit Issue
echo.
echo   [0] Back
echo.
set "CH="
set /p "CH=  Select [0-11]: "
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
set /p "V=  Enter issue number: "
if not "!V!"=="" call gh issue view "!V!"
echo.
pause
goto :ISSUE_MENU
:ISS_CLOSE
echo.
set "V="
set /p "V=  Enter issue number to close: "
if not "!V!"=="" call gh issue close "!V!"
echo.
pause
goto :ISSUE_MENU
:ISS_REOPEN
echo.
set "V="
set /p "V=  Enter issue number to reopen: "
if not "!V!"=="" call gh issue reopen "!V!"
echo.
pause
goto :ISSUE_MENU
:ISS_EDIT
echo.
set "V="
set /p "V=  Enter issue number to edit: "
if not "!V!"=="" call gh issue edit "!V!"
echo.
pause
goto :ISSUE_MENU
:ISS_COMMENT
echo.
set "V="
set /p "V=  Enter issue number: "
if not "!V!"=="" (
    set "V2="
    set /p "V2=  Enter comment: "
    if not "!V2!"=="" call gh issue comment "!V!" --body "!V2!"
)
echo.
pause
goto :ISSUE_MENU
:ISS_PIN
echo.
set "V="
set /p "V=  Enter issue number to pin: "
if not "!V!"=="" call gh issue pin "!V!"
echo.
pause
goto :ISSUE_MENU
:ISS_TRANSFER
echo.
set "V="
set /p "V=  Enter issue number: "
if not "!V!"=="" (
    set "V2="
    set /p "V2=  Destination repo - owner/repo: "
    if not "!V2!"=="" call gh issue transfer "!V!" "!V2!"
)
echo.
pause
goto :ISSUE_MENU
:ISS_LABEL
echo.
echo   [a] List labels  [b] Create label  [c] Delete label
echo.
set "V="
set /p "V=  Select: "
if /i "!V!"=="a" call gh label list
if /i "!V!"=="b" call gh label create
if /i "!V!"=="c" (
    set "V2="
    set /p "V2=  Label name to delete: "
    if not "!V2!"=="" call gh label delete "!V2!" --confirm
)
echo.
pause
goto :ISSUE_MENU

REM =============================================
:GIST_MENU
cls
echo.
echo ============================================
echo   Gist Operations
echo ============================================
echo.
echo   [1] List My Gists
echo   [2] Create Gist - private
echo   [3] Create Gist - public
echo   [4] View Gist
echo   [5] Edit Gist
echo   [6] Delete Gist
echo   [7] Clone Gist
echo.
echo   [0] Back
echo.
set "CH="
set /p "CH=  Select [0-7]: "
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
set /p "V=  Enter file path: "
if not "!V!"=="" call gh gist create "!V!"
echo.
pause
goto :GIST_MENU
:GIST_PUB
echo.
set "V="
set /p "V=  Enter file path: "
if not "!V!"=="" call gh gist create "!V!" --public
echo.
pause
goto :GIST_MENU
:GIST_VIEW
echo.
set "V="
set /p "V=  Enter Gist ID or URL: "
if not "!V!"=="" call gh gist view "!V!"
echo.
pause
goto :GIST_MENU
:GIST_EDIT
echo.
set "V="
set /p "V=  Enter Gist ID to edit: "
if not "!V!"=="" call gh gist edit "!V!"
echo.
pause
goto :GIST_MENU
:GIST_DEL
echo.
set "V="
set /p "V=  Enter Gist ID to delete: "
if not "!V!"=="" call gh gist delete "!V!"
echo.
pause
goto :GIST_MENU
:GIST_CLONE
echo.
set "V="
set /p "V=  Enter Gist ID to clone: "
if not "!V!"=="" call gh gist clone "!V!"
echo.
pause
goto :GIST_MENU

REM =============================================
:RELEASE_MENU
cls
echo.
echo ============================================
echo   Release Operations
echo ============================================
echo.
echo   [1] List   [2] Create  [3] View
echo   [4] Download  [5] Edit  [6] Delete
echo.
echo   [0] Back
echo.
set "CH="
set /p "CH=  Select [0-6]: "
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
set /p "V=  Enter tag name - e.g. v1.0.0: "
if not "!V!"=="" call gh release create "!V!"
echo.
pause
goto :RELEASE_MENU
:REL_VIEW
echo.
set "V="
set /p "V=  Enter tag or Enter for latest: "
if "!V!"=="" ( call gh release view ) else ( call gh release view "!V!" )
echo.
pause
goto :RELEASE_MENU
:REL_DL
echo.
set "V="
set /p "V=  Enter tag to download: "
if not "!V!"=="" call gh release download "!V!"
echo.
pause
goto :RELEASE_MENU
:REL_EDIT
echo.
set "V="
set /p "V=  Enter tag to edit: "
if not "!V!"=="" call gh release edit "!V!"
echo.
pause
goto :RELEASE_MENU
:REL_DEL
echo.
set "V="
set /p "V=  Enter tag to delete: "
if not "!V!"=="" call gh release delete "!V!"
echo.
pause
goto :RELEASE_MENU

REM =============================================
:WORKFLOW_MENU
cls
echo.
echo ============================================
echo   Workflow / GitHub Actions
echo ============================================
echo.
echo   [1] List Runs     [6] List Workflows
echo   [2] View Run      [7] Run Workflow
echo   [3] Watch Run     [8] Download Artifacts
echo   [4] Rerun Failed  [9] View Log
echo   [5] Cancel Run
echo.
echo   [0] Back
echo.
set "CH="
set /p "CH=  Select [0-9]: "
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
set /p "V=  Enter run ID: "
if not "!V!"=="" call gh run view "!V!"
echo.
pause
goto :WORKFLOW_MENU
:WF_WATCH
echo.
set "V="
set /p "V=  Enter run ID to watch: "
if not "!V!"=="" call gh run watch "!V!"
echo.
pause
goto :WORKFLOW_MENU
:WF_RERUN
echo.
set "V="
set /p "V=  Enter run ID to rerun: "
if not "!V!"=="" call gh run rerun "!V!" --failed
echo.
pause
goto :WORKFLOW_MENU
:WF_CANCEL
echo.
set "V="
set /p "V=  Enter run ID to cancel: "
if not "!V!"=="" call gh run cancel "!V!"
echo.
pause
goto :WORKFLOW_MENU
:WF_RUN
echo.
set "V="
set /p "V=  Enter workflow name or filename: "
if not "!V!"=="" call gh workflow run "!V!"
echo.
pause
goto :WORKFLOW_MENU
:WF_DL
echo.
set "V="
set /p "V=  Enter run ID to download artifacts: "
if not "!V!"=="" call gh run download "!V!"
echo.
pause
goto :WORKFLOW_MENU
:WF_LOG
echo.
set "V="
set /p "V=  Enter run ID for log: "
if not "!V!"=="" call gh run view "!V!" --log
echo.
pause
goto :WORKFLOW_MENU

REM =============================================
:SSH_MENU
cls
echo.
echo ============================================
echo   SSH / GPG Key Management
echo ============================================
echo.
echo   [1] List SSH Keys   [4] List GPG Keys
echo   [2] Add SSH Key     [5] Add GPG Key
echo   [3] Delete SSH Key  [6] Delete GPG Key
echo.
echo   [0] Back
echo.
set "CH="
set /p "CH=  Select [0-6]: "
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
set /p "V=  Enter public key file path: "
if not "!V!"=="" call gh ssh-key add "!V!"
echo.
pause
goto :SSH_MENU
:SSH_DEL
echo.
set "V="
set /p "V=  Enter SSH key ID to delete: "
if not "!V!"=="" call gh ssh-key delete "!V!" --confirm
echo.
pause
goto :SSH_MENU
:GPG_ADD
echo.
set "V="
set /p "V=  Enter GPG key file: "
if not "!V!"=="" call gh gpg-key add "!V!"
echo.
pause
goto :SSH_MENU
:GPG_DEL
echo.
set "V="
set /p "V=  Enter GPG key ID to delete: "
if not "!V!"=="" call gh gpg-key delete "!V!" --confirm
echo.
pause
goto :SSH_MENU

REM =============================================
:EXT_MENU
cls
echo.
echo ============================================
echo   Extension Management
echo ============================================
echo.
echo   [1] List    [2] Install  [3] Upgrade
echo   [4] Upgrade All  [5] Remove
echo   [6] Create  [7] Browse
echo.
echo   [0] Back
echo.
set "CH="
set /p "CH=  Select [0-7]: "
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
set /p "V=  Enter extension - owner/gh-ext-name: "
if not "!V!"=="" call gh extension install "!V!"
echo.
pause
goto :EXT_MENU
:EXT_UPG
echo.
set "V="
set /p "V=  Enter extension name: "
if not "!V!"=="" call gh extension upgrade "!V!"
echo.
pause
goto :EXT_MENU
:EXT_RM
echo.
set "V="
set /p "V=  Enter extension to remove: "
if not "!V!"=="" call gh extension remove "!V!"
echo.
pause
goto :EXT_MENU

REM =============================================
:CONFIG_MENU
cls
echo.
echo ============================================
echo   Configuration / Alias
echo ============================================
echo.
echo   [1] List Config    [5] Set Alias
echo   [2] Get Config     [6] Delete Alias
echo   [3] Set Config     [7] Import Aliases
echo   [4] List Aliases
echo.
echo   [0] Back
echo.
set "CH="
set /p "CH=  Select [0-7]: "
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
set /p "V=  Config key - editor, git_protocol, browser, pager: "
if not "!V!"=="" call gh config get "!V!"
echo.
pause
goto :CONFIG_MENU
:CFG_SET
echo.
set "V="
set /p "V=  Config key: "
if not "!V!"=="" (
    set "V2="
    set /p "V2=  Value: "
    if not "!V2!"=="" call gh config set "!V!" "!V2!"
)
echo.
pause
goto :CONFIG_MENU
:ALIAS_SET
echo.
set "V="
set /p "V=  Alias name: "
if not "!V!"=="" (
    set "V2="
    set /p "V2=  Command - e.g. issue list --label=bug: "
    if not "!V2!"=="" call gh alias set "!V!" "!V2!"
)
echo.
pause
goto :CONFIG_MENU
:ALIAS_DEL
echo.
set "V="
set /p "V=  Alias name to delete: "
if not "!V!"=="" call gh alias delete "!V!"
echo.
pause
goto :CONFIG_MENU
:ALIAS_IMP
echo.
set "V="
set /p "V=  Enter alias file path: "
if not "!V!"=="" call gh alias import "!V!"
echo.
pause
goto :CONFIG_MENU

REM =============================================
:SEARCH_MENU
cls
echo.
echo ============================================
echo   Search GitHub
echo ============================================
echo.
echo   [1] Repos  [2] Issues  [3] PRs
echo   [4] Code   [5] Commits
echo.
echo   [0] Back
echo.
set "CH="
set /p "CH=  Select [0-5]: "
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
set /p "V=  Search query: "
if not "!V!"=="" call gh search repos "!V!"
echo.
pause
goto :SEARCH_MENU
:S_ISSUES
echo.
set "V="
set /p "V=  Search query: "
if not "!V!"=="" call gh search issues "!V!"
echo.
pause
goto :SEARCH_MENU
:S_PRS
echo.
set "V="
set /p "V=  Search query: "
if not "!V!"=="" call gh search prs "!V!"
echo.
pause
goto :SEARCH_MENU
:S_CODE
echo.
set "V="
set /p "V=  Search query: "
if not "!V!"=="" call gh search code "!V!"
echo.
pause
goto :SEARCH_MENU
:S_COMMITS
echo.
set "V="
set /p "V=  Search query: "
if not "!V!"=="" call gh search commits "!V!"
echo.
pause
goto :SEARCH_MENU

REM =============================================
:CODESPACE_MENU
cls
echo.
echo ============================================
echo   Codespace Operations
echo ============================================
echo.
echo   [1] List    [2] Create  [3] SSH
echo   [4] VS Code [5] Stop    [6] Delete
echo   [7] Logs
echo.
echo   [0] Back
echo.
set "CH="
set /p "CH=  Select [0-7]: "
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
echo   GitHub API Call
echo ============================================
echo   Example: /user , /repos/owner/repo
echo ============================================
echo.
echo   [1] GET Request
echo   [2] POST Request
echo   [3] View Authenticated User
echo   [4] View Rate Limit
echo   [5] GraphQL Query
echo.
echo   [0] Back
echo.
set "CH="
set /p "CH=  Select [0-5]: "
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
set /p "V=  Enter API path - e.g. /user: "
if not "!V!"=="" call gh api "!V!"
echo.
pause
goto :API_MENU
:API_POST
echo.
set "V="
set /p "V=  Enter API path: "
if not "!V!"=="" call gh api "!V!" --method POST
echo.
pause
goto :API_MENU
:API_GQL
echo.
set "V="
set /p "V=  Enter GraphQL query: "
if not "!V!"=="" call gh api graphql -f query="!V!"
echo.
pause
goto :API_MENU

REM =============================================
:VERSION_MENU
cls
echo.
echo ============================================
echo   Version Check and Update
echo ============================================
echo.
echo   --- Installed Version ---
for /f "tokens=*" %%i in ('gh --version 2^>nul') do echo   %%i
echo.
where winget >nul 2>&1
if not errorlevel 1 (
    echo   --- winget package info ---
    call winget list --id GitHub.cli --source winget 2>nul
    echo.
)
echo ============================================
echo.
echo   [1] Update via winget
echo   [2] Update via scoop
echo   [3] Detailed version info
echo.
echo   [0] Back
echo.
set "CH="
set /p "CH=  Select [0-3]: "
if "!CH!"=="1" goto :VER_WINGET
if "!CH!"=="2" goto :VER_SCOOP
if "!CH!"=="3" goto :VER_DETAIL
if "!CH!"=="0" goto :MAIN_MENU
goto :VERSION_MENU
:VER_WINGET
echo.
echo   --- Before Update ---
for /f "tokens=*" %%i in ('gh --version 2^>nul') do echo   %%i
echo.
call winget upgrade --id GitHub.cli --source winget --accept-source-agreements --accept-package-agreements
echo.
echo   --- After Update ---
for /f "tokens=*" %%i in ('gh --version 2^>nul') do echo   %%i
echo.
echo   [INFO] Restart terminal if version unchanged.
echo.
pause
goto :VERSION_MENU
:VER_SCOOP
echo.
echo   --- Before Update ---
for /f "tokens=*" %%i in ('gh --version 2^>nul') do echo   %%i
echo.
call scoop update gh
echo.
echo   --- After Update ---
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
echo   Direct Command Input
echo ============================================
echo   Enter any gh command without "gh" prefix
echo   Example: repo list --limit 10
echo   Type "back" to return to main menu.
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

:EXIT_APP
echo.
echo   Goodbye!
echo.
endlocal
exit /b 0
