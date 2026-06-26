import 'package:flutter/material.dart';

class PBXColors {
  const PBXColors._();

  static const background = Color(0xFF07110E);
  static const lightBackground = Color(0xFFF7FBF5);
  static const surface = Color(0xFF0C1915);
  static const lightSurface = Color(0xFFFFFFFF);
  static const card = Color(0xFF10231D);
  static const lightCard = Color(0xFFFFFFFF);
  static const cardSoft = Color(0xFF152D26);
  static const lightCardSoft = Color(0xFFE8F3EC);
  static const pulseGreen = Color(0xFF75D49B);
  static const deepGreen = Color(0xFF245B3A);
  static const mint = Color(0xFFA8E6C1);
  static const amber = Color(0xFFE8C978);
  static const blue = Color(0xFF8CB9FF);
  static const attention = Color(0xFFFF9E8F);
  static const textPrimary = Color(0xFFF2F8F4);
  static const textSecondary = Color(0xFFC6D5CE);
  static const textMuted = Color(0xFF8FA39A);
  static const lightTextPrimary = Color(0xFF13201A);
  static const lightTextSecondary = Color(0xFF40564A);
  static const lightTextMuted = Color(0xFF6E8177);
  static const divider = Color(0xFF1F352E);
  static const lightDivider = Color(0xFFD6E4DC);
}

extension PBXColorScheme on BuildContext {
  bool get isLight => Theme.of(this).brightness == Brightness.light;

  Color get pbxCardSoft =>
      isLight ? PBXColors.lightCardSoft : PBXColors.cardSoft;

  Color get pbxTextSecondary =>
      isLight ? PBXColors.lightTextSecondary : PBXColors.textSecondary;

  Color get pbxTextMuted =>
      isLight ? PBXColors.lightTextMuted : PBXColors.textMuted;

  Color get pbxDivider => isLight ? PBXColors.lightDivider : PBXColors.divider;

  Color get pbxAccent => isLight ? PBXColors.deepGreen : PBXColors.pulseGreen;
}
