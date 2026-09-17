import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF74C69D);
  static const Color primaryDeep = Color(0xFF40916C);
  static const Color primaryDark = Color(0xFF1B4332);
  static const Color primarySoft = Color(0xFF95D5B2);

  static const Color secondary = Color(0xFFF2CC8F);
  static const Color secondaryDeep = Color(0xFFB7791F);

  static const Color accent = Color(0xFF52B788);
  static const Color accentLight = Color(0xFF95D5B2);

  static const Color background = Color(0xFF0B1F14);
  static const Color backgroundAlt = Color(0xFF14281D);
  static const Color surface = Color(0xFF1A3A2A);

  static const Color textPrimary = Color(0xFFE8F5E9);
  static const Color textSecondary = Color(0xFFA3B18A);
  static const Color border = Color(0xFF2D4A3A);

  static Color glass = Colors.white.withValues(alpha: 0.10);
  static Color glassStrong = Colors.white.withValues(alpha: 0.16);
  static Color glassBorder = Colors.white.withValues(alpha: 0.18);
  static Color glassBorderStrong = Colors.white.withValues(alpha: 0.28);

  static Color glowPrimary = primary.withValues(alpha: 0.55);
  static Color glowSecondary = secondary.withValues(alpha: 0.5);
  static Color glowAccent = accent.withValues(alpha: 0.5);
  static Color fireflyGlow = secondary.withValues(alpha: 0.6);

  static const Color success = Color(0xFF74C69D);
  static const Color error = Color(0xFFE57373);
  static const Color warning = Color(0xFFF2CC8F);
  static const Color info = Color(0xFF64B5F6);

  static const Color readingTag = Color(0xFF52B788);
  static const Color wantToReadTag = Color(0xFFF2CC8F);
  static const Color finishedTag = Color(0xFF95D5B2);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [background, backgroundAlt],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B4332), Color(0xFF74C69D)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB7791F), Color(0xFFF2CC8F)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF52B788), Color(0xFF95D5B2)],
  );
}