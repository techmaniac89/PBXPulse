# PBXPulse Design

## Design Direction

PBXPulse should feel like a modern, calm, consumer-grade Android app, not
enterprise telecom software.

It should feel closer to:

- Google Home
- Home Assistant Companion
- Apple Health
- A modern activity feed

And less like:

- FreePBX on a phone
- A network appliance interface
- A monitoring dashboard
- A SIP debugging tool

## Android-First

The first app targets Android and should follow modern Material 3 patterns.

Use:

- Material 3 navigation
- Large readable text
- Rounded cards
- Comfortable spacing
- Clear touch targets
- Smooth but restrained motion

## Main Navigation

Main navigation uses five tabs:

```text
Home      Calls      Pulse      People      Settings
```

Pulse sits in the middle because it is the heart of the app.

Avoid technical navigation labels such as Dashboard, Extensions, Endpoints,
Registrations, Logs, Analytics, and Monitoring.

## Screen Questions

| Screen | Question |
| --- | --- |
| Home | What's happening right now? |
| Calls | Who's talking and who called? |
| Pulse | Is everything okay? |
| People | How are my users and devices doing? |
| Settings | How is PBXPulse configured? |

## Home Screen

Home is a live feed, not a dashboard.

It starts with:

1. Greeting
2. Mood sentence
3. Now card
4. Signal feed

Example:

```text
Good evening

Everything looks healthy.

Now
Reception is talking to Maria.
Started 2 minutes ago.

Reception answered John.
2 minutes ago

Calls have been quieter than usual this afternoon.

Nightly backup completed successfully.
```

## Connection State

Connection state explains how the app is currently connected to the PBX. It can
appear in Settings, onboarding, or a compact contextual surface when it is worth
the space.

Examples:

- `Connected locally`
- `Connected through VPN`
- `Secure remote connection`
- `Trying to reconnect...`

A connection detail sheet should include:

- Connection type
- Connection quality
- Agent version
- Last contact
- Encryption state
- Optional latency

## Now Card

The Now card answers what is happening at this moment.

If no calls are active:

```text
Now
The office is quiet.
Nobody is on a call right now.
```

## Signal Cards

Signal cards are the core UI primitive.

Each Signal card should include:

- Icon
- Human title
- Optional short body
- Time
- Optional action
- Optional state
- Subtle category accent

Signal cards should breathe. Do not cram many dense cards onto the screen.

## Signal Detail Screen

A Signal detail screen has layers:

1. Summary
2. What you can do
3. Why?
4. Technical details

Technical details are expandable and one tap deeper.

## Pulse Screen

Pulse is not a chart page. It is a calm explanation of how things are going.

Avoid percentages and gauges as primary UI. Use plain language first.

## Calls Screen

Calls answers: **Who's talking and who called?**

Priority:

1. Active calls
2. Missed calls
3. Recent calls
4. Search

## People Screen

Use **People**, not Extensions.

Humans remember names and roles before extension numbers.

Tap a person to see:

- Status
- Recent activity
- Devices
- Calls
- Voicemail
- Related Signals
- Technical details if expanded

## Settings Screen

Settings should stay small.

Suggested sections:

- Connected PBXs
- Notifications
- Appearance
- Agent
- Privacy
- About

Avoid turning Settings into a PBX configuration panel.

## Themes

### Default Theme

Dark green / black.

Mood: calm, modern, cozy, technical but not cold.

Avoid pure black if possible. Use a very dark green-black.

### Optional Theme

Light / green.

Use a soft warm white or cream background rather than harsh pure white.

## Typography

Typography should be friendly, modern, comfortable, readable, not overly
corporate, and not hacker-like.

Use generous line spacing and large enough text.

## Motion

Motion should be subtle and meaningful.

Use:

- Signal appearing into the feed
- Connection state changes
- Signal lifecycle transitions
- Gentle heartbeat metaphor for Pulse if it stays tasteful

Avoid:

- Excessive bouncing
- Flashing warnings
- Busy loading animations

## Empty States

Never show dead, cold empty states.

Instead of:

> No active calls.

Use:

> The office is quiet. Nobody is on a call right now.

Instead of:

> No events.

Use:

> It's been a quiet day. Everything has been running smoothly.

## Wording Examples

| Technical | PBXPulse language |
| --- | --- |
| Endpoint unreachable | Warehouse phone went offline. |
| PJSIP contact expired | Reception phone stopped checking in. |
| Authentication failure | Someone is repeatedly trying to sign in. |
| Backup successful | Nightly backup completed successfully. |
| CPU 28% | Your server is running comfortably. |
| Disk 82% | Storage is starting to fill up. |
| AMI disconnected | PBXPulse lost contact with your PBX. Trying to reconnect... |
