import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color_palette.dart';
// No necesitas text_styles.dart si el TextTheme se aplica globalmente

// --- Tema Oscuro: Estilos de Layout (Moderno) ---
AppBarTheme modernDarkAppBarTheme(TextTheme textTheme) {
  return AppBarTheme(
    elevation: 0,
    // backgroundColor: Colors.transparent, // Para permitir que el degradado del Scaffold se vea
    backgroundColor: modernDarkSurface, // O un color sólido si prefieres
    foregroundColor: modernDarkText,
    iconTheme: IconThemeData(color: modernDarkText, size: 26),
    actionsIconTheme: IconThemeData(color: modernDarkText, size: 26),
    titleTextStyle: textTheme.titleLarge,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    centerTitle: true,
  );
}

CardTheme modernDarkCardTheme() {
  return CardTheme(
    elevation: 6,
    // color: Colors.transparent, // Para el degradado
    color: modernDarkSurface, // Color base si no hay degradado
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    shadowColor: Colors.black.withOpacity(0.4),
  );
}

SnackBarThemeData modernDarkSnackBarTheme(TextTheme textTheme) {
  return SnackBarThemeData(
    backgroundColor: darkNotificationBackground,
    contentTextStyle: textTheme.bodyMedium?.copyWith(color: darkNotificationText, fontWeight: FontWeight.w600),
    actionTextColor: favGold, // Usar un color de acento para la acción
    elevation: 6,
    behavior: SnackBarBehavior.floating, // Estilo moderno flotante
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    // width: 300, // Opcional: si quieres un ancho fijo
  );
}

// --- Tema Claro: Estilos de Layout (Moderno) ---
AppBarTheme modernLightAppBarTheme(TextTheme textTheme) {
  return AppBarTheme(
    elevation: 0,
    // backgroundColor: Colors.transparent,
    backgroundColor: modernLightSurface,
    foregroundColor: modernLightText,
    iconTheme: IconThemeData(color: modernLightText, size: 26),
    actionsIconTheme: IconThemeData(color: modernLightText, size: 26),
    titleTextStyle: textTheme.titleLarge,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    centerTitle: true,
  );
}

CardTheme modernLightCardTheme() {
  return CardTheme(
    elevation: 5,
    // color: Colors.transparent, // Para el degradado
    color: modernLightSurface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    shadowColor: Colors.grey.shade300,
  );
}

SnackBarThemeData modernLightSnackBarTheme(TextTheme textTheme) {
  return SnackBarThemeData(
    backgroundColor: lightNotificationBackground,
    contentTextStyle: textTheme.bodyMedium?.copyWith(color: lightNotificationText, fontWeight: FontWeight.w600),
    actionTextColor: favGold,
    elevation: 6,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
}