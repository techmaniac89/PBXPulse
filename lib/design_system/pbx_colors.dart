import 'package:flutter/material.dart';

class PBXColors {
  const PBXColors._();

  static const background = Color(0xFF07110E);
  static const lightBackground = Color(0xFFF7FBF5);
  static const cozyBackground = Color(0xFFFFF7EA);
  static const cozyDarkBackground = Color(0xFF18120D);
  static const surface = Color(0xFF0C1915);
  static const lightSurface = Color(0xFFFFFFFF);
  static const cozySurface = Color(0xFFFFFBF2);
  static const cozyDarkSurface = Color(0xFF221912);
  static const card = Color(0xFF10231D);
  static const lightCard = Color(0xFFFFFFFF);
  static const cozyCard = Color(0xFFFFFCF6);
  static const cozyDarkCard = Color(0xFF2A2017);
  static const cardSoft = Color(0xFF152D26);
  static const lightCardSoft = Color(0xFFE8F3EC);
  static const cozyCardSoft = Color(0xFFF4E8D3);
  static const cozyDarkCardSoft = Color(0xFF3A2B1E);
  static const pulseGreen = Color(0xFF75D49B);
  static const deepGreen = Color(0xFF245B3A);
  static const cozySage = Color(0xFF6E8F69);
  static const cozyDarkSage = Color(0xFFA8C995);
  static const mint = Color(0xFFA8E6C1);
  static const amber = Color(0xFFE8C978);
  static const cozyAmber = Color(0xFFE8B85F);
  static const blue = Color(0xFF8CB9FF);
  static const attention = Color(0xFFFF9E8F);
  static const cozyCoral = Color(0xFFE98573);
  static const textPrimary = Color(0xFFF2F8F4);
  static const textSecondary = Color(0xFFC6D5CE);
  static const textMuted = Color(0xFF8FA39A);
  static const lightTextPrimary = Color(0xFF13201A);
  static const lightTextSecondary = Color(0xFF40564A);
  static const lightTextMuted = Color(0xFF6E8177);
  static const cozyTextPrimary = Color(0xFF2C2218);
  static const cozyTextSecondary = Color(0xFF665242);
  static const cozyTextMuted = Color(0xFF927A61);
  static const cozyDarkTextPrimary = Color(0xFFFFF3E4);
  static const cozyDarkTextSecondary = Color(0xFFE1CDB4);
  static const cozyDarkTextMuted = Color(0xFFB0967B);
  static const divider = Color(0xFF1F352E);
  static const lightDivider = Color(0xFFD6E4DC);
  static const cozyDivider = Color(0xFFE9D7BB);
  static const cozyDarkDivider = Color(0xFF4B392A);
}

class PBXPalette extends ThemeExtension<PBXPalette> {
  const PBXPalette({
    required this.cardSoft,
    required this.textSecondary,
    required this.textMuted,
    required this.divider,
    required this.accent,
  });

  final Color cardSoft;
  final Color textSecondary;
  final Color textMuted;
  final Color divider;
  final Color accent;

  @override
  PBXPalette copyWith({
    Color? cardSoft,
    Color? textSecondary,
    Color? textMuted,
    Color? divider,
    Color? accent,
  }) {
    return PBXPalette(
      cardSoft: cardSoft ?? this.cardSoft,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      divider: divider ?? this.divider,
      accent: accent ?? this.accent,
    );
  }

  @override
  PBXPalette lerp(ThemeExtension<PBXPalette>? other, double t) {
    if (other is! PBXPalette) {
      return this;
    }

    return PBXPalette(
      cardSoft: Color.lerp(cardSoft, other.cardSoft, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }
}

extension PBXColorScheme on BuildContext {
  bool get isLight => Theme.of(this).brightness == Brightness.light;

  PBXPalette get _palette {
    final palette = Theme.of(this).extension<PBXPalette>();
    if (palette != null) {
      return palette;
    }

    return isLight
        ? const PBXPalette(
            cardSoft: PBXColors.lightCardSoft,
            textSecondary: PBXColors.lightTextSecondary,
            textMuted: PBXColors.lightTextMuted,
            divider: PBXColors.lightDivider,
            accent: PBXColors.deepGreen,
          )
        : const PBXPalette(
            cardSoft: PBXColors.cardSoft,
            textSecondary: PBXColors.textSecondary,
            textMuted: PBXColors.textMuted,
            divider: PBXColors.divider,
            accent: PBXColors.pulseGreen,
          );
  }

  Color get pbxCardSoft => _palette.cardSoft;

  Color get pbxTextSecondary => _palette.textSecondary;

  Color get pbxTextMuted => _palette.textMuted;

  Color get pbxDivider => _palette.divider;

  Color get pbxAccent => _palette.accent;
}
