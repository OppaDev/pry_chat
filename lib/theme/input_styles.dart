import 'package:flutter/material.dart';
import 'color_palette.dart';
// No necesitas text_styles.dart si el TextTheme se aplica globalmente

// --- Tema Oscuro: InputDecorationTheme (Moderno) ---
InputDecorationTheme modernDarkInputDecorationTheme(TextTheme textTheme) {
  return InputDecorationTheme(
    filled: true,
    fillColor: modernDarkSurface.withOpacity(0.7),
    hintStyle: textTheme.bodyMedium?.copyWith(color: modernDarkSecondaryText.withOpacity(0.7)),
    labelStyle: textTheme.bodyMedium?.copyWith(color: modernDarkSecondaryText),
    errorStyle: textTheme.bodySmall?.copyWith(color: modernDarkError),
    
    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide.none, // Sin borde visible por defecto, el fill color lo define
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: modernDarkSurface.withOpacity(0.5), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: modernDarkPrimary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: modernDarkError, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: modernDarkError, width: 2),
    ),
    prefixIconColor: modernDarkSecondaryText,
    suffixIconColor: modernDarkSecondaryText,
  );
}

// --- Tema Claro: InputDecorationTheme (Moderno) ---
InputDecorationTheme modernLightInputDecorationTheme(TextTheme textTheme) {
  return InputDecorationTheme(
    filled: true,
    fillColor: modernLightSurface.withOpacity(0.8), // Un poco de transparencia para ver el fondo degradado
    hintStyle: textTheme.bodyMedium?.copyWith(color: modernLightSecondaryText.withOpacity(0.7)),
    labelStyle: textTheme.bodyMedium?.copyWith(color: modernLightSecondaryText),
    errorStyle: textTheme.bodySmall?.copyWith(color: modernLightError),
    
    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: modernLightPrimary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: modernLightError, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: modernLightError, width: 2),
    ),
    prefixIconColor: modernLightSecondaryText,
    suffixIconColor: modernLightSecondaryText,
  );
}