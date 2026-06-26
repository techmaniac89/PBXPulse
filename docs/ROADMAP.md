# PBXPulse Roadmap

## Release Philosophy

PBXPulse should grow slowly and deliberately.

Do not add features just because Asterisk supports them. Add features only when
they reinforce the product promise:

> PBXPulse understands your PBX and tells you what matters.

## Genesis - Alpha

**Mission:** Make PBXPulse feel alive before it becomes useful.

Genesis is app-first. No backend. No Asterisk. No networking.

### Goals

- Build the Android Flutter shell.
- Use Material 3.
- Create the dark green/black default theme.
- Create fake but realistic Signals.
- Build the Home feed.
- Build the bottom navigation.
- Build placeholder Calls, Pulse, People, and Settings screens.
- Define the first app models around Signals.

### Must Have

- Home feed with mock Signals.
- Greeting + mood text.
- Connection state.
- Now card.
- Signal cards.
- Pulse tab in the center.
- People tab instead of Extensions.
- Human language everywhere.

### Nice To Have

- Signal detail screen.
- Light theme.
- Subtle animations.
- Mock Signal lifecycle update.
- First heartbeat animation: a mock Signal appears into the feed.

### Definition Of Done

Someone should be able to open the app with fake data and immediately
understand PBXPulse.

## Breeze - Beta

**Mission:** The app starts breathing.

Breeze introduces the first real agent and live WebSocket Signals.

### Goals

- Create open-source PBXPulse Agent.
- Add basic FastAPI service.
- Add QR pairing prototype.
- Add `/home` endpoint.
- Add `/live` WebSocket.
- Stream mock Signals from agent to app.
- Replace local mock service with agent service.

## Canopy - v1.0

**Mission:** Reliable enough for real users.

Canopy is the first public-ready version.

### Goals

- Real Asterisk AMI connection.
- Call Observer.
- Presence Observer.
- Health Observer.
- Signal Engine v1.
- Push notifications.
- Basic Settings.
- Play Store release.

### Must Have

- Active calls.
- Recent calls.
- People/device status.
- Feed Signals from real Asterisk events.
- Basic Pulse screen.
- Explainable Signal details.
- Secure token authentication.
- Local/VPN/remote connection support.

## Future Releases

### Security Observer

- Failed login detection.
- Repeated authentication attempt grouping.
- Suspicious IP summary.
- Calm security Signals.

### Backup Observer

- Backup success/failure Signals.
- Backup streak Moments.
- Missing backup Recommendation.

### Pattern Observer

- Repeated disconnect detection.
- Busy/quiet call day detection.
- Missed call trends.
- Unusual security trend detection.

### Diagnostics

- Tap Signal -> Diagnose.
- Check phone reachability.
- Check registration state.
- Check SIP keepalive state.
- Explain likely cause.

### Multi-PBX

- Multiple PBXs in one app.
- Per-PBX feed filtering.
- Combined overview later, only if it stays simple.

### Optional Pro/Future Ideas

Only consider features that require ongoing infrastructure or significant added
value:

- Secure remote relay.
- Multi-user team access.
- MSP fleet view.
- Off-site encrypted backups.
- Optional AI-enhanced explanations later, if explainable and not required.

## Pricing Direction

Initial idea:

- Agent: free and open source.
- Android app: one-time purchase, around EUR 4.99-5.99 at launch.
- No subscription for the core experience.
- Optional future paid features only if they genuinely require ongoing service costs.

## Things We Should Not Build Early

- Dialplan editor.
- SIP trunk editor.
- IVR builder.
- Queue configuration UI.
- Full FreePBX-like administration.
- Raw log viewer as a main screen.
- Dashboard widgets.
- Mandatory cloud account.
- AI assistant in the first versions.
