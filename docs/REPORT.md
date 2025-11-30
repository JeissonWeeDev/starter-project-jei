# Project Report: Applicant Showcase App

This document serves as the final report on the development and experience with the "Applicant Showcase App" by Symmetry, following the instructions provided in `REPORT_INSTRUCTIONS.md`.

## 1. Introduction
[Please write your introduction here. Describe your initial feelings about the project and your personal context or experience.]

## 2. Learning Journey
[Please describe your learning process here, especially if there were new technologies for you. Discuss the resources used and how you applied that knowledge.]

## 3. Challenges Faced
[Please reflect here on the challenges and obstacles you encountered. Discuss how you overcame them and the lessons learned.]

### Curious Note on Report Management
It's interesting to note the process of contributing to this central `REPORT.md` through feature branches. In many real-world projects, detailed individual debugging logs like this might not reside directly in the main repository's `docs` folder. However, for the specific purpose of this Applicant Showcase App, this `REPORT.md` serves as the primary deliverable to document the learning journey and challenges faced, as instructed. I am proceeding by adding relevant sections to this single, central report.

## 4. Reflection and Future Directions
[Please reflect on your overall experience with the project. Discuss what you learned (technically and professionally) and how it contributes to your growth as a developer. You can also outline ideas for future improvements.]

## 5. Project Evidence
[Please include screenshots and videos of the final version of your project here to visually demonstrate its functionality and design.]

## 6. Overdelivery
[Please describe here any additional features implemented or prototypes created that go beyond the initial project requirements, following the structure of 'REPORT_INSTRUCTIONS.md'.]

---

## 8. Debugging and Setup Log (Flutter Project on Linux)

This section summarizes the key issues and their resolutions during the initial setup and build process of the Flutter frontend project on a Linux environment.

**Context:** User operates on **Linux** with a **custom Flutter SDK setup on an external HDD**, requiring `source ~/.profile` for Flutter commands.

### 8.1 Initial Project Setup Highlights

*   **Backend (`firebase-tools`):** Installed globally. Manual Firebase project setup remains for the user.
*   **Flutter Environment:** Verified custom Flutter/Android SDK paths on HDD (`flutter doctor -v`). Corrected initial `flutter pub get` directory issue.

### 8.2 Resolving Dependency Conflicts

*   **Issue: Outdated SDK/Dependency Versions.**
    *   **Problem:** Project was configured for older Dart SDK (<3.0.0), causing `build_runner` errors (`NullThrownError`) and other incompatibilities (e.g., `flutter_hooks`, `DioErrorType.response`).
    *   **Solution:** Updated `frontend/pubspec.yaml` (Dart SDK to `>=3.0.0 <4.0.0`, more permissive dependency versions like `^0.20.0` for `flutter_hooks`). Ran `flutter pub upgrade --major-versions` and `flutter pub get`. Replaced `DioErrorType.response` with `DioExceptionType.badResponse`. `build_runner` then succeeded.

### 8.3 Launcher Icons

*   **Issue:** `flutter_launcher_icons` command failed due to missing package/config, then missing icon file.
*   **Solution:** Added `flutter_launcher_icons` to `pubspec.yaml` and its configuration.
*   **Pending:** Requires user to provide `assets/icon/icon.png`.

### 8.4 Application Execution Progress

*   **Issue: Emulator Detection.**
    *   **Problem:** Initial `flutter run -d pixel_8_api_34` failed to find the emulator by its configured name; `adb` was also not found by the agent's shell.
    *   **Solution:** Identified correct running emulator ID (`emulator-5554`) for `flutter run`.
*   **Issue: Android `minSdkVersion` Error.**
    *   **Problem:** `cloud_firestore` library required `minSdkVersion` 23, but project was set to 21.
    *   **Solution:** Updated `minSdkVersion` to 23 in `frontend/android/app/build.gradle`.

### 8.5 Current Blocking Issue: Missing Java `jlink` Tool

*   **Problem:** Build failed because `jlink` executable (part of the Java Development Kit) was missing from the system's Java 17 installation path. This is essential for Gradle to complete the build.
*   **Current Status:** This is an external system dependency. The user needs to manually install a full JDK (e.g., `openjdk-17-jdk` or a compatible version like Java 11) on their Linux system. Automated execution cannot proceed until `jlink` is available.
