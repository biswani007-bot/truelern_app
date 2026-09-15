# 20 — Flutter Build Environment & Host Storage Configuration

> [!IMPORTANT]
> **BUILD CACHE SAFETY CONFIGURATION APPLIED & VERIFIED**:
> Build cache redirections have been applied to protect the host environment from `C:\` disk exhaustion.
> - **System Drive (`C:\`)**: **`0.32 GB (321 MB) Free`** — CRITICAL host baseline.
> - **Data Drive (`D:\`)**: **`138.50 GB Free`** — Primary safe destination for all build artifacts and package caches.
> - **Action Status**: `[APPLIED & EMPIRICALLY VERIFIED]`.
> - **Old C:\ Caches**: **`[STRICTLY PRESERVED]`** — `C:\Users\biswa\.gradle` (3.52 GB) and `C:\Users\biswa\AppData\Local\Pub\Cache` (225 MB) remain completely untouched.
> - **Project Scope**: Parent Phase 1A (`d:\New folder\New folder\truelearn`). Zero application dependencies added; zero application code, architecture, or Parent screens implemented.

---

## 1. Storage Status & Drive Capacity

A physical drive probe performed on the Windows 11 host environment confirms:

| Drive | Total Used Space | Available Free Space | Status | Safety Assessment |
|---|---|---|:---:|---|
| **`C:\` (System)** | **238.97 GB** | **0.32 GB (~321 MB)** | **`CRITICAL`** | **Severely constrained**. Default writes to `C:\Users\biswa` would cause immediate disk exhaustion (`IOException: Disk Full`). |
| **`D:\` (Data)** | **96.67 GB** | **138.50 GB** | **`HEALTHY`** | **Extremely abundant**. Hosts Flutter SDK, Android SDK, Java JDK, TrueLern workspace, and redirected build caches. |

---

## 2. Configuration Applied & Exact Locations

To eliminate `C:\` disk exhaustion risks, the following two authoritative cache redirections were configured:

| Configuration Item | Mechanism Applied | Target Location on D:\ | Scope | Verification Status |
|---|---|---|---|:---:|
| **Dart / Flutter Pub Cache** | Windows User Environment Variable `PUB_CACHE` | `D:\.pub-cache` | User (`[System.EnvironmentVariableTarget]::User`) | **`VERIFIED`** |
| **Gradle User Home Cache** | Windows User Environment Variable `GRADLE_USER_HOME` | `D:\.gradle` | User (`[System.EnvironmentVariableTarget]::User`) | **`VERIFIED`** |

### Why User Environment Variables Were Used Over `gradle.properties`:
In the Flutter Android Gradle toolchain, the Gradle Wrapper (`gradlew.bat`) bootstraps and downloads its distribution zip *before* project-level `android/gradle.properties` files are read. Relying on `systemProp.gradle.user.home` in `gradle.properties` fails to redirect the initial ~230 MB Gradle wrapper distribution download, immediately writing to `%USERPROFILE%\.gradle` on `C:\`. The canonical, universally supported, and wrapper-safe mechanism is setting `GRADLE_USER_HOME=D:\.gradle` at the Windows user environment level.

---

## 3. Old C:\ Caches Intentionally Preserved

In strict adherence to cache migration and safety rules:
- **`C:\Users\biswa\.gradle`**: **3,515,883,472 bytes (~3.52 GB)** — **UNTOUCHED / PRESERVED**.
- **`C:\Users\biswa\AppData\Local\Pub\Cache`**: **225,488,059 bytes (~225 MB)** — **UNTOUCHED / PRESERVED**.
- No files were deleted, moved, cleaned, or uninstalled on `C:\`.
- Flutter SDK (`D:\flutter`) and Android SDK (`D:\Android\Sdk`) were not modified.

---

## 4. Empirical Verification Results

Both cache redirection targets were validated through actual dependency and wrapper operations:

### 4.1 Pub Cache Verification (`PUB_CACHE=D:\.pub-cache`)
- **Action**: Ran `flutter pub get` on the TrueLern scaffold.
- **Result**: Packages (`cupertino_icons 1.0.8`, `flutter_lints 5.0.0`, `lints 5.1.1`) downloaded directly into `D:\.pub-cache\hosted\pub.dev\`.
- **Target Size**: `D:\.pub-cache` grew from 0 B to **24,154,308 bytes (~24 MB)**.
- **C:\ Impact**: `C:\Users\biswa\AppData\Local\Pub\Cache` remained exactly **225,488,059 bytes** (0 bytes written to `C:\`).

### 4.2 Gradle User Home Verification (`GRADLE_USER_HOME=D:\.gradle`)
- **Action**: Ran `gradlew.bat --version` via JDK 17 (`D:\Java\jdk-17`).
- **Result**: Gradle wrapper successfully downloaded and unpacked Gradle 9.3.1 into `D:\.gradle\wrapper\dists\gradle-9.3.1-all\`.
- **Gradle Version Output**:
  ```
  Gradle 9.3.1
  Kotlin: 2.2.21 | Groovy: 4.0.29 | Ant: Apache Ant 1.10.15
  Launcher JVM: 17.0.20.1 (Microsoft 17.0.20.1+1-LTS)
  Daemon JVM: D:\Java\jdk-17 (current Java home)
  OS: Windows 11 10.0 amd64
  ```
- **Target Size**: `D:\.gradle` populated to **729,170,105 bytes (~729 MB)**.
- **C:\ Impact**: `C:\Users\biswa\.gradle` remained exactly **3,515,883,472 bytes** (0 bytes written to `C:\`).

---

## 5. Remaining Disk Risk Assessment

While build artifacts, package downloads, and Gradle wrapper distributions are now redirected to `D:\`:
- **`C:\` Available Space**: Remains critically low at **~321 MB**.
- **Windows System Temp**: Any unconfigured third-party tools that write to `C:\Users\biswa\AppData\Local\Temp` or `%APPDATA%` still pose a risk if heavy OS operations occur.
- **Recommendation for Future Steps**: The user may, at their discretion during a dedicated maintenance pass outside of TrueLern, migrate or clear the old 3.52 GB Gradle cache on `C:\` to restore safety margins to the system drive. Under current project configuration, TrueLern builds will NOT touch `C:\`.

---

## 6. Governance Lock Status

```
============================================================
TRUELEARN AIO FLUTTER — BUILD ENVIRONMENT STATUS
============================================================
PHASE 1A — PARENT:
[LOCKED — APPROVED PLANNING BASELINE]

BUILD CACHE CONFIGURATION:
[APPLIED & VERIFIED]

GRADLE CACHE TARGET:
D:\.gradle

PUB CACHE TARGET:
D:\.pub-cache

OLD GRADLE CACHE (C:\):
[PRESERVED — 3.52 GB]

OLD PUB CACHE (C:\):
[PRESERVED — 225 MB]

C:\ FREE SPACE:
~321 MB

D:\ FREE SPACE:
~138.5 GB

DEPENDENCIES ADDED:
[NONE]

FLUTTER ARCHITECTURE:
[NOT STARTED]

PARENT SCREENS:
[NOT STARTED]

BACKEND:
[NOT MODIFIED]
============================================================
```
