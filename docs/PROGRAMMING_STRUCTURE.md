# PBXPulse Programming Structure

This document explains how the current Genesis Flutter app is organized so you
can maintain basic components safely.

Related docs:

- `CODEX.md`
- `docs/VISION.md`
- `docs/DESIGN.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/GENESIS_STATUS.md`
- `docs/BREEZE_API_CONTRACT.md`

This file is intentionally practical. Product philosophy lives in
`docs/VISION.md`; this guide explains where to make everyday Flutter changes.

## Project Shape

```text
lib/
+-- main.dart
+-- app/
|   +-- pbx_pulse_app.dart
|   +-- navigation/
|   +-- theme/
+-- design_system/
|   +-- pbx_colors.dart
|   +-- pbx_spacing.dart
|   +-- components/
+-- features/
|   +-- home/
|   +-- calls/
|   +-- pulse/
|   +-- people/
|   +-- settings/
|   +-- signal_detail/
+-- mock/
+-- repositories/
+-- models/
```

The app is split into six main ideas:

- `app`: app startup, navigation, theme.
- `design_system`: reusable colors, spacing, and widgets.
- `features`: screens the user sees.
- `models`: small data classes that describe app concepts.
- `mock`: fake Genesis data and fake lifecycle updates.
- `repositories`: app-facing data contracts.

## Startup Flow

The app starts here:

```text
lib/main.dart
```

`main.dart` calls:

```dart
runApp(const PBXPulseApp());
```

`PBXPulseApp` lives here:

```text
lib/app/pbx_pulse_app.dart
```

It creates:

- the Material app
- the dark PBXPulse theme
- the light PBXPulse theme
- app settings such as the selected theme mode
- the `MockPulseRepository`
- the five-tab app shell

The app shell lives here:

```text
lib/app/navigation/pbx_pulse_shell.dart
```

It controls the bottom navigation:

```text
Home
Calls
Pulse
People
Settings
```

Root navigation rules live in `docs/DESIGN.md`.

## Theme

The main theme is here:

```text
lib/app/theme/pbx_pulse_theme.dart
```

The color constants are here:

```text
lib/design_system/pbx_colors.dart
```

The spacing constants are here:

```text
lib/design_system/pbx_spacing.dart
```

If you want to change the general look of the app, start with these files.

Common examples:

- Change background color: edit `PBXColors.background`.
- Change card color: edit `PBXColors.card`.
- Change the green accent: edit `PBXColors.pulseGreen`.
- Change repeated spacing: edit `PBXSpacing`.

Keep the app calm. Avoid loud red, busy gradients, or dashboard-like styling.

## Models

Models live here:

```text
lib/models/
```

Current models:

- `signal.dart`
- `person.dart`
- `call_activity.dart`
- `connection_status.dart`

### Signal

`PulseSignal` is the most important model.

It represents something meaningful enough for the user to see.

Important fields:

- `id`: stable Signal identity.
- `kind`: internal Signal type.
- `category`: activity, insight, security, health, recommendation, moment.
- `importance`: how much attention it deserves.
- `state`: active, updated, resolved, dismissed, archived.
- `title`: human-facing sentence.
- `body`: short explanation.
- `timeLabel`: friendly time text.
- `why`: evidence explaining why the Signal exists.
- `technical`: technical evidence one tap deeper.

Every Signal should have a clear `why`. Signal language rules live in
`docs/VISION.md`.

## Mock Repository

Genesis data lives here:

```text
lib/mock/mock_pulse_repository.dart
```

This file pretends to be the future app data layer.

It provides:

- greeting text
- mood text
- connection status
- current call state
- Signal feed
- calls
- people
- mock lifecycle timers

The repository extends `ChangeNotifier`.

That means screens can listen to it and rebuild when mock data changes.

### Mock Lifecycle

The mock lifecycle currently does this:

1. After a few seconds, a Door Phone Signal appears.
2. The Reception call resolves.
3. The Now card changes to a quiet state.
4. A calm Moment appears.

This helps Genesis feel alive before it becomes useful.

If you want to add a new fake Signal, add it in this file.

Keep fake Signals realistic, calm, and explainable.

## Screens

Screens live here:

```text
lib/features/
```

Each screen answers one natural question.

| Screen | File | Question |
| --- | --- | --- |
| Home | `features/home/home_screen.dart` | What is happening right now? |
| Calls | `features/calls/calls_screen.dart` | Who is talking and who called? |
| Pulse | `features/pulse/pulse_screen.dart` | Is everything okay? |
| People | `features/people/people_screen.dart` | How are my users and devices doing? |
| Person Detail | `features/people/person_detail_screen.dart` | What has happened with this person or device? |
| Settings | `features/settings/settings_screen.dart` | How is PBXPulse configured? |
| Signal Detail | `features/signal_detail/signal_detail_screen.dart` | Why am I seeing this? |

## Reusable Components

Reusable widgets live here:

```text
lib/design_system/components/
```

Current components:

- `GreetingCard`
- `ConnectionChip`
- `NowCard`
- `SignalCard`
- `PulseCard`
- `PersonCard`
- `CallActivityCard`
- `PBXScreenScaffold`
- `SectionLabel`

If the same UI pattern appears on more than one screen, it probably belongs in
`design_system/components`.

If a widget is only used by one screen, it can stay private in that screen file.

Private widgets usually start with `_`, for example:

```dart
class _SettingsTile extends StatelessWidget
```

## How Data Reaches The UI

The current data flow is:

```text
MockPulseRepository
        |
        v
PBXPulseShell
        |
        v
Screens
        |
        v
Reusable components
```

The repository is passed into each screen through the `PulseRepository`
interface.

Current implementation:

```text
lib/mock/mock_pulse_repository.dart
```

App-facing contract:

```text
lib/repositories/pulse_repository.dart
```

Some screens use:

```dart
AnimatedBuilder(
  animation: repository,
  builder: (context, _) {
    ...
  },
)
```

That means the screen updates when the repository calls:

```dart
notifyListeners();
```

Use this pattern when a screen should update when mock data changes.

## Common Maintenance Tasks

### Change Text On The Home Greeting Card

Edit:

```text
lib/mock/mock_pulse_repository.dart
```

Look for:

```dart
String get greeting => 'Good evening';
```

or:

```dart
var _mood = 'Everything looks healthy.';
```

### Change The PBXPulse Logo Area

Edit:

```text
lib/design_system/components/greeting_card.dart
```

The small heart mark is inside `GreetingCard`. Genesis intentionally avoids a
large repeated PBXPulse wordmark on the Home screen.

### Change The Heartbeat Animation

Edit:

```text
lib/design_system/components/pulse_card.dart
```

Look for:

```dart
class _BeatingIcon
```

The animation duration is currently:

```dart
Duration(milliseconds: 1800)
```

Increase the duration for a slower beat. Decrease it for a faster beat.

Keep it slow and subtle.

### Add A New Signal Card To The Feed

Edit:

```text
lib/mock/mock_pulse_repository.dart
```

Add a `PulseSignal` to `_initialSignals` or to one of the lifecycle methods.

Always include:

- a human title
- a calm body
- `why` evidence
- optional technical details

Example shape:

```dart
PulseSignal(
  id: 'sig_example',
  kind: 'example_kind',
  category: SignalCategory.health,
  importance: SignalImportance.feed,
  state: SignalState.active,
  title: 'Storage is starting to fill up.',
  body: 'You may want to review old recordings soon.',
  timeLabel: 'Just now',
  why: [
    'PBXPulse noticed storage usage is higher than usual.',
  ],
  technical: {
    'source': 'Genesis mock',
  },
)
```

### Change A Signal Card Layout

Edit:

```text
lib/design_system/components/signal_card.dart
```

This affects the Home feed and anywhere else Signal cards are reused.

Do not put technical details directly on `SignalCard`. They belong one tap
deeper in Signal Detail.

### Change Signal Detail

Edit:

```text
lib/features/signal_detail/signal_detail_screen.dart
```

This screen has four layers:

1. Summary
2. What you can do
3. Why?
4. Technical details

That structure is part of the product philosophy. Keep it.

### Change Settings Options

Edit:

```text
lib/features/settings/settings_screen.dart
```

Most Genesis settings persist through `PBXAppSettings`. Keep the screen simple
and avoid turning Settings into a PBX control panel.

## Testing

Tests live here:

```text
test/
```

Current tests:

- `signal_model_test.dart`
- `widget_test.dart`

Run tests with:

```powershell
C:\Users\ebata\flutter\bin\flutter.bat test
```

Run analyzer with:

```powershell
C:\Users\ebata\flutter\bin\flutter.bat analyze
```

Build a debug APK with:

```powershell
C:\Users\ebata\flutter\bin\flutter.bat build apk --debug
```

Run the app on the emulator with:

```powershell
C:\Users\ebata\flutter\bin\flutter.bat run -d emulator-5554
```

## Coding Style

Prefer:

- small widgets
- clear names
- human product language
- reusable components
- mock data shaped like the future app API

Avoid:

- raw Asterisk words in the main UI
- dashboard language
- large monolithic widgets
- statistics-first screens
- unexplained Signals
- backend or networking code during Genesis

## When Adding Something New

Before writing code, ask:

1. Does this help the user understand their PBX?
2. Is it calm?
3. Is it explainable?
4. Does it belong in Genesis?
5. Is this a Signal, a screen, a model, or a reusable component?

If the feature needs real Asterisk, networking, authentication, or backend
logic, it probably belongs after Genesis.

## Quick Map

```text
Want to change app colors?
-> lib/design_system/pbx_colors.dart

Want to change spacing?
-> lib/design_system/pbx_spacing.dart

Want to change tabs?
-> lib/app/navigation/pbx_pulse_shell.dart

Want to add fake data?
-> lib/mock/mock_pulse_repository.dart

Want to change Home?
-> lib/features/home/home_screen.dart

Want to change Signal cards?
-> lib/design_system/components/signal_card.dart

Want to change Settings?
-> lib/features/settings/settings_screen.dart

Want to change Person Detail?
-> lib/features/people/person_detail_screen.dart

Want to change Signal Detail?
-> lib/features/signal_detail/signal_detail_screen.dart

Want to change the theme?
-> lib/app/theme/pbx_pulse_theme.dart

Want to change theme mode behavior?
-> lib/app/app_settings.dart
```

## Final Reminder

PBXPulse should feel like a calm companion, not a telecom console.

When in doubt, choose the implementation that makes the app feel more human.
