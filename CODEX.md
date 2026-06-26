# PBXPulse Development Guide

Welcome to PBXPulse.

Before implementing any feature, understand that PBXPulse is **not** another
Asterisk client. It is a companion that understands a PBX and communicates with
people using simple, calm, meaningful language.

If a proposed implementation conflicts with this philosophy, the philosophy
always wins.

## Canonical Docs

Read these before changing direction:

- `docs/VISION.md` owns the product philosophy.
- `docs/DESIGN.md` owns UX and language examples.
- `docs/ARCHITECTURE.md` owns system boundaries.
- `docs/ROADMAP.md` owns milestone scope.
- `docs/GENESIS_STATUS.md` owns current progress.
- `docs/BREEZE_API_CONTRACT.md` owns the first Agent API.
- `docs/PROGRAMMING_STRUCTURE.md` owns Flutter maintenance guidance.

When docs disagree, prefer the more specific document for that topic.

## Core Principles

### Signals, Not Events

Users never see raw Asterisk events in the main experience. Everything visible
is a **Signal** or app concept derived from Signals.

### Human First

Always prefer human language. Technical information is available one tap deeper,
but never shown first.

### Calm By Default

PBXPulse should feel reassuring.

Do not create unnecessary alerts. Silence is a feature. If nothing meaningful
happened, the interface should simply communicate that everything is running
smoothly.

### Curate, Do Not Dump

The application should never mirror Asterisk. Multiple technical events should
become one meaningful Signal whenever possible.

### Progressive Disclosure

The first layer is always simple. Technical details are available one tap
deeper.

Never hide information. Never force technical information on non-technical
users.

### Explain Everything

Every Signal must be explainable. Users should always be able to discover why a
Signal exists.

Never generate unexplained conclusions.

## Design Principles

Use Material 3 and keep the app calm, readable, and touch-friendly. The Home
screen is a chronological feed. Never convert it into a statistics dashboard.

## Technical Architecture

Flutter UI never communicates with Asterisk directly.

```text
Flutter
  |
REST + WebSocket
  |
Agent
  |
Pulse Engine
  |
Observers
  |
Asterisk
```

The application consumes Signals. The agent consumes Asterisk.

## Current Milestone

Current milestone: **Genesis**. Build the complete Flutter experience using mock
data only. No backend integration, networking, or real Asterisk logic yet.

The UI defines the API. Not the other way around.

## Final Rule

Whenever you are unsure about an implementation, ask:

> "Would this make PBXPulse feel more human?"

If the answer is no, reconsider the implementation.
