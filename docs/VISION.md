# PBXPulse Vision

## Product Sentence

> **PBXPulse listens to your PBX, so you don't have to.**

## Core Philosophy

> **PBXPulse doesn't monitor your PBX. It understands it.**

Traditional monitoring exposes events. PBXPulse curates them.

```text
Traditional monitoring:
1000 raw events -> user

PBXPulse:
1000 raw events -> understanding -> a few meaningful Signals -> user
```

PBXPulse exists because users should not need to think like Asterisk to
understand their phone system.

## Mission

Help people understand what is happening with their PBX using calm, clear,
human language.

PBXPulse should answer three questions within seconds:

1. Is everything okay?
2. Is anyone talking?
3. Do I need to do anything?

This is the **Coffee Test**: someone waiting in line for coffee should be able
to open PBXPulse, understand their PBX, and close the app in under ten seconds.

## Target Users

PBXPulse is not only for telecom engineers.

It should feel useful and approachable for:

- Home lab users
- Small business owners
- Reception teams
- IT administrators
- Telecom engineers
- MSPs

The experience is the same for everyone. Technical users can expand details
when needed, but the base experience remains simple and human.

## What PBXPulse Is

PBXPulse is:

- A mobile companion for PBX awareness
- A human-language translation layer for Asterisk activity
- A live feed of meaningful Signals
- A calm assistant that speaks only when something matters
- A tool for confidence, not noise

## What PBXPulse Is Not

PBXPulse is not:

- A PBX distribution
- A FreePBX replacement
- An Asterisk CLI client
- A SIP debugger
- A full configuration interface
- A traditional monitoring dashboard
- A wall of charts and percentages

## The PBXPulse Constitution

1. Signals, not logs.
2. Human first.
3. Calm by default.
4. The feed is alive.
5. Curate, do not dump.
6. Silence is a feature.
7. Every Signal is explainable.
8. One tap deeper.
9. Celebrate healthy systems.
10. One experience.
11. Privacy first.
12. Beautiful software lasts longer.

## Signals

A **Signal** is something worth the user's attention.

A Signal is not a raw event. It is the result of observation, correlation,
filtering, and translation.

Examples:

- `Reception answered Maria.`
- `Warehouse phone went offline again.`
- `Warehouse phone is back online. It was unavailable for about 8 minutes.`
- `Everything stayed healthy overnight.`
- `Calls have been quieter than usual this afternoon.`
- `Several login attempts were blocked automatically.`

## Signal Categories

### Activity

Calls, voicemails, registrations, device changes, and day-to-day PBX activity.

### Insight

Patterns and observations.

### Security

Suspicious attempts, blocked logins, exposed services, certificate problems,
and related safety events.

### Health

PBX state, agent state, service health, storage, backups, system behavior.

### Recommendation

Clear suggestions based on what PBXPulse observed.

### Moment

Positive or meaningful milestones.

Examples:

- `Your PBX has been stable for 30 days.`
- `Everything stayed healthy overnight.`
- `Today was your busiest Friday this month.`

## Signal Lifecycle

Signals are mutable stories, not static log entries.

Example lifecycle:

1. `Warehouse phone went offline.`
2. `Warehouse phone has been offline for a few minutes.`
3. `Warehouse phone is back online. It was unavailable for about 8 minutes.`

The same Signal evolves instead of creating disconnected log entries.

## Language Principles

PBXPulse should sound like a trusted colleague: calm, clear, friendly, and
useful.

Avoid:

- Jargon by default
- Percentages as primary UI
- Scary wording unless truly critical
- Repetitive template text
- Fake excitement

Prefer:

- `Everything looks healthy.`
- `There is one thing worth checking.`
- `The office has been quiet this afternoon.`
- `Reception has been busier than usual today.`
- `Storage is starting to fill up. You may want to review old recordings soon.`

## No AI In The Initial Pulse Engine

The first versions of PBXPulse should not depend on AI.

The Pulse Engine should be deterministic, explainable, and rule-based:

- Observe
- Correlate
- Filter
- Recognize simple patterns
- Generate Signals from templates and context rules

AI may be considered later only if it preserves explainability and is optional.
