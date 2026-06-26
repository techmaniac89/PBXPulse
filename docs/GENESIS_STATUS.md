# Genesis Status

Genesis mission:

> Make PBXPulse feel alive before it becomes useful.

## Current State

PBXPulse is still in Genesis. The app is mock-only and intentionally has no
backend, no Asterisk integration, and no networking.

What exists now:

- Android Flutter app shell.
- Material 3 dark and light themes.
- Five root tabs: Home, Calls, Pulse, People, Settings.
- Mock Signal feed with lifecycle updates.
- Home split into Happening now and Earlier today.
- Home Signal filters.
- Calls search and type filters.
- People search.
- Person Detail with Activity, Signals, and Details views.
- Signal Detail with Diagnose, Open person, and Dismiss mock actions.
- Settings sheets for connection, notifications, appearance, privacy, reset, and about.
- Persisted theme, onboarding, notification, and privacy settings.
- Mock onboarding / pairing entry.
- Android app label, splash color, and placeholder adaptive icon.
- Repository interface so the current mock and future Agent data source can
  share one app-facing contract.
- Breeze `/home` and `/live` contract draft based on the current Flutter
  models.

## Genesis Done Criteria

Genesis is close, but not complete.

Remaining polish before calling Genesis done:

- Review first-run onboarding copy on a real phone-sized emulator.
- Tune Home feed density after several mock lifecycle updates.
- Confirm light theme contrast across every screen.
- Replace placeholder launcher icon with production-quality artwork.
- Add visual screenshots to the repo for Home, Pulse, People, Signal Detail, and Settings.
- Decide whether Genesis should include a small in-app "demo reset" confirmation step.

## Breeze Boundary

The Breeze boundary is the Agent. The next step is an Agent scaffold and mock
FastAPI service that follows `docs/BREEZE_API_CONTRACT.md`.

Do not start Breeze by adding raw Asterisk concepts to the Flutter UI.

## Current Road To Breeze

PBXPulse is approximately here:

```text
Genesis UI foundation       complete
Genesis mock lifecycle      complete
Genesis screen polish       mostly complete
Genesis visual QA           not started
Genesis production identity partial
Breeze Agent scaffold       not started
Breeze live transport       not started
```

Recommended next milestone work:

1. Finish visual QA and screenshots.
2. Create a minimal Agent folder and README, without connecting the app yet.
3. Build the first FastAPI mock Agent against `docs/BREEZE_API_CONTRACT.md`.
4. Add an Agent-backed repository implementation behind the same app interface.
5. Only then connect Flutter to the local Agent.
