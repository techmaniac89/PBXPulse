import 'package:flutter/material.dart';

import '../../design_system/pbx_colors.dart';

class PBXPulseTheme {
  const PBXPulseTheme._();

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: PBXColors.deepGreen,
      brightness: Brightness.light,
      surface: PBXColors.lightSurface,
    );

    return _base(
      brightness: Brightness.light,
      scheme: scheme.copyWith(
        primary: PBXColors.deepGreen,
        secondary: PBXColors.pulseGreen,
        surface: PBXColors.lightSurface,
        surfaceContainerHighest: PBXColors.lightCard,
        error: PBXColors.attention,
      ),
      scaffoldBackgroundColor: PBXColors.lightBackground,
      cardColor: PBXColors.lightCard,
      navBackground: PBXColors.lightSurface,
      selectedLabel: PBXColors.lightTextPrimary,
      unselectedLabel: PBXColors.lightTextMuted,
      textPrimary: PBXColors.lightTextPrimary,
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: PBXColors.pulseGreen,
      brightness: Brightness.dark,
      surface: PBXColors.surface,
    );

    return _base(
      brightness: Brightness.dark,
      scheme: scheme.copyWith(
        primary: PBXColors.pulseGreen,
        secondary: PBXColors.mint,
        surface: PBXColors.surface,
        surfaceContainerHighest: PBXColors.card,
        error: PBXColors.attention,
      ),
      scaffoldBackgroundColor: PBXColors.background,
      cardColor: PBXColors.card,
      navBackground: PBXColors.surface,
      selectedLabel: PBXColors.textPrimary,
      unselectedLabel: PBXColors.textMuted,
      textPrimary: PBXColors.textPrimary,
    );
  }

  static ThemeData _base({
    required Brightness brightness,
    required ColorScheme scheme,
    required Color scaffoldBackgroundColor,
    required Color cardColor,
    required Color navBackground,
    required Color selectedLabel,
    required Color unselectedLabel,
    required Color textPrimary,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: navBackground,
        indicatorColor: scheme.primary.withValues(alpha: 0.16),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? selectedLabel
                : unselectedLabel,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 30,
          height: 1.12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          height: 1.2,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          height: 1.25,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        bodyLarge: TextStyle(fontSize: 16, height: 1.45, letterSpacing: 0),
        bodyMedium: TextStyle(fontSize: 14, height: 1.4, letterSpacing: 0),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ).apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
    );
  }
}
