import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color accent = Color(0xFFF43F5E);

  // Surfaces
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Borders & dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFCBD5E1);

  // Semantic
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Feature gradients
  static const List<Color> lengthGradient = [Color(0xFF4F46E5), Color(0xFF7C3AED)];
  static const List<Color> compareGradient = [Color(0xFFF43F5E), Color(0xFFF97316)];
  static const List<Color> planGradient = [Color(0xFF0D9488), Color(0xFF06B6D4)];

  // Auth background
  static const List<Color> authGradient = [Color(0xFF312E81), Color(0xFF4F46E5)];
}

/// Kept for backward compatibility with existing references.
class Pallete {
  static const Color mainFontColor = AppColors.textPrimary;
  static const Color firstSuggestionBoxColor = Color(0xFF4F46E5);
  static const Color secondSuggestionBoxColor = Color(0xFFF43F5E);
  static const Color thirdSuggestionBoxColor = Color(0xFF0D9488);
  static const Color assistantCircleColor = AppColors.surfaceVariant;
  static const Color borderColor = AppColors.border;
  static const Color blackColor = AppColors.textPrimary;
  static const Color whiteColor = AppColors.surface;
}
