import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pbxpulse/app/app_settings.dart';
import 'package:pbxpulse/mock/mock_pulse_repository.dart';
import 'package:pbxpulse/models/signal.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('mock Genesis feed exposes explainable Signals', () {
    final repository = MockPulseRepository(autoStart: false);

    expect(repository.signals, isNotEmpty);
    expect(repository.signals.every((signal) => signal.why.isNotEmpty), isTrue);
    expect(
      repository.signals.map((signal) => signal.category),
      contains(SignalCategory.activity),
    );

    repository.dispose();
  });

  test('mock Genesis office has enough extensions and activity to feel alive',
      () {
    final repository = MockPulseRepository(autoStart: false);

    expect(repository.people.length, greaterThanOrEqualTo(24));
    expect(repository.calls.length, greaterThanOrEqualTo(18));
    expect(repository.signals.length, greaterThanOrEqualTo(10));
    expect(
      repository.people.map((person) => person.extension),
      containsAll(['101', '120', '130', '305', '401', '599']),
    );

    repository.dispose();
  });

  test('mock Genesis lifecycle adds and resolves Signals', () async {
    final repository = MockPulseRepository(autoStart: false);

    repository
      ..advanceGenesisPulseForTest()
      ..advanceGenesisPulseForTest();

    expect(
      repository.signals.map((signal) => signal.id),
      contains('sig_door_phone_checked_in'),
    );
    expect(
      repository.signals
          .firstWhere((signal) => signal.id == 'sig_reception_maria')
          .state,
      SignalState.resolved,
    );
    expect(repository.now.title, 'The office is quiet.');

    repository.dispose();
  });

  test('mock repository can dismiss Signals', () {
    final repository = MockPulseRepository(autoStart: false);
    final signal = repository.signals.first;

    repository.dismissSignal(signal);

    expect(
      repository.signals
          .firstWhere((candidate) => candidate.id == signal.id)
          .state,
      SignalState.dismissed,
    );

    repository.dispose();
  });

  test('theme mode persists through app settings', () async {
    SharedPreferences.setMockInitialValues({});
    final settings = PBXAppSettings();

    await settings.setThemeMode(ThemeMode.light);

    final loadedSettings = PBXAppSettings();
    await loadedSettings.load();

    expect(loadedSettings.themeMode, ThemeMode.light);

    settings.dispose();
    loadedSettings.dispose();
  });
}
