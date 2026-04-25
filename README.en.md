# GitHub CLI One-Click Kit

> A batch script toolkit for Windows that lets you install and use GitHub CLI (gh) with a single click and a simple menu interface.

**[한국어 가이드 → README.md](./README.md)**

---

## What is this? (Beginner-friendly explanation)

GitHub CLI is a tool that lets you control GitHub (a code repository service) from the **terminal (the black window)** using commands.  
This kit makes that tool accessible by **double-clicking** — no commands to memorize.

- No coding knowledge required.
- No complex commands to remember.
- Double-click a `.bat` file on Windows and a menu appears.

---

## Key Features

| File | Role |
|------|------|
| `INSTALL.bat` | Automatically installs GitHub CLI (uses winget or scoop) |
| `RUN.bat` | GitHub CLI Control Panel — select a number from the menu to use any feature |
| `UNINSTALL.bat` | Safely removes GitHub CLI (includes optional config backup) |

### RUN.bat Menu Overview

```
[1]  Auth Management       [9]  Extension Management
[2]  Repository Operations [10] Configuration / Alias
[3]  Pull Request          [11] Search GitHub
[4]  Issue Operations      [12] Codespace Operations
[5]  Gist Operations       [13] API Call
[6]  Release Operations    [14] Version Check and Update
[7]  Workflow / Actions    [15] Direct Command Input
[8]  SSH / GPG Key Mgmt
[0]  Exit
```

---

## Installation

### Step 1 — Download

Go to the [Releases](../../releases) page and download `GitHub-CLI_One-Click_Kit.7z`.  
Or clone / download this repository directly.

### Step 2 — Extract

Extract `GitHub-CLI_One-Click_Kit.7z` to any folder.  
(Requires 7-Zip → https://www.7-zip.org)

### Step 3 — Install

**Double-click** `INSTALL.bat` and follow the on-screen instructions.

> **Note**: winget is built into Windows 10 22H2+ and Windows 11.  
> The installer auto-detects winget or Scoop.

---

## Usage

**Double-click** `RUN.bat`.

```
GitHub CLI - Control Panel
============================================
  gh version 2.x.x
  Auth: Logged in
============================================

   [1] Auth Management
   [2] Repository Operations
   ...
   [0] Exit

  Select [0-15]:
```

Type a number and press Enter to run that feature.

### First Time — Login Required

1. Run `RUN.bat` → select `[1] Auth Management`
2. Select `[1] Login - Browser`
3. A browser window opens — log in with your GitHub account

---

## Uninstallation

**Double-click** `UNINSTALL.bat`.

- You can choose to back up your config before removal.
- Type `YES` and press Enter to confirm complete removal.

---

## Folder Structure

```
GitHub-CLI/
├── INSTALL.bat                    # GitHub CLI installer script
├── RUN.bat                        # Control panel (main file)
├── UNINSTALL.bat                  # Uninstaller script
├── GitHub-CLI_One-Click_Kit.7z    # Distribution archive
├── README.md                      # Korean documentation
├── README.en.md                   # English documentation (this file)
├── LICENSE                        # License
└── .gitignore                     # git ignore rules
```

---

## Important Notes

| Item | Details |
|------|---------|
| **Token security** | `RUN.bat → [1] Auth → [6] View Token` prints your token to the screen. Never use on a shared PC. |
| **Repository deletion** | `[2] Repository → [7] Delete Repository` is irreversible. Use with caution. |
| **Admin privileges** | If installation fails, right-click `INSTALL.bat` → "Run as administrator". |
| **PATH update** | After installation, restart your terminal (or PC) if `gh` is not recognized. |

---

## System Requirements

- **OS**: Windows 10 (22H2+ recommended) or Windows 11
- **Package manager**: winget (built into Windows) or [Scoop](https://scoop.sh)
- **Internet connection**: Required for installation

---

## Environment Variables / Configuration

No environment variables are required.  
GitHub authentication is handled directly via `RUN.bat → [1] Auth Management`.

---

## License

MIT License — © 2025 SoDam AI Studio  
See the [LICENSE](./LICENSE) file for details.

---

## Created by

**SoDam AI Studio**  
Building AI tools and utilities that anyone can use.
