import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Night-sky palette: deep indigo with a warm star-gold accent.
class ThaaraColors {
  static const night = Color(0xFF0F0C24);
  static const dusk = Color(0xFF1C1740);
  static const plum = Color(0xFF2E2560);
  static const gold = Color(0xFFE8C07A);
  static const goldSoft = Color(0xFFF3DDB0);
  static const mist = Color(0xFFC9C3E6);
  static const rose = Color(0xFFE59A9A);
}

ThemeData buildTheme(Locale locale) {
  final isMalayalam = locale.languageCode == 'ml';

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ThaaraColors.gold,
      brightness: Brightness.dark,
      surface: ThaaraColors.dusk,
      primary: ThaaraColors.gold,
      onPrimary: ThaaraColors.night,
      secondary: ThaaraColors.mist,
      error: ThaaraColors.rose,
    ),
    scaffoldBackgroundColor: ThaaraColors.night,
  );

  // Malayalam needs a font with full Malayalam glyph coverage everywhere;
  // English uses a serif for headings and a soft sans for body text.
  final body = isMalayalam
      ? GoogleFonts.notoSansMalayalamTextTheme(base.textTheme)
      : GoogleFonts.nunitoSansTextTheme(base.textTheme);

  TextStyle? heading(TextStyle? s) => isMalayalam
      ? GoogleFonts.notoSansMalayalam(textStyle: s, fontWeight: FontWeight.w600)
      : GoogleFonts.cormorantGaramond(textStyle: s, fontWeight: FontWeight.w600);

  final textTheme = body
      .copyWith(
        displaySmall: heading(body.displaySmall),
        headlineMedium: heading(body.headlineMedium),
        headlineSmall: heading(body.headlineSmall),
        titleLarge: heading(body.titleLarge),
      )
      .apply(bodyColor: ThaaraColors.goldSoft, displayColor: ThaaraColors.goldSoft);

  return base.copyWith(
    textTheme: textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: ThaaraColors.dusk,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        foregroundColor: ThaaraColors.goldSoft,
        side: const BorderSide(color: ThaaraColors.plum, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ThaaraColors.dusk,
      hintStyle: TextStyle(color: ThaaraColors.mist.withValues(alpha: 0.6)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: ThaaraColors.gold),
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: ThaaraColors.dusk,
      indicatorColor: ThaaraColors.plum,
    ),
  );
}
