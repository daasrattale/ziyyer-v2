import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────
//  COLOR TOKENS
// ─────────────────────────────────────────
class AppColors {
  AppColors._();

  // Brand / Accent
  static const accentDark = Color.fromARGB(255, 68, 207, 203); // Dark Royal Blue
  static const accentLight = Color.fromARGB(255, 61, 187, 183); // Light Royal Blue

  // Balance card gradient
  static const gradientStart = Color(0xFF00C9A7);
  static const gradientEnd = Color(0xFF3A9BD5);

  // Semantic
  static const income = Color(0xFF00E5A0); // +green
  static const expense = Color(0xFFFF4757); // -red
  static const warning = Color(0xFFFFB830);
  static const info = Color(0xFF3A9BD5);

  // ── Dark palette ──────────────────────
  static const darkBackground = Color(0xFF0A0E1A);
  static const darkSurface = Color(0xFF141829);
  static const darkCard = Color(0xFF1A1F35);
  static const darkCardAlt = Color(0xFF1E2438);
  static const darkDivider = Color(0xFF252B42);
  static const darkTextPrimary = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xFF8892A4);
  static const darkTextHint = Color(0xFF4E5A6E);
  static const darkNavBarBg = Color(0xFF10141F);

  // ── Light palette ─────────────────────
  static const lightBackground = Color(0xFFF0F4FA);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightCardAlt = Color(0xFFEEF3FB);
  static const lightDivider = Color(0xFFDDE3EE);
  static const lightTextPrimary = Color(0xFF0A0E1A);
  static const lightTextSecondary = Color(0xFF5A6478);
  static const lightTextHint = Color(0xFF9AA3B2);
  static const lightNavBarBg = Color(0xFFFFFFFF);

  // ── Theme-aware color getters ────────
  static Color getColor(BuildContext context, {required Color light, required Color dark}) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? dark : light;
  }

  static Color accent(BuildContext context) => getColor(context, light: accentLight, dark: accentDark);

  static Color background(BuildContext context) => getColor(context, light: lightBackground, dark: darkBackground);

  static Color surface(BuildContext context) => getColor(context, light: lightSurface, dark: darkSurface);

  static Color card(BuildContext context) => getColor(context, light: lightCard, dark: darkCard);

  static Color cardAlt(BuildContext context) => getColor(context, light: lightCardAlt, dark: darkCardAlt);

  static Color divider(BuildContext context) => getColor(context, light: lightDivider, dark: darkDivider);

  static Color textPrimary(BuildContext context) => getColor(context, light: lightTextPrimary, dark: darkTextPrimary);

  static Color textSecondary(BuildContext context) => getColor(context, light: lightTextSecondary, dark: darkTextSecondary);

  static Color textHint(BuildContext context) => getColor(context, light: lightTextHint, dark: darkTextHint);

  static Color navBarBg(BuildContext context) => getColor(context, light: lightNavBarBg, dark: darkNavBarBg);

  // ── App-specific colors ───────────────
  static Color accentColor(BuildContext context) => getColor(context, light: accentLight, dark: accentDark);

  static Color accentLightColor(BuildContext context) => accentLight; // Same in both themes

  static Color incomeColor(BuildContext context) => income; // Semantic colors stay the same

  static Color expenseColor(BuildContext context) => expense; // Semantic colors stay the same

  static Color warningColor(BuildContext context) => warning; // Semantic colors stay the same

  static Color infoColor(BuildContext context) => info; // Semantic colors stay the same

  static Color gradientStartColor(BuildContext context) => gradientStart; // Same in both themes

  static Color gradientEndColor(BuildContext context) => gradientEnd; // Same in both themes
}

// ─────────────────────────────────────────
//  TYPOGRAPHY
// ─────────────────────────────────────────
class AppTextStyles {
  AppTextStyles._();

  static TextTheme textTheme(Color primary, Color secondary) => GoogleFonts.interTextTheme().copyWith(
    // Display — e.g. balance amount "$12,580.00"
    displayLarge: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w700, color: primary, letterSpacing: -1.0),
    displayMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: primary, letterSpacing: -0.8),
    displaySmall: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: primary, letterSpacing: -0.5),

    // Headlines — section titles
    headlineLarge: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: primary),
    headlineMedium: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: primary),
    headlineSmall: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: primary),

    // Body — transaction names, descriptions
    bodyLarge: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: primary),
    bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: primary),
    bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: secondary),

    // Labels — timestamps, hints, nav labels
    labelLarge: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: primary, letterSpacing: 0.1),
    labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: secondary),
    labelSmall: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: secondary, letterSpacing: 0.5),
  );
}

// ─────────────────────────────────────────
//  THEME BUILDER
// ─────────────────────────────────────────
class AppTheme {
  AppTheme._();

  // ── DARK ──────────────────────────────
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentDark,
        onPrimary: AppColors.darkBackground,
        primaryContainer: AppColors.darkCard,
        secondary: AppColors.accentDark,
        onSecondary: AppColors.darkBackground,
        tertiary: AppColors.info,
        error: AppColors.expense,
        onError: Colors.white,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        surfaceContainerHighest: AppColors.darkCardAlt,
        outline: AppColors.darkDivider,
      ),

      textTheme: AppTextStyles.textTheme(AppColors.darkTextPrimary, AppColors.darkTextSecondary),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkNavBarBg,
        indicatorColor: AppColors.accentDark.withAlpha(15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.accentDark, size: 24);
          }
          return const IconThemeData(color: AppColors.darkTextSecondary, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.accentDark);
          }
          return GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.darkTextSecondary);
        }),
        elevation: 0,
      ),

      dividerTheme: const DividerThemeData(color: AppColors.darkDivider, thickness: 1, space: 1),

      iconTheme: const IconThemeData(color: AppColors.darkTextSecondary, size: 22),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: AppColors.accentDark, foregroundColor: AppColors.darkBackground),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentDark,
          foregroundColor: AppColors.darkBackground,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // ── LIGHT ─────────────────────────────
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,

      colorScheme: const ColorScheme.light(
        primary: AppColors.accentLight,
        onPrimary: Colors.white,
        primaryContainer: AppColors.lightCardAlt,
        secondary: AppColors.accentLight,
        onSecondary: Colors.white,
        tertiary: AppColors.info,
        error: AppColors.expense,
        onError: Colors.white,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,
        surfaceContainerHighest: AppColors.lightCardAlt,
        outline: AppColors.lightDivider,
      ),

      textTheme: AppTextStyles.textTheme(AppColors.lightTextPrimary, AppColors.lightTextSecondary),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightNavBarBg,
        indicatorColor: AppColors.accentLight.withAlpha(12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.accentLight, size: 24);
          }
          return const IconThemeData(color: AppColors.lightTextSecondary, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.accentLight);
          }
          return GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.lightTextSecondary);
        }),
        elevation: 0,
      ),

      dividerTheme: const DividerThemeData(color: AppColors.lightDivider, thickness: 1, space: 1),

      iconTheme: const IconThemeData(color: AppColors.lightTextSecondary, size: 22),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: AppColors.accentLight, foregroundColor: Colors.white),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentLight,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  static CupertinoThemeData get cupertinoLight {
    return CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.accentLight,
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: const CupertinoTextThemeData(primaryColor: CupertinoColors.black),
    );
  }

  static CupertinoThemeData get cupertinoDark {
    return CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.accentLight,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: const CupertinoTextThemeData(primaryColor: CupertinoColors.white),
    );
  }
}
