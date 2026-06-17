# GitHub CLI One-Click Kit

**Install GitHub with a few clicks, and use it through a Korean/English menu.**
You don't need to memorize any commands — just pick a number from the menu.

> This kit is an **UNOFFICIAL helper**. It is NOT affiliated with, sponsored by, or endorsed by GitHub, Inc.
> See [10. License](#10-license--copyright--trademarks--commercial-use) below.
>
> Korean docs: [README.md](README.md) · Detailed guide: [GUIDE.en.md](GUIDE.en.md) ([한국어](GUIDE.md))

---

## Table of contents

1. [What is this kit](#1-what-is-this-kit)
2. [Prerequisites / required software](#2-prerequisites--required-software)
3. [How to download](#3-how-to-download)
4. [Quick start — just 3 steps](#4-quick-start--just-3-steps)
5. [File locations / document locations](#5-file-locations--document-locations)
6. [What you can do (feature summary)](#6-what-you-can-do-feature-summary)
7. [Safety notes](#7-safety-notes)
8. [When something goes wrong](#8-when-something-goes-wrong)
9. [How to uninstall](#9-how-to-uninstall)
10. [License · copyright · trademarks · commercial use](#10-license--copyright--trademarks--commercial-use)
11. [Disclaimer (no warranty)](#11-disclaimer-no-warranty)

---

## 1. What is this kit

**GitHub CLI** (`gh`) is the **official program made by GitHub** that lets you work with
GitHub from your computer using commands instead of the website. Normally you have to type
English commands yourself.

This kit is a set of **3 batch files (.bat)** that **install `gh` for you** and let you use
it through a **simple menu**.

| File | What it does |
|---|---|
| `INSTALL.bat` | Installs GitHub CLI automatically (upgrades it if already present). |
| `RUN.bat` | Opens the menu control panel (login, repos, issues, search, and more). |
| `UNINSTALL.bat` | Safely removes GitHub CLI (can back up your settings first). |

> **Important:** This kit does **NOT bundle** `gh`. When installing, it fetches `gh`
> **directly from official sources** (winget, Scoop, or the official GitHub download page).

---

## 2. Prerequisites / required software

Before installing, make sure you have:

- **Operating system:** Windows 10 (22H2 or later) or Windows 11
- **Internet connection:** needed for installing, signing in, and most features.
- **GitHub account:** if you don't have one, sign up for free at https://github.com
- **An install tool (one of these — optional):**
  - **winget** — **built into** Windows 10 22H2+ and Windows 11.
  - **Scoop** — optional. https://scoop.sh
  - You don't need either. The kit can **download the official installer (.msi) directly**.

> There is nothing to install in advance. `INSTALL.bat` handles everything.

---

## 3. How to download

1. Get the folder (or ZIP file) that contains this kit.
2. **If you received a ZIP**, right-click it → **Extract All** first.
   (Running directly from inside a ZIP may not work.)
3. Once you see `INSTALL.bat`, `RUN.bat`, and `UNINSTALL.bat` in the extracted folder, you're ready.

> If a **"Windows protected your PC" (SmartScreen)** dialog appears → click **More info → Run anyway**.
> This is a normal one-time prompt for files downloaded from the internet.

---

## 4. Quick start — just 3 steps

1. Double-click **`INSTALL.bat`** → GitHub CLI gets installed.
   (When it finishes, it asks "Start now?" — press **Y** to continue.)
2. Double-click **`RUN.bat`** → the menu window opens.
3. In the menu, choose **`[17] Easy Start`** → it guides you through **login to repository in 1-2-3 steps**.

> **How login works:** an **8-digit code** appears on screen. Copy it, paste it into the
> browser that opens automatically, and click **Authorize**. Done.

If you prefer to do it manually, choose `[1] Login` → `[1] Login - Browser` in the menu.

---

## 5. File locations / document locations

All files of this kit live **in one folder** (wherever you placed it).

**Executables**
- `INSTALL.bat` — install
- `RUN.bat` — use (menu control panel)
- `UNINSTALL.bat` — uninstall

**Documents**
- `README.md` (Korean) / `README.en.md` (this document, English)
- `GUIDE.md` (detailed, Korean) / `GUIDE.en.md` (English)
- Same content as PDF: `README.pdf`, `README.en.pdf`, `GUIDE.pdf`, `GUIDE.en.pdf`
- `사용법-먼저읽기.txt` — shortest start guide (plain text, Korean)

**License / notices**
- `LICENSE` — full Apache License 2.0 text
- `NOTICE` — copyright, trademark, and non-affiliation notice

**Files that may be created automatically**
- `gh-help-log.txt` — created if you choose "save result" in `[16] Troubleshoot`.

---

## 6. What you can do (feature summary)

When you open `RUN.bat`, you'll see these **17 menus** (each has more options inside;
see [GUIDE.en.md](GUIDE.en.md) for details).

| No. | Menu | What it does |
|---|---|---|
| 1 | Login | Sign in/out of your GitHub account, check status, switch accounts |
| 2 | Repository | Create, clone, list, delete, fork, archive code repositories |
| 3 | Pull Request | Create, view, merge, review code-change proposals (PRs) |
| 4 | Issue | Create and manage issues (tasks/bugs), comments, labels |
| 5 | Gist | Quickly share code snippets / notes |
| 6 | Release | Create release versions, upload/download files |
| 7 | Workflow/Actions | View, re-run, and inspect logs of automation runs |
| 8 | SSH/GPG keys | Manage keys for secure access and signing |
| 9 | Extensions | Install and manage gh extensions |
| 10 | Config/Alias | Settings and shortcuts for frequent commands |
| 11 | Search | Search repositories, issues, code, and more |
| 12 | Codespace | Cloud development environments |
| 13 | API call | Call the GitHub API directly (advanced) |
| 14 | Version/Update | Check and update the gh version |
| 15 | Direct command | Type gh commands directly (advanced) |
| 16 | **Troubleshoot** | Not working? Auto-checks internet/install/login + gives fixes |
| 17 | **Easy Start** | New here? Guided 1-2-3 steps (recommended) |

---

## 7. Safety notes

- **Irreversible actions** (delete/remove) require you to type **`YES`** on screen before
  they proceed. (A safeguard so nothing is deleted by accident.)
- When uninstalling (`UNINSTALL.bat`), it asks whether to **back up your settings first**.
- This kit does **not store your password or personal data**. Login uses GitHub's official
  process (`gh`) directly, and **everything runs on your own computer**.

---

## 8. When something goes wrong

- **If anything doesn't work** → open `RUN.bat` and choose **`[16] Troubleshoot`**.
  It **auto-checks** internet/install/login status and tells you how to fix it.
- **"gh not found"** → **restart** the terminal window or your PC.
  (Right after install, it takes a moment for the path to update.)
- **If install fails** → right-click `INSTALL.bat` → **Run as administrator**.
  (`INSTALL.bat` also asks for this automatically when it lacks privileges.)
- **If it looks like a network error** → check your Wi-Fi/cable. On a corporate network it may be a firewall.

For a more detailed table, see ["Troubleshooting" in GUIDE.en.md](GUIDE.en.md).

---

## 9. How to uninstall

1. Double-click **`UNINSTALL.bat`**.
2. It asks whether to **back up** your settings (type `y` if you want to).
3. Type **`YES`** to confirm → it logs out → removes gh → cleans up settings/cache.

> The kit folder itself (.bat files and docs) stays. If you no longer need it, move the folder to the Recycle Bin.

---

## 10. License · copyright · trademarks · commercial use

- **License:** This kit is distributed under the **Apache License 2.0**. The full text is in [`LICENSE`](LICENSE).
- **Copyright:** Copyright 2026 SoDam AI Studio.
- **Commercial use:** Apache-2.0 **permits commercial use**, provided you:
  - include a copy of `LICENSE` and keep the copyright/notices when you distribute it;
  - state that you changed the files if you distribute a modified version;
  - keep the contents of the `NOTICE` file.
- **Trademarks:** "GitHub" and "GitHub CLI" are trademarks of GitHub, Inc. "Windows" is a
  trademark of Microsoft. This kit uses these names **for description only**; the license
  grants no trademark rights.
- **No affiliation:** This kit is **unofficial** and has no affiliation, sponsorship, or
  endorsement from GitHub, Inc.
- **No bundled third-party software:** This kit does not bundle or redistribute `gh`. `gh`
  is a separate product distributed by GitHub, Inc. under the **MIT License**
  (https://github.com/cli/cli).

---

## 11. Disclaimer (no warranty)

- This kit is provided **"AS IS"**, **without warranty** of any kind.
- The author is **not liable for any damages** arising from the use of this kit.
  You use it **at your own risk**.
- See Sections 7 and 8 of [`LICENSE`](LICENSE) for the full warranty disclaimer and limitation of liability.
- **Developer note:** the `.bat` files are saved as **UTF-8 (no BOM)** and rely on the
  first line `chcp 65001` to display Korean correctly. **If you re-save them as ANSI/CP949
  (e.g., in Notepad), the Korean text will break.** Always save as **UTF-8** when editing.
