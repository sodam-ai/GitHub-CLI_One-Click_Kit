# GitHub CLI One-Click Kit — Detailed Guide (GUIDE)

This document explains **every step from install to removal in detail**, so that even people
**new to computers and IT tools** can follow along. For a short version, see [README.en.md](README.en.md).

> This kit is an **UNOFFICIAL helper**. It has no affiliation, sponsorship, or endorsement from GitHub, Inc.
> 한국어 버전: [GUIDE.md](GUIDE.md)

---

## Table of contents

1. [Before you begin](#1-before-you-begin)
2. [Prerequisites / required software](#2-prerequisites--required-software)
3. [How to download](#3-how-to-download)
4. [How to install (in detail)](#4-how-to-install-in-detail)
5. [How to run](#5-how-to-run)
6. [Quick start — the Easy Start wizard](#6-quick-start--the-easy-start-wizard)
7. [How to sign in](#7-how-to-sign-in)
8. [How to use — menu-by-menu](#8-how-to-use--menu-by-menu)
9. [Workflows (common flows)](#9-workflows-common-flows)
10. [Command reference (menu → actual gh command)](#10-command-reference-menu--actual-gh-command)
11. [How to uninstall](#11-how-to-uninstall)
12. [Troubleshooting](#12-troubleshooting)
13. [File locations / document locations](#13-file-locations--document-locations)
14. [FAQ](#14-faq)
15. [Developer notes](#15-developer-notes)
16. [License · copyright · trademarks · commercial use](#16-license--copyright--trademarks--commercial-use)
17. [Disclaimer (no warranty)](#17-disclaimer-no-warranty)

---

## 1. Before you begin

**GitHub** is a place to store code (program files) online and work together with others.
**GitHub CLI** (`gh`) is the **official program by GitHub** that lets you use GitHub from
your computer with **commands** instead of the website.

The catch is that using `gh` normally means **memorizing and typing English commands**.
This kit replaces that with a **menu** so you only need to **pick a number**.

The kit consists of **3 executable files**.

| File | Role | When to use |
|---|---|---|
| `INSTALL.bat` | Install | Once, at the very start |
| `RUN.bat` | Use | Every time you use GitHub |
| `UNINSTALL.bat` | Remove | When you no longer need it |

---

## 2. Prerequisites / required software

| Item | Details | Required? |
|---|---|---|
| OS | Windows 10 (22H2+) or Windows 11 | Yes |
| Internet | Needed for install, login, most features | Yes |
| GitHub account | Free signup at https://github.com | Yes |
| winget | Install tool built into Windows 10 22H2+/11 | Any one of the three |
| Scoop | Optional install tool (https://scoop.sh) | Any one of the three |
| (neither) | Kit downloads the official `.msi` directly | Any one of the three |

> **In short:** there is **nothing to install in advance.** With Windows, internet, and a
> GitHub account, `INSTALL.bat` does the rest.

**To check whether winget exists (optional):** open `cmd` from the Start menu and type
`winget --version`. If a version number appears, you have it. If not, the kit handles it
anyway, so don't worry.

---

## 3. How to download

1. Get the **folder or ZIP file** containing this kit.
2. **If you received a ZIP, be sure to extract it.**
   - Right-click the ZIP → **Extract All**.
   - Running directly from inside a ZIP may break some features.
3. When you see these three files in the extracted folder, you're ready:
   - `INSTALL.bat` · `RUN.bat` · `UNINSTALL.bat`

> **Tip — Unblock:** Windows may mark a ZIP downloaded from the internet as "blocked."
> Right-click the ZIP → **Properties** → check **[Unblock] → OK** before extracting to
> reduce SmartScreen prompts. (Optional.)

---

## 4. How to install (in detail)

### 4.1 The basics — just do this

1. **Double-click** `INSTALL.bat`.
2. A black window opens and proceeds automatically. Just follow the on-screen prompts.
3. At the end, when **"Start now? [Y/n]"** appears, press **Y**. `RUN.bat` opens automatically.

> If a **"Windows protected your PC" (SmartScreen)** dialog appears → click **More info → Run anyway**.

### 4.2 What happens during install (5 stages)

`INSTALL.bat` runs in this order, with each stage shown on screen.

| Stage | What it does |
|---|---|
| Already-installed check | If gh exists, asks "Upgrade?" |
| Admin check | If not elevated, offers [1] restart as admin / [2] continue anyway |
| Internet check | If offline, only warns (does not block) and lets you continue |
| [2/5] Install-tool check | Looks for winget or Scoop |
| [3/5] Install | Installs via winget/Scoop, or downloads the official `.msi` if neither exists |
| [4/5] Refresh PATH | Updates PATH so gh is found in the current window |
| [5/5] Verify | Prints the gh version to confirm |

### 4.3 When administrator privileges are needed

Installing GitHub CLI usually needs **administrator privileges** to finish. If you don't
have them, `INSTALL.bat` asks:

- **[1] Restart as administrator (recommended)** — a Windows **UAC dialog** appears.
  Click **Yes** to re-run with privileges.
- **[2] Continue anyway** — proceeds without privileges. (If it fails, try [1].)

> If you chose [1] but nothing happened, you may have clicked "No" on the UAC dialog.
> Double-click `INSTALL.bat` again and choose [1], or right-click the file →
> **Run as administrator**.

### 4.4 A SmartScreen warning appeared

A `.bat` downloaded from the internet may trigger a protection dialog on first run. This is
**not** a danger signal — it's a **general notice for files of unverified origin**.

→ Click **More info**, then click **Run anyway**.

### 4.5 When neither winget nor Scoop exists (automatic download)

If no install tool is present, `INSTALL.bat` asks: **"Download and install automatically? [Y/n]"**

- Press **Y** → it downloads the **official installer (.msi)** matching your computer type
  (amd64/arm64) from GitHub's official server and installs it.
- If the automatic download fails → the official download page opens in your browser. There,
  download the file whose name contains `windows_amd64.msi` and **double-click** it.
  (Official page: https://github.com/cli/cli/releases/latest )

### 4.6 Confirming the install worked

When done, you'll see a line like `gh version 2.x.x ...` and **"Install confirmed [OK]"**.
If you see **"gh not found in the current window"**, restart the terminal window or your PC
to apply it.

---

## 5. How to run

1. **Double-click** `RUN.bat`.
2. The top shows the current gh version and **login status**, with **17 menus** below.
3. Type the **number** of the feature you want and press **Enter**.
4. After each action, "Press any key" appears. Press a key to return to the menu.
5. To quit, press **`0`**.

> If you enter an invalid number (e.g., 99), you'll see **"Please enter a number from 0 to 17."**

---

## 6. Quick start — the Easy Start wizard

If you're new, you don't need all 16 menus — just **`[17] Easy Start`**.

1. **[Step 1] Login check** — if you're not signed in, it asks to do so now (browser login).
2. **[Step 2] What do you want to do?** — choose one of three:
   - `[1] Get someone's code onto my PC` (clone)
   - `[2] Create a new repository`
   - `[3] Just look around for now`
3. **Done!** From then on, use the main menu for more features.

---

## 7. How to sign in

Most features **require login**. Do it under menu `[1] Login`.

**Easiest — browser login (`[1] Login` → `[1] Login - Browser`)**

1. An **8-digit code** (e.g., `ABCD-1234`) appears on screen.
2. **Copy** it (or write it down).
3. Paste it into the **browser that opens automatically** (or the address shown).
4. Click **Authorize**. Login is complete.
5. Back in the menu, the status at the top changes to **"Logged in."**

**Other login methods**

- `[2] Login - Token`: log in with a token string created on GitHub.
  (Create a token: https://github.com/settings/tokens )
- `[3] Login - Enterprise`: enter your company GitHub server (host) to log in.
- `[4] Check status` / `[5] Logout` / `[6] View token` / `[7] Refresh token` / `[8] Switch account`

---

## 8. How to use — menu-by-menu

Each menu shows sub-items when selected. Items that need input will prompt you.

### [1] Login
Sign in/out, check status, view/refresh token, switch accounts. (See [7. How to sign in].)

### [2] Repository
Create, clone, and manage code repositories.
- Clone, create, list my repos, view info, fork, rename, **delete (permanent, `YES` confirm)**,
  open in browser, my activity, archive.
- For clone/fork/rename, enter `owner/repo` (e.g., `cli/cli`) or a URL.

### [3] Pull Request
A proposal that says "let's change the code like this."
- List, create, view, checkout, **merge**, close, reopen, diff, status, mark ready, review,
  checks. Most ask for a **PR number**.

### [4] Issue
Record tasks, bugs, and questions.
- List, create, view, close, reopen, edit, comment, status, pin, transfer, labels
  (list/create/**delete `YES`**). Most ask for an **issue number**.

### [5] Gist
Quickly share code snippets or notes.
- My list, create (private/public), view, edit, **delete (`YES`)**, clone.

### [6] Release
Create distributable versions.
- List, create (enter tag, e.g. `v1.0.0`), view, download, edit, **delete (`YES`)**.

### [7] Workflow / Actions
View GitHub automation runs.
- Run list/view/watch/re-run failed/cancel, workflow list/run, download artifacts, view logs.

### [8] SSH / GPG keys
Manage keys for secure access (SSH) and signing (GPG).
- For each: list/add/**delete (`YES`, irreversible)**.

### [9] Extensions
Add-on programs that extend gh.
- List, install, upgrade, upgrade all, remove, create, browse.

### [10] Config / Alias
Settings and shortcuts for frequent commands.
- Config list/view/set (e.g., `editor`, `git_protocol`, `browser`, `pager`).
- Alias list/create/delete/import.

### [11] GitHub Search
- Search repositories / issues / PRs / code / commits. Enter a search term.

### [12] Codespace
Cloud development environments online.
- List, create, SSH, open in VS Code, stop, delete, logs.

### [13] API call (advanced)
Call the GitHub API directly (for developers).
- GET / POST requests, view your info (`/user`), rate limit (`/rate_limit`), GraphQL query.

### [14] Version / Update
- Check the installed gh version, update via winget/Scoop, detailed version info.

### [15] Direct command (advanced)
- Type any command after `gh`. Example: `repo list --limit 10`.
- Type `back` to return to the main menu.

### [16] Troubleshoot
- Auto-checks internet/gh-install/login/current-folder and explains problems **and fixes in Korean**.
- Can save the result to `gh-help-log.txt` (useful when asking for help).

### [17] Easy Start
- Guided 1-2-3 steps for new users. (See [6. Quick start].)

---

## 9. Workflows (common flows)

**A. Total beginner — from install to your first repo**
1. Double-click `INSTALL.bat` → install → press **Y** at the end (start now)
2. In `RUN.bat`, choose `[17] Easy Start`
3. Log in → `[2] Create a new repository` → follow the prompts

**B. Get someone's project**
1. `RUN.bat` → `[2] Repository` → `[1] Clone`
2. Enter `owner/repo` or URL → download to your PC

**C. Track tasks/bugs with issues**
1. `[4] Issue` → `[2] Create issue` → follow prompts for title/body

**D. Handle pull requests (PRs)**
1. `[3] Pull Request` → `[1] List` → `[3] View` (number) → `[5] Merge` if needed

**E. When something doesn't work**
1. `[16] Troubleshoot` for auto-check → follow the Korean guidance

---

## 10. Command reference (menu → actual gh command)

Selecting a menu runs the `gh` command below. (You can also type these in `[15] Direct command`.)

| Menu | Action | Actual command |
|---|---|---|
| Login | Browser login | `gh auth login --web` |
| Login | Status / logout | `gh auth status` / `gh auth logout` |
| Repository | Clone / create | `gh repo clone <owner/repo>` / `gh repo create` |
| Repository | List / view | `gh repo list --limit 30` / `gh repo view` |
| Repository | Fork / archive / delete | `gh repo fork` / `gh repo archive` / `gh repo delete --yes` |
| PR | List / create / view | `gh pr list` / `gh pr create` / `gh pr view <num>` |
| PR | Merge / checkout / diff | `gh pr merge <num>` / `gh pr checkout <num>` / `gh pr diff <num>` |
| Issue | List / create / view | `gh issue list` / `gh issue create` / `gh issue view <num>` |
| Issue | Comment / labels | `gh issue comment <num> --body "..."` / `gh label list` |
| Gist | Create (public) / list | `gh gist create <file> --public` / `gh gist list` |
| Release | Create / list | `gh release create <tag>` / `gh release list` |
| Workflow | Run list / logs | `gh run list` / `gh run view <ID> --log` |
| SSH/GPG | List / add | `gh ssh-key list` / `gh ssh-key add <file>` |
| Extensions | List / install | `gh extension list` / `gh extension install <owner/name>` |
| Config | List / set | `gh config list` / `gh config set <key> <value>` |
| Search | Repos / code | `gh search repos "<term>"` / `gh search code "<term>"` |
| Codespace | List / create | `gh codespace list` / `gh codespace create` |
| API | Your info / call | `gh api /user` / `gh api <path>` |
| Version | Check | `gh --version` |

> For all commands, type `help` in `[15] Direct command`, or see the official manual
> (https://cli.github.com/manual).

---

## 11. How to uninstall

1. **Double-click** `UNINSTALL.bat`.
2. If gh settings exist, it asks **"Back up settings? [y/N]"**.
   - Press `y` to back up into a `gh-config-backup` folder inside the kit folder.
3. A **warning** appears and it asks **"Type YES to remove."**
   - It proceeds only if you type `YES` (uppercase).
4. In order: log out of GitHub → remove gh (winget/Scoop) → clean settings/cache → verify removal.

> After removal, the kit folder (.bat files and docs) remains. If you no longer need it, move
> the folder to the Recycle Bin. You may keep or delete the `gh-config-backup` folder.

---

## 12. Troubleshooting

**Try first:** `RUN.bat` → **`[16] Troubleshoot`** (auto-check + Korean guidance).

| Symptom | Likely cause | Fix |
|---|---|---|
| gh not found | PATH not updated right after install | Restart terminal/PC |
| Install fails | Lacking admin privileges | Right-click `INSTALL.bat` → Run as administrator |
| No winget/scoop | No install tool present | Use INSTALL's auto `.msi` (Y), or download from the official page |
| English error appears | Internet down / firewall | Check Wi-Fi/cable; on a corporate network check the firewall |
| Korean text is garbled | File saved as ANSI/CP949 | Use the original file (keep UTF-8 when editing) |
| SmartScreen warning | File from the internet | More info → Run anyway |
| Login won't finish | Code not pasted / browser didn't open | Paste the 8-digit code in the browser and Authorize |
| Most features blocked | Not logged in | Log in via `[1] Login` |

**When asking for help:** in `[16] Troubleshoot`, save the result to `gh-help-log.txt` and
share it — it makes diagnosis faster.

---

## 13. File locations / document locations

All files of this kit live **in the same folder**.

```
(kit folder)
├─ INSTALL.bat            install
├─ RUN.bat                use (menu control panel, 17 menus)
├─ UNINSTALL.bat          uninstall
├─ README.md / README.en.md      short guide (KO / EN)
├─ GUIDE.md / GUIDE.en.md         detailed guide (KO / EN, this doc)
├─ README.pdf / README.en.pdf     same content as PDF
├─ GUIDE.pdf / GUIDE.en.pdf        same content as PDF
├─ 사용법-먼저읽기.txt    shortest start guide (plain text, KO)
├─ LICENSE                full Apache License 2.0
└─ NOTICE                 copyright / trademark / non-affiliation
```

Files that may be created: `gh-help-log.txt` (troubleshoot save), `gh-config-backup/` (uninstall backup).

---

## 14. FAQ

**Q. Is it free?**
A. The kit and GitHub CLI are free. A GitHub account is free by default too.

**Q. Do I really need the internet?**
A. Yes. Install, login, search, repository actions, and almost everything use the internet.

**Q. Is it safe? Could my password leak?**
A. Login uses GitHub's **official** process (`gh`); the kit does not store your password.
Everything runs **on your own computer**.

**Q. I'm worried I'll delete a repository by accident.**
A. Dangerous actions like delete/remove require you to type **`YES`** to proceed.

**Q. Does it work on macOS / Linux?**
A. The `.bat` files in this kit are **Windows-only**.

---

## 15. Developer notes

- **Encoding:** the `.bat` files display Korean via **UTF-8 (no BOM)** + the first line
  `chcp 65001`. **Re-saving as ANSI/CP949 (e.g., in Notepad) breaks all Korean.** Always
  save as **UTF-8** when editing.
- **Structure:** the menus are standard batch scripts built from labels (`:MENU`) and `goto`.
- **Install fallback:** it tries winget → Scoop → official `.msi` (PowerShell download), in order.
- **Privileges:** `INSTALL.bat` checks admin via `net session` and offers UAC elevation when needed.

---

## 16. License · copyright · trademarks · commercial use

- **License:** **Apache License 2.0** (full text = [`LICENSE`](LICENSE)).
- **Copyright:** Copyright 2026 SoDam AI Studio.
- **Commercial use:** **Permitted.** When redistributing, you must ① include a copy of
  `LICENSE`, ② state changes if modified, and ③ keep the `NOTICE` notices.
- **Trademarks:** "GitHub" and "GitHub CLI" are trademarks of GitHub, Inc.; "Windows" is a
  trademark of Microsoft. Used for description only; the license grants no trademark rights.
- **No affiliation:** an unofficial helper with no affiliation/sponsorship/endorsement from GitHub, Inc.
- **Third-party software:** `gh` is not bundled; it is a separate product by GitHub, Inc.
  under the **MIT License** (https://github.com/cli/cli).

---

## 17. Disclaimer (no warranty)

- This kit is provided **"AS IS"** with **no warranty** of any kind.
- The author is **not liable for any damages** from its use. You use it **at your own risk**.
- See Sections 7 (warranty disclaimer) and 8 (limitation of liability) of [`LICENSE`](LICENSE).
