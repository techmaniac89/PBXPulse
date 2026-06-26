import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pbxpulse/app/app_settings.dart';
import 'package:pbxpulse/app/pbx_pulse_app.dart';
import 'package:pbxpulse/mock/mock_pulse_repository.dart';

void main() {
  PBXAppSettings readySettings() {
    return PBXAppSettings(onboardingComplete: true);
  }

  testWidgets('Onboarding opens the Genesis mock PBX', (tester) async {
    final settings = PBXAppSettings();

    await tester.pumpWidget(
      PBXPulseApp(
        repository: MockPulseRepository(autoStart: false),
        settings: settings,
      ),
    );

    expect(find.text('Connect your PBX'), findsOneWidget);

    await tester.tap(find.text('Use Genesis mock PBX'));
    await tester.pump();

    expect(find.text('Good evening'), findsOneWidget);

    settings.dispose();
  });

  testWidgets('Genesis shell shows the Home feed', (tester) async {
    await tester.pumpWidget(
      PBXPulseApp(
        repository: MockPulseRepository(autoStart: false),
        settings: readySettings(),
      ),
    );

    expect(find.text('Good evening'), findsOneWidget);
    expect(find.text('Everything looks healthy.'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Reception answered Maria.'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Reception answered Maria.'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Pulse'), findsOneWidget);
    expect(find.text('People'), findsOneWidget);
  });

  testWidgets('Settings notification controls update the summary', (
    tester,
  ) async {
    await tester.pumpWidget(
      PBXPulseApp(
        repository: MockPulseRepository(autoStart: false),
        settings: readySettings(),
      ),
    );

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Notifications'));
    await tester.pumpAndSettle();

    expect(find.text('Meaningful Signals'), findsOneWidget);

    await tester.tap(find.byType(SwitchListTile).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();

    expect(find.text('Paused for now'), findsOneWidget);
  });

  testWidgets('Home shows cozy Signal rows', (tester) async {
    await tester.pumpWidget(
      PBXPulseApp(
        repository: MockPulseRepository(autoStart: false),
        settings: readySettings(),
      ),
    );

    await tester.scrollUntilVisible(
      find.text('Signals'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Signals'), findsOneWidget);
    expect(find.text('All 11'), findsOneWidget);
    expect(find.text('Activity 2'), findsOneWidget);
    expect(find.text('Reception answered Maria.'), findsOneWidget);
  });

  testWidgets('Home Signal categories filter the feed', (tester) async {
    await tester.pumpWidget(
      PBXPulseApp(
        repository: MockPulseRepository(autoStart: false),
        settings: readySettings(),
      ),
    );

    await tester.scrollUntilVisible(
      find.text('Tips 1'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Tips 1'));
    await tester.pump();

    expect(
        find.text('Support missed two calls close together.'), findsOneWidget);
    expect(find.text('Reception answered Maria.'), findsNothing);
  });

  testWidgets('Pulse tab keeps the summary view', (tester) async {
    await tester.pumpWidget(
      PBXPulseApp(
        repository: MockPulseRepository(autoStart: false),
        settings: readySettings(),
      ),
    );

    await tester.tap(find.text('Pulse'));
    await tester.pump();

    expect(find.text('Everything is running smoothly.'), findsOneWidget);
    expect(find.text("Things we've noticed"), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
  });

  testWidgets('Calls and People search narrow their lists', (tester) async {
    await tester.pumpWidget(
      PBXPulseApp(
        repository: MockPulseRepository(autoStart: false),
        settings: readySettings(),
      ),
    );

    await tester.tap(find.text('Calls'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'John');
    await tester.pumpAndSettle();
    expect(find.text('John called Reception.'), findsOneWidget);
    expect(find.text('Maria left a voicemail.'), findsNothing);

    await tester.tap(find.text('People'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Support');
    await tester.pumpAndSettle();
    expect(find.text('120 - Quiet'), findsOneWidget);
    expect(find.text('Warehouse'), findsNothing);
  });

  testWidgets('Calls filter by call type', (tester) async {
    await tester.pumpWidget(
      PBXPulseApp(
        repository: MockPulseRepository(autoStart: false),
        settings: readySettings(),
      ),
    );

    await tester.tap(find.text('Calls'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Voicemail'));
    await tester.pumpAndSettle();

    expect(find.text('Maria left a voicemail.'), findsOneWidget);
    expect(find.text('John called Reception.'), findsNothing);
  });

  testWidgets('Settings appearance controls update the theme summary', (
    tester,
  ) async {
    final settings = readySettings();

    await tester.pumpWidget(
      PBXPulseApp(
        repository: MockPulseRepository(autoStart: false),
        settings: settings,
      ),
    );

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();

    expect(find.text('Light theme'), findsOneWidget);

    settings.dispose();
  });

  testWidgets('Settings can reset the Genesis demo', (tester) async {
    final settings = readySettings();

    await tester.pumpWidget(
      PBXPulseApp(
        repository: MockPulseRepository(autoStart: false),
        settings: settings,
      ),
    );

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Reset Genesis demo'),
      220,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Reset Genesis demo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset demo'));
    await tester.pumpAndSettle();

    expect(find.text('Connect your PBX'), findsOneWidget);

    settings.dispose();
  });

  testWidgets('People entries open person details', (tester) async {
    await tester.pumpWidget(
      PBXPulseApp(
        repository: MockPulseRepository(autoStart: false),
        settings: readySettings(),
      ),
    );

    await tester.tap(find.text('People'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Warehouse'));
    await tester.pumpAndSettle();

    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Signals'), findsOneWidget);
    expect(find.text('Details'), findsOneWidget);

    await tester.tap(find.text('Details'));
    await tester.pumpAndSettle();
    expect(find.text('Show device evidence'), findsOneWidget);
  });

  testWidgets('Signal detail actions can open a person and dismiss a Signal', (
    tester,
  ) async {
    await tester.pumpWidget(
      PBXPulseApp(
        repository: MockPulseRepository(autoStart: false),
        settings: readySettings(),
      ),
    );

    await tester.scrollUntilVisible(
      find.text('Reception answered Maria.'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Reception answered Maria.'));
    await tester.pumpAndSettle();

    expect(find.text('What you can do'), findsOneWidget);

    await tester.tap(find.text('Open person'));
    await tester.pumpAndSettle();
    expect(find.text('Activity'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dismiss'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Dismissed for now'), findsOneWidget);
  });
}
