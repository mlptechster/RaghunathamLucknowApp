import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // ------------------------------
  // BRAND COLORS (Refined)
  // ------------------------------
  static const Color primary = Color(0xFF0A1A3B); // Deeper royal navy
  static const Color primaryDark = Color(0xFF050B1A);
  static const Color primaryLight = Color(0xFF1E3A8A);

  static const Color accentGold = Color(0xFFD4AF37);     // premium gold
  static const Color accentGoldLight = Color(0xFFEAD27A);
  static const Color accentGoldDark = Color(0xFFB08A22);

  // -----------------------------------
  // BACKGROUND COLORS (Luxury Surfaces)
  // -----------------------------------
  static const Color background = Color(0xFFF8F7F4); // off-white luxury
  static const Color surface = Color(0xFFFFFFFF);     // clean white
  static const Color surfaceDark = Color(0xFFF1F1F1);

  // -----------------------------------
  // TEXT COLORS
  // -----------------------------------
  static const Color textPrimary = Color(0xFF0D1B2A); // deep ink
  static const Color textSecondary = Color(0xFF4B5563); 
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textWhite = Colors.white;

  // -----------------------------------
  // SHADOWS (Luxury subtle)
  // -----------------------------------
  static const Color shadow = Color(0x11000000);
  static const Color shadowStrong = Color(0x22000000);

  // -----------------------------------
  // OVERLAYS
  // -----------------------------------
  static const Color overlayLight = Color(0x22FFFFFF);
  static const Color overlayDark = Color(0x33000000);

  // -----------------------------------
  // GRADIENTS (Brand Gradient)
  // -----------------------------------
  static const Gradient royalGoldGradient = LinearGradient(
    colors: [
      Color(0xFF0A1A3B),
      Color(0xFFD4AF37),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ------------------------------
// TYPOGRAPHY SYSTEM
// ------------------------------

/// Regal heading style
final TextStyle headingStyle = GoogleFonts.playfairDisplay(
  color: AppColors.textPrimary,
  fontSize: 32,
  height: 1.2,
  fontWeight: FontWeight.w700,
);

/// Gold heading (for sections)
final TextStyle goldHeadingStyle = GoogleFonts.playfairDisplay(
  color: AppColors.accentGold,
  fontSize: 32,
  height: 1.2,
  fontWeight: FontWeight.bold,
);

/// Body text
final TextStyle bodyText = GoogleFonts.inter(
  color: AppColors.textSecondary,
  fontSize: 16,
);

/// Light muted text
final TextStyle captionText = GoogleFonts.inter(
  color: AppColors.textMuted,
  fontSize: 13,
);
