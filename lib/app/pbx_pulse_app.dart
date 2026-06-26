import 'package:flutter/material.dart';

import '../mock/mock_pulse_repository.dart';
import '../repositories/pulse_repository.dart';
import 'app_settings.dart';
import 'navigation/pbx_pulse_shell.dart';
import 'onboarding/onboarding_screen.dart';
import 'theme/pbx_pulse_theme.dart';

class PBXPulseApp extends StatefulWidget {
  const PBXPulseApp({this.repository, this.settings, super.key});

  final PulseRepository? repository;
  final PBXAppSettings? settings;

  @override
  State<PBXPulseApp> createState() => _PBXPulseAppState();
}

class _PBXPulseAppState extends State<PBXPulseApp> {
  late final PBXAppSettings _settings;
  late final PulseRepository _repository;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings ?? PBXAppSettings();
    _repository = widget.repository ?? MockPulseRepository();
    _settings.load();
  }

  @override
  void dispose() {
    if (widget.settings == null) {
      _settings.dispose();
    }
    if (widget.repository == null) {
      _repository.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _settings,
      builder: (context, _) {
        return MaterialApp(
          title: 'PBXPulse',
          debugShowCheckedModeBanner: false,
          theme: PBXPulseTheme.light(),
          darkTheme: PBXPulseTheme.dark(),
          themeMode: _settings.themeMode,
          home: _settings.onboardingComplete
              ? PBXPulseShell(
                  repository: _repository,
                  settings: _settings,
                )
              : OnboardingScreen(settings: _settings),
        );
      },
    );
  }
}
