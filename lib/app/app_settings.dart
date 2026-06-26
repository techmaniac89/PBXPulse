import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PBXAppSettings extends ChangeNotifier {
  static const _themeModeKey = 'pbxpulse.themeMode';
  static const _onboardingCompleteKey = 'pbxpulse.onboardingComplete';
  static const _meaningfulNotificationsKey = 'pbxpulse.meaningfulNotifications';
  static const _quietMomentsKey = 'pbxpulse.quietMoments';
  static const _localOnlyModeKey = 'pbxpulse.localOnlyMode';

  PBXAppSettings({bool onboardingComplete = false})
      : _onboardingComplete = onboardingComplete;

  var _themeMode = ThemeMode.dark;
  var _onboardingComplete = false;
  var _meaningfulNotifications = true;
  var _quietMoments = true;
  var _localOnlyMode = true;

  ThemeMode get themeMode => _themeMode;

  bool get onboardingComplete => _onboardingComplete;

  bool get meaningfulNotifications => _meaningfulNotifications;

  bool get quietMoments => _quietMoments;

  bool get localOnlyMode => _localOnlyMode;

  String get themeLabel {
    return switch (_themeMode) {
      ThemeMode.dark => 'Dark',
      ThemeMode.light => 'Light',
      ThemeMode.system => 'System',
    };
  }

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final storedValue = preferences.getString(_themeModeKey);
    final storedOnboardingComplete =
        preferences.getBool(_onboardingCompleteKey);
    final storedMeaningfulNotifications =
        preferences.getBool(_meaningfulNotificationsKey);
    final storedQuietMoments = preferences.getBool(_quietMomentsKey);
    final storedLocalOnlyMode = preferences.getBool(_localOnlyModeKey);
    final storedMode = switch (storedValue) {
      'light' => ThemeMode.light,
      'system' => ThemeMode.system,
      'dark' => ThemeMode.dark,
      _ => null,
    };

    var changed = false;

    if (storedMode != null && storedMode != _themeMode) {
      _themeMode = storedMode;
      changed = true;
    }

    if (storedOnboardingComplete != null &&
        storedOnboardingComplete != _onboardingComplete) {
      _onboardingComplete = storedOnboardingComplete;
      changed = true;
    }

    if (storedMeaningfulNotifications != null &&
        storedMeaningfulNotifications != _meaningfulNotifications) {
      _meaningfulNotifications = storedMeaningfulNotifications;
      changed = true;
    }

    if (storedQuietMoments != null && storedQuietMoments != _quietMoments) {
      _quietMoments = storedQuietMoments;
      changed = true;
    }

    if (storedLocalOnlyMode != null && storedLocalOnlyMode != _localOnlyMode) {
      _localOnlyMode = storedLocalOnlyMode;
      changed = true;
    }

    if (changed) {
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) {
      return;
    }

    _themeMode = mode;
    notifyListeners();
    await _saveThemeMode(mode);
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _themeModeKey,
      switch (mode) {
        ThemeMode.dark => 'dark',
        ThemeMode.light => 'light',
        ThemeMode.system => 'system',
      },
    );
  }

  Future<void> completeOnboarding() async {
    if (_onboardingComplete) {
      return;
    }

    _onboardingComplete = true;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_onboardingCompleteKey, true);
  }

  Future<void> setMeaningfulNotifications(bool value) async {
    if (_meaningfulNotifications == value) {
      return;
    }

    _meaningfulNotifications = value;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_meaningfulNotificationsKey, value);
  }

  Future<void> setQuietMoments(bool value) async {
    if (_quietMoments == value) {
      return;
    }

    _quietMoments = value;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_quietMomentsKey, value);
  }

  Future<void> setLocalOnlyMode(bool value) async {
    if (_localOnlyMode == value) {
      return;
    }

    _localOnlyMode = value;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_localOnlyModeKey, value);
  }

  Future<void> resetGenesisDemo() async {
    _themeMode = ThemeMode.dark;
    _onboardingComplete = false;
    _meaningfulNotifications = true;
    _quietMoments = true;
    _localOnlyMode = true;
    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_themeModeKey);
    await preferences.remove(_onboardingCompleteKey);
    await preferences.remove(_meaningfulNotificationsKey);
    await preferences.remove(_quietMomentsKey);
    await preferences.remove(_localOnlyModeKey);
  }
}
