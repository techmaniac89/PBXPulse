# PBXPulse

**Your PBX. In your pocket.**

PBXPulse is a mobile-first companion for Asterisk-based phone systems. It does
not try to replace Asterisk, FreePBX, or a full administration interface.
Instead, it quietly observes what is happening, understands what matters, and
presents it in clear human language.

> **PBXPulse doesn't monitor your PBX. It understands it.**

## What PBXPulse Is

PBXPulse is an Android-first app supported by a lightweight open-source agent
installed near the PBX.

The agent talks to Asterisk and the local system. The app talks only to the
PBXPulse Agent.

```text
PBXPulse Android App
        |
 HTTPS / WebSocket
        |
PBXPulse Agent
        |
        +-- Asterisk AMI
        +-- Asterisk CLI / local checks
        +-- Linux system metrics
        +-- Optional future integrations
```

## Core Idea

PBXPulse turns technical activity into **Signals**: meaningful, human-readable
updates that explain what happened and whether the user should care.

## Genesis

**Mission:** Make PBXPulse feel alive before it becomes useful.

Genesis is the first alpha. It starts with the Flutter Android app using mock
data. No backend. No Asterisk. No networking. The goal is to make the Home feed,
Pulse screen, Calls screen, and People screen feel like a real product.

## Repository Structure

```text
pbxpulse/
+-- lib/
|   +-- app/
|   +-- design_system/
|   +-- features/
|   +-- mock/
|   +-- models/
|   +-- repositories/
+-- docs/
|   +-- VISION.md
|   +-- DESIGN.md
|   +-- ARCHITECTURE.md
|   +-- ROADMAP.md
|   +-- PROGRAMMING_STRUCTURE.md
|   +-- GENESIS_STATUS.md
|   +-- BREEZE_API_CONTRACT.md
+-- test/
+-- CODEX.md
+-- pubspec.yaml
+-- README.md
```

Genesis currently contains the Flutter app source, mock product data, Material 3
theme, reusable components, and the five-tab app shell. Android platform files
should be generated with Flutter once the SDK is installed:

```bash
flutter create . --platforms=android
flutter pub get
flutter run
```

On Windows, make sure Flutter is on `PATH`:

```text
C:\Users\ebata\flutter\bin
```

Android builds also require Java and the Android SDK command-line tools. Check
the local setup with:

```bash
flutter doctor -v
```

## Product Principles

The detailed product philosophy lives in [docs/VISION.md](docs/VISION.md).

Use the docs this way:

- [docs/VISION.md](docs/VISION.md): product philosophy and language.
- [docs/DESIGN.md](docs/DESIGN.md): Android UX and screen behavior.
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md): app, Agent, Observers, and Pulse Engine.
- [docs/ROADMAP.md](docs/ROADMAP.md): release milestones.
- [docs/GENESIS_STATUS.md](docs/GENESIS_STATUS.md): current milestone status.
- [docs/BREEZE_API_CONTRACT.md](docs/BREEZE_API_CONTRACT.md): first Agent API contract.
- [docs/PROGRAMMING_STRUCTURE.md](docs/PROGRAMMING_STRUCTURE.md): how to maintain the Flutter app.
