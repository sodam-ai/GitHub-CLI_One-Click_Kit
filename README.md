# GitHub CLI 원클릭 키트

> Windows에서 GitHub CLI(gh)를 클릭 한 번으로 설치하고, 메뉴 방식으로 쉽게 사용할 수 있는 배치 스크립트 모음입니다.

**[English guide → README.en.md](./README.en.md)**

---

## 이게 뭔가요? (완전 초보자용 설명)

GitHub CLI는 GitHub(코드 저장소 서비스)를 **터미널(검은 창)**에서 명령어로 조작하는 도구입니다.  
이 키트는 그 도구를 **더블클릭만으로 설치하고 사용**할 수 있도록 만든 편의 모음입니다.

- 코딩을 몰라도 됩니다.
- 복잡한 명령어를 외울 필요가 없습니다.
- Windows에서 `.bat` 파일을 더블클릭하면 메뉴가 나옵니다.

---

## 주요 기능

| 파일 | 역할 |
|------|------|
| `INSTALL.bat` | GitHub CLI 자동 설치 (winget 또는 scoop 사용) |
| `RUN.bat` | GitHub CLI 컨트롤 패널 — 메뉴에서 번호를 선택해 모든 기능 사용 |
| `UNINSTALL.bat` | GitHub CLI 안전 제거 (설정 백업 옵션 포함) |

### RUN.bat 메뉴 구성

```
[1]  인증 관리          [9]  확장 기능 관리
[2]  저장소 작업        [10] 설정 / 별칭
[3]  Pull Request       [11] GitHub 검색
[4]  이슈 관리          [12] Codespace 작업
[5]  Gist 작업          [13] API 직접 호출
[6]  릴리즈 관리        [14] 버전 확인 및 업데이트
[7]  Workflow / Actions [15] 직접 명령어 입력
[8]  SSH / GPG 키 관리
[0]  종료
```

---

## 설치 방법

### 1단계 — 파일 다운로드

[Releases](../../releases) 페이지에서 `GitHub-CLI_One-Click_Kit.7z` 파일을 다운로드합니다.  
또는 이 저장소를 통째로 내려받아도 됩니다.

### 2단계 — 압축 해제

`GitHub-CLI_One-Click_Kit.7z` 파일을 원하는 폴더에 압축 해제합니다.  
(7-Zip이 필요합니다 → https://www.7-zip.org)

### 3단계 — 설치 실행

`INSTALL.bat` 파일을 **더블클릭**합니다.  
화면 안내에 따라 진행하면 자동으로 설치됩니다.

> **참고**: Windows 10 22H2 이상이면 winget이 기본 내장되어 있습니다.  
> winget 또는 Scoop 중 하나가 있으면 자동 감지합니다.

---

## 사용 방법

`RUN.bat` 파일을 **더블클릭**합니다.

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

번호를 입력하고 Enter를 누르면 해당 기능이 실행됩니다.

### 첫 사용 시 — 로그인 필수

1. `RUN.bat` 실행 → `[1] Auth Management` 선택
2. `[1] Login - Browser` 선택
3. 브라우저가 열리면 GitHub 계정으로 로그인

---

## 제거 방법

`UNINSTALL.bat` 파일을 **더블클릭**합니다.

- 제거 전 설정 백업 여부를 선택할 수 있습니다.
- `YES` 입력 후 Enter를 누르면 완전 제거됩니다.

---

## 폴더 구조

```
GitHub-CLI/
├── INSTALL.bat                    # GitHub CLI 설치 스크립트
├── RUN.bat                        # 컨트롤 패널 (메인 사용 파일)
├── UNINSTALL.bat                  # 제거 스크립트
├── GitHub-CLI_One-Click_Kit.7z    # 배포용 압축 파일
├── README.md                      # 한국어 문서 (현재 파일)
├── README.en.md                   # 영어 문서
├── LICENSE                        # 라이선스
└── .gitignore                     # git 무시 규칙
```

---

## 운영 시 주의사항

| 항목 | 내용 |
|------|------|
| **토큰 보안** | `RUN.bat → [1] Auth → [6] View Token` 은 토큰을 화면에 출력합니다. 공용 PC에서 사용 금지. |
| **저장소 삭제** | `[2] Repository → [7] Delete Repository` 는 복구 불가 작업입니다. 신중하게 사용하세요. |
| **관리자 권한** | 설치 실패 시 `INSTALL.bat`을 마우스 우클릭 → "관리자 권한으로 실행"을 시도하세요. |
| **PATH 업데이트** | 설치 후 터미널(또는 PC)을 재시작해야 `gh` 명령어가 인식될 수 있습니다. |

---

## 시스템 요구 사항

- **OS**: Windows 10 (22H2 이상 권장) 또는 Windows 11
- **패키지 관리자**: winget (Windows 기본 내장) 또는 [Scoop](https://scoop.sh)
- **인터넷 연결**: 설치 시 필요

---

## 환경 변수 / 설정

이 키트는 별도의 환경 변수 설정이 필요하지 않습니다.  
GitHub 인증은 `RUN.bat → [1] Auth Management`에서 직접 진행합니다.

---

## 라이선스

MIT License — © 2025 SoDam AI Studio  
자세한 내용은 [LICENSE](./LICENSE) 파일을 참고하세요.

---

## 만든 곳

**SoDam AI Studio**  
AI 도구와 유틸리티를 누구나 쉽게 사용할 수 있도록 만들고 있습니다.
