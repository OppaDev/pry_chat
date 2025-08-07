import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_palette.dart';

// --- Estilos de Texto Tema Oscuro (Moderno) ---
TextTheme buildDarkTextTheme() {
  return TextTheme(
    displayLarge: GoogleFonts.inter(fontSize: 52, fontWeight: FontWeight.bold, color: modernDarkText, letterSpacing: -1.5),
    displayMedium: GoogleFonts.inter(fontSize: 42, fontWeight: FontWeight.bold, color: modernDarkText, letterSpacing: -1.0),
    displaySmall: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: modernDarkText),
    headlineLarge: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w600, color: modernDarkText),
    headlineMedium: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: modernDarkText),
    headlineSmall: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: modernDarkText),
    titleLarge: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: modernDarkText),
    titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: modernDarkText),
    titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: modernDarkText),
    bodyLarge: GoogleFonts.inter(fontSize: 16, color: modernDarkText, height: 1.5),
    bodyMedium: GoogleFonts.inter(fontSize: 14, color: modernDarkSecondaryText, height: 1.5),
    bodySmall: GoogleFonts.inter(fontSize: 12, color: modernDarkSecondaryText, height: 1.4),
    labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5), // Para botones
    labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: modernDarkText),
    labelSmall: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w400, color: modernDarkSecondaryText, letterSpacing: 0.5),
  ).apply(
    bodyColor: modernDarkText,
    displayColor: modernDarkText,
  );
}

// --- Estilos de Texto Tema Claro (Moderno) ---
TextTheme buildLightTextTheme() {
  return TextTheme(
    displayLarge: GoogleFonts.inter(fontSize: 52, fontWeight: FontWeight.bold, color: modernLightText, letterSpacing: -1.5),
    displayMedium: GoogleFonts.inter(fontSize: 42, fontWeight: FontWeight.bold, color: modernLightText, letterSpacing: -1.0),
    displaySmall: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: modernLightText),
    headlineLarge: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w600, color: modernLightText),
    headlineMedium: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: modernLightText),
    headlineSmall: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: modernLightText),
    titleLarge: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: modernLightText),
    titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: modernLightText),
    titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: modernLightText),
    bodyLarge: GoogleFonts.inter(fontSize: 16, color: modernLightText, height: 1.5),
    bodyMedium: GoogleFonts.inter(fontSize: 14, color: modernLightSecondaryText, height: 1.5),
    bodySmall: GoogleFonts.inter(fontSize: 12, color: modernLightSecondaryText, height: 1.4),
    labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5), // Para botones
    labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: modernLightText),
    labelSmall: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w400, color: modernLightSecondaryText, letterSpacing: 0.5),
  ).apply(
    bodyColor: modernLightText,
    displayColor: modernLightText,
  );
}

// Helper para el logo (puedes personalizarlo más)
Widget buildModernLogo(bool isDarkMode, {double size = 24}) {
  return Text(
    "PRYTEMAS",
    style: GoogleFonts.orbitron( // Una fuente futurista para el logo
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: isDarkMode ? modernDarkPrimary : modernLightPrimary,
      letterSpacing: 1.5,
    ),
  );
}