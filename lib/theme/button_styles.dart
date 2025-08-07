import 'package:flutter/material.dart';
import 'color_palette.dart';
// No necesitas text_styles.dart aquí si defines el textStyle directamente

// --- Estilos de Botones Tema Oscuro (Moderno) ---
ElevatedButtonThemeData modernDarkElevatedButtonTheme(TextTheme textTheme) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: modernDarkPrimary,
      foregroundColor: Colors.white,
      textStyle: textTheme.labelLarge,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4,
      shadowColor: modernDarkPrimary.withOpacity(0.3),
    ),
  );
}

OutlinedButtonThemeData modernDarkOutlinedButtonTheme(TextTheme textTheme) {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: modernDarkSecondary,
      side: BorderSide(color: modernDarkSecondary, width: 1.5),
      textStyle: textTheme.labelLarge?.copyWith(color: modernDarkSecondary),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    ),
  );
}

TextButtonThemeData modernDarkTextButtonTheme(TextTheme textTheme) {
  return TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: modernDarkAccent,
      textStyle: textTheme.labelLarge?.copyWith(
        color: modernDarkAccent,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ),
  );
}

FloatingActionButtonThemeData modernDarkFloatingActionButtonTheme() {
  return FloatingActionButtonThemeData(
    backgroundColor: modernDarkAccent,
    foregroundColor: Colors.white,
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    splashColor: Colors.white.withOpacity(0.2),
  );
}

// --- Estilos de Botones Tema Claro (Moderno) ---
ElevatedButtonThemeData modernLightElevatedButtonTheme(TextTheme textTheme) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: modernLightPrimary,
      foregroundColor: Colors.white,
      textStyle: textTheme.labelLarge,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 3,
      shadowColor: modernLightPrimary.withOpacity(0.4),
    ),
  );
}

OutlinedButtonThemeData modernLightOutlinedButtonTheme(TextTheme textTheme) {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: modernLightSecondary,
      side: BorderSide(color: modernLightSecondary, width: 1.5),
      textStyle: textTheme.labelLarge?.copyWith(color: modernLightSecondary),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    ),
  );
}

TextButtonThemeData modernLightTextButtonTheme(TextTheme textTheme) {
  return TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: modernLightAccent,
      textStyle: textTheme.labelLarge?.copyWith(
        color: modernLightAccent,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ),
  );
}

FloatingActionButtonThemeData modernLightFloatingActionButtonTheme() {
  return FloatingActionButtonThemeData(
    backgroundColor: modernLightAccent,
    foregroundColor: Colors.white,
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    splashColor: Colors.black.withOpacity(0.1),
  );
}
