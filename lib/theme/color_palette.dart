import 'package:flutter/material.dart';

// =======================================================================
// NUEVA PALETA DE COLORES PERSONALIZADA
// =======================================================================

const Color azulVibrante = Color(0xFF21B9C5); // Color principal / botones destacados
const Color grisClaro = Color(0xFF7E7E7E); // Texto secundario / íconos  
const Color verdeLimonClaro = Color(0xFFDBE5A8); // Fondo suave / tarjetas
const Color grisCaldoClaro = Color(0xFFC9C9B3); // Fondo general / secciones
const Color verdeMenta = Color(0xFF46D4B4); // Elementos de acción secundaria / acentos

// Colores principales basados en la nueva paleta
const Color harmonicCore = azulVibrante; // Azul vibrante como color principal
const Color harmonicWarm = verdeMenta; // Verde menta para elementos cálidos
const Color harmonicCool = verdeLimonClaro; // Verde limón para frescura
const Color harmonicAnalogCool = grisClaro; // Gris claro para elementos secundarios
const Color harmonicAnalogWarm = grisCaldoClaro; // Gris cálido para fondos

// =======================================================================
// PALETA DE NEUTRALES HARMÓNICOS
// =======================================================================

const Color harmonicNeutralDeep = Color(
  0xFF0F172A,
); // Marino profundo (base oscura)
const Color harmonicNeutralMid = Color(0xFF475569); // Gris slate (punto medio)
const Color harmonicNeutralSoft = Color(0xFF94A3B8); // Gris suave (transición)
const Color harmonicNeutralLight = Color(
  0xFFF8FAFC,
); // Perla luminosa (base clara)

// =======================================================================
// COLORES SEMÁNTICOS CON HARMONY EQUILIBRADA
// =======================================================================

const Color harmonicSuccess = harmonicCool; // Verde esmeralda - éxito natural
const Color harmonicWarning = harmonicWarm; // Coral - advertencia cálida
const Color harmonicError = Color(0xFFDC2626); // Rojo coral - error equilibrado
const Color harmonicInfo = harmonicAnalogWarm; // Azul cielo - información clara

// =======================================================================
// TEMA OSCURO MODERNO CON HARMONY CROMÁTICA
// =======================================================================

const Color modernDarkBackground = Color(0xFF0A0F1C); // Negro azulado profundo
const Color modernDarkSurface = Color(0xFF1E293B); // Superficie slate oscura
const Color modernDarkElevated = Color(0xFF334155); // Elevación sutil
const Color modernDarkPrimary = harmonicCore; // Azul profundo principal
const Color modernDarkSecondary = harmonicAnalogCool; // Violeta elegante
const Color modernDarkAccent = harmonicWarm; // Coral vibrante para acentos
const Color modernDarkTertiary =
    harmonicAnalogWarm; // Azul cielo para variaciones

// Texto con hierarchy equilibrada
const Color modernDarkText = Color(0xFFF1F5F9); // Texto principal luminoso
const Color modernDarkSecondaryText = Color(
  0xFFCBD5E1,
); // Texto secundario suave
const Color modernDarkMutedText = Color(0xFF94A3B8); // Texto silenciado

// Estados semánticos equilibrados
const Color modernDarkSuccess = harmonicSuccess; // Verde esmeralda
const Color modernDarkWarning = harmonicWarning; // Coral anaranjado
const Color modernDarkError = harmonicError; // Rojo coral
const Color modernDarkInfo = harmonicInfo; // Azul cielo

// =======================================================================
// TEMA CLARO MODERNO CON NUEVA PALETA PERSONALIZADA
// =======================================================================

const Color modernLightBackground = grisCaldoClaro; // Gris cálido claro como fondo general
const Color modernLightSurface = Color(0xFFFFFFFF); // Superficie pura
const Color modernLightElevated = verdeLimonClaro; // Verde limón para elevación
const Color modernLightPrimary = azulVibrante; // Azul vibrante como principal
const Color modernLightSecondary = verdeMenta; // Verde menta como secundario
const Color modernLightAccent = verdeMenta; // Verde menta para acentos
const Color modernLightTertiary = verdeLimonClaro; // Verde limón para variaciones

// Texto con contraste óptimo usando nueva paleta
const Color modernLightText = Color(0xFF2D2D2D); // Texto principal oscuro
const Color modernLightSecondaryText = grisClaro; // Gris claro para texto secundario
const Color modernLightMutedText = Color(0xFF9E9E9E); // Texto silenciado más claro

// Estados semánticos con contraste adecuado
const Color modernLightSuccess = Color(0xFF047857); // Verde esmeralda oscuro
const Color modernLightWarning = Color(0xFFEA580C); // Coral más oscuro
const Color modernLightError = Color(0xFFB91C1C); // Rojo profundo
const Color modernLightInfo = Color(0xFF0E7490); // Azul cielo oscuro

// =======================================================================
// GRADIENTES HARMÓNICOS MODERNOS
// =======================================================================

final LinearGradient darkGradientBackground = LinearGradient(
  colors: [harmonicNeutralDeep, Color(0xFF1E293B).withOpacity(0.95)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final LinearGradient darkCardGradient = LinearGradient(
  colors: [modernDarkSurface, modernDarkTertiary.withOpacity(0.05)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final LinearGradient lightGradientBackground = LinearGradient(
  colors: [modernLightBackground, harmonicNeutralLight],
  begin: Alignment.topLeft,
  end: Alignment.centerRight,
);

final LinearGradient lightCardGradient = LinearGradient(
  colors: [modernLightSurface, modernLightElevated],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Gradientes de botones con harmony cromática
final LinearGradient primaryGradientDark = LinearGradient(
  colors: [modernDarkPrimary, modernDarkSecondary],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final LinearGradient primaryGradientLight = LinearGradient(
  colors: [modernLightPrimary, modernLightSecondary],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final LinearGradient accentGradientDark = LinearGradient(
  colors: [modernDarkAccent, modernDarkTertiary],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final LinearGradient accentGradientLight = LinearGradient(
  colors: [modernLightAccent, modernLightTertiary],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// =======================================================================
// COLORES DE NOTIFICACIONES Y RETROALIMENTACIÓN
// =======================================================================

const Color darkNotificationBackground = modernDarkAccent;
const Color darkNotificationText = Colors.white;
const Color darkNotificationSuccess = modernDarkSuccess;
const Color darkNotificationWarning = modernDarkWarning;
const Color darkNotificationError = modernDarkError;
const Color darkNotificationInfo = modernDarkInfo;

const Color lightNotificationBackground = modernLightAccent;
const Color lightNotificationText = Colors.white;
const Color lightNotificationSuccess = modernLightSuccess;
const Color lightNotificationWarning = modernLightWarning;
const Color lightNotificationError = modernLightError;
const Color lightNotificationInfo = modernLightInfo;

// =======================================================================
// COLORES DE INTERACCIÓN Y ESTADOS
// =======================================================================

final Color darkHoverOverlay = modernDarkPrimary.withOpacity(0.08);
final Color lightHoverOverlay = modernLightPrimary.withOpacity(0.06);

final Color darkFocusColor = modernDarkSecondary;
final Color lightFocusColor = modernLightPrimary;

final Color darkPressedOverlay = modernDarkPrimary.withOpacity(0.12);
final Color lightPressedOverlay = modernLightPrimary.withOpacity(0.10);

final Color darkDisabledColor = modernDarkSecondaryText.withOpacity(0.4);
final Color lightDisabledColor = modernLightSecondaryText.withOpacity(0.5);

// =======================================================================
// COLORES SEMÁNTICOS ESPECÍFICOS
// =======================================================================

const Color semanticSuccessDark = modernDarkSuccess;
const Color semanticSuccessLight = modernLightSuccess;
const Color semanticWarningDark = modernDarkWarning;
const Color semanticWarningLight = modernLightWarning;
const Color semanticErrorDark = modernDarkError;
const Color semanticErrorLight = modernLightError;
const Color semanticInfoDark = modernDarkInfo;
const Color semanticInfoLight = modernLightInfo;

// =======================================================================
// COLORES FAVORITOS REBALANCEADOS (HARMÓNICOS)
// =======================================================================

// Deep Sky Blue rebalanceado para harmony cromática
const Color rebalancedDeepSkyBlue = harmonicAnalogWarm; // Azul cielo harmónico

// Blue Violet rebalanceado con nueva saturación equilibrada
const Color rebalancedBlueViolet = harmonicAnalogCool; // Violeta harmónico

// Hot Pink rebalanceado como coral armónico
const Color rebalancedHotPink = harmonicWarm; // Coral harmónico

// Gold rebalanceado como ámbar equilibrado
const Color rebalancedGold = Color(0xFFF59E0B); // Ámbar harmónico

// Referencias favoritas para compatibilidad
const Color favDeepSkyBlue = rebalancedDeepSkyBlue;
const Color favBlueViolet = rebalancedBlueViolet;
const Color favHotPink = rebalancedHotPink;
const Color favGold = rebalancedGold;

// =======================================================================
// VERSIONES HARMÓNICAS DE LOS COLORES FAVORITOS
// =======================================================================

// Versiones claras y oscuras para mejor adaptabilidad
const Color harmonicPrimaryLight = Color(0xFF818CF8); // Índigo más claro
const Color harmonicPrimaryDark = Color(0xFF4338CA); // Índigo más oscuro
const Color harmonicSecondaryLight = Color(0xFF22D3EE); // Cyan más claro
const Color harmonicSecondaryDark = Color(0xFF0E7490); // Cyan más oscuro
const Color harmonicTertiaryLight = Color(0xFF34D399); // Esmeralda más claro
const Color harmonicTertiaryDark = Color(0xFF047857); // Esmeralda más oscuro
const Color harmonicAccentLight = Color(0xFFFBBF24); // Ámbar más claro
const Color harmonicAccentDark = Color(0xFFD97706); // Ámbar más oscuro

// =======================================================================
// GRADIENTES HERO Y DESTACADOS
// =======================================================================

final LinearGradient heroGradientDark = LinearGradient(
  colors: [modernDarkPrimary, modernDarkSecondary, modernDarkTertiary],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final LinearGradient heroGradientLight = LinearGradient(
  colors: [modernLightPrimary, modernLightSecondary, modernLightTertiary],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// =======================================================================
// CONFIGURACIÓN ESPECÍFICA DE LA APP
// =======================================================================

const Color appPrimaryBlue = harmonicCore;
const Color appLightBlue = Color(0xFF60A5FA);
const Color appDarkBlue = Color(0xFF2563EB);
