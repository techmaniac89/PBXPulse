import 'package:flutter/material.dart';

import '../../design_system/pbx_colors.dart';

class PBXPulseTheme {
  const PBXPulseTheme._();

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: PBXColors.cozySage,
      brightness: Brightness.light,
      surface: PBXColors.cozySurface,
    );

    return _base(
      brightness: Brightness.light,
      scheme: scheme.copyWith(
        primary: PBXColors.cozySage,
        secondary: PBXColors.cozyCoral,
        tertiary: PBXColors.cozyAmber,
        surface: PBXColors.cozySurface,
        surfaceContainerHighest: PBXColors.cozyCard,
        error: PBXColors.cozyCoral,
      ),
      scaffoldBackgroundColor: PBXColors.cozyBackground,
      cardColor: PBXColors.cozyCard,
      navBackground: PBXColors.cozySurface,
      selectedLabel: PBXColors.cozyTextPrimary,
      unselectedLabel: PBXColors.cozyTextMuted,
      textPrimary: PBXColors.cozyTextPrimary,
      palette: const PBXPalette(
        cardSoft: PBXColors.cozyCardSoft,
        textSecondary: PBXColors.cozyTextSecondary,
        textMuted: PBXColors.cozyTextMuted,
        divider: PBXColors.cozyDivider,
        accent: PBXColors.cozyCoral,
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: PBXColors.cozyDarkSage,
      brightness: Brightness.dark,
      surface: PBXColors.cozyDarkSurface,
    );

    return _base(
      brightness: Brightness.dark,
      scheme: scheme.copyWith(
        primary: PBXColors.cozyDarkSage,
        secondary: PBXColors.cozyCoral,
        tertiary: PBXColors.cozyAmber,
        surface: PBXColors.cozyDarkSurface,
        surfaceContainerHighest: PBXColors.cozyDarkCard,
        error: PBXColors.cozyCoral,
      ),
      scaffoldBackgroundColor: PBXColors.cozyDarkBackground,
      cardColor: PBXColors.cozyDarkCard,
      navBackground: PBXColors.cozyDarkSurface,
      selectedLabel: PBXColors.cozyDarkTextPrimary,
      unselectedLabel: PBXColors.cozyDarkTextMuted,
      textPrimary: PBXColors.cozyDarkTextPrimary,
      palette: const PBXPalette(
        cardSoft: PBXColors.cozyDarkCardSoft,
        textSecondary: PBXColors.cozyDarkTextSecondary,
        textMuted: PBXColors.cozyDarkTextMuted,
        divider: PBXColors.cozyDarkDivider,
        accent: PBXColors.cozyCoral,
      ),
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
    required PBXPalette palette,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      extensions: [palette],
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
