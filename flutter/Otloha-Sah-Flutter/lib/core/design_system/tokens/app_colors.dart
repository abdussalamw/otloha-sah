import 'package:flutter/material.dart';

/// AppColors defines the central color system (Design Tokens) for Otloha Sah.
/// Brand Identity: Royal Blue (#0056B3)
abstract class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF0056B3);
  static const Color primaryLight = Color(0xFFE7F1FF);
  static const Color primaryDark = Color(0xFF003366);
  static const Color accent = Color(0xFF00B8E6);

  // Background & Surface - Light Mode
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);

  // Background & Surface - Dark Mode
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF1E293B);

  // Status & Feedback Colors
  static const Color success = Color(0xFF28A745);
  static const Color error = Color(0xFFDC3545);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF17A2B8);

  // Neutral & Text Colors - Light Mode
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textMutedLight = Color(0xFF94A3B8);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color dividerLight = Color(0xFFCBD5E1);

  // Neutral & Text Colors - Dark Mode
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textMutedDark = Color(0xFF64748B);
  static const Color borderDark = Color(0xFF334155);
  static const Color dividerDark = Color(0xFF475569);

  // Quranic & Special Highlights
  static const Color quranGold = Color(0xFFD4AF37);
  static const Color quranGreen = Color(0xFF2E7D32);
  static const Color waveYellow = Color(0xFFFDD023);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0056B3), Color(0xFF00B8E6)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF003366), Color(0xFF0056B3)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
