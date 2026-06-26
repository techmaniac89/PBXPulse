# PBXPulse Architecture

## Overview

PBXPulse has two main parts:

1. **PBXPulse Android App** - the paid mobile experience.
2. **PBXPulse Agent** - a lightweight open-source service installed near the PBX.

The app never talks directly to Asterisk AMI, ARI, SSH, or SIP.

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
        +-- Optional Docker checks
        +-- Future integrations
```

## Core Architecture Principle

The app is not a frontend for Asterisk.

The app is a frontend for **Signals**.

The agent observes Asterisk and the system, then transforms raw information into
meaningful Signals.

## Event Pyramid

```text
Asterisk / System
        |
Raw Events
        |
Observers
        |
Correlation
        |
Pulse Engine
        |
Signals
        |
REST / WebSocket
        |
PBXPulse App
```

The app should never receive raw Asterisk events in the main user experience.

## Raw Events Are Not User Events

Not every raw event becomes a Signal. Observers may merge, delay, suppress, or
update Signals before the app sees anything.

The product rules for Signals and language live in `docs/VISION.md`.

## Pulse Engine

The Pulse Engine decides:

- Should the user care?
- Should PBXPulse wait before speaking?
- Should events be merged?
- Should a Signal be created?
- Should an existing Signal be updated?
- Should a push notification be sent?
- Should this become an Insight later?

## Observers

Initial Observer ideas:

- Call Observer: calls, answered calls, missed calls, call duration, active calls.
- Presence Observer: people/devices online, offline, unstable, or recovering.
- Health Observer: Asterisk availability, agent state, CPU, memory, disk, service status.
- Security Observer: authentication failures, suspicious patterns, exposed services.
- Backup Observer: backup success, backup failure, backup streaks, missing backups.
- Pattern Observer: repeated behavior over time and Insights.

## Signal Model

Initial Signal shape:

```json
{
  "id": "sig_123",
  "kind": "device_offline",
  "category": "activity",
  "importance": "attention",
  "state": "active",
  "title": "Warehouse phone went offline.",
  "body": "It stopped checking in a few minutes ago.",
  "time": "2026-06-26T18:42:00+03:00",
  "updated_at": "2026-06-26T18:45:00+03:00",
  "resolved_at": null,
  "actions": [
    { "id": "diagnose", "label": "Diagnose" },
    { "id": "open_person", "label": "Open person" }
  ],
  "why": [
    "The phone has not refreshed its registration.",
    "Recent keepalive checks did not receive a response."
  ],
  "technical": {
    "asterisk_endpoint": "203",
    "last_contact": "sip:203@192.168.1.55:5060",
    "last_status": "Unreachable"
  }
}
```

## Signal Lifecycle

Signals use stable IDs and can evolve over time. The app should treat a Signal
as one story that may be updated, resolved, dismissed, or archived.

Suggested internal importance levels:

```text
ignore -> merge -> feed -> inbox -> push
```

## Text Generation Without AI

The first version uses deterministic templates and context rules.

Avoid pure randomness. Variety should feel natural, not chaotic.

## App Data Contract

The app should be designed around app concepts, not Asterisk concepts.

The first Breeze API contract lives in `docs/BREEZE_API_CONTRACT.md`.

## Pairing And Security

Onboarding should use QR pairing.

The QR code should contain:

- Agent URL
- One-time pairing token
- Agent fingerprint
- Optional PBX display name

Pairing tokens should be one-time and short-lived.

## Remote Connectivity

Preferred order:

1. Local LAN
2. VPN
3. Secure exposed HTTPS agent
4. Optional future relay

Asterisk AMI should not be exposed to the internet.

## Agent Distribution

The agent should be open source on GitHub.

Initial distribution:

- Docker Compose
- `.env.example`
- Install script later
- `.deb` package later

The mobile app is the paid product. The agent is trusted infrastructure.
