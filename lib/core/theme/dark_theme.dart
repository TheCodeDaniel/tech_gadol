import 'package:flutter/material.dart';
import 'package:tech_gadol/core/theme/colors.dart';

class DarkTheme {
  static final ThemeData themeData = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryLight,
      primaryContainer: AppColors.primaryDark,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryDark,
      surface: AppColors.darkSurface,
      error: AppColors.error,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: AppColors.darkOnSurface,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkOnSurface,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkSurfaceVariant,
      selectedColor: AppColors.primaryLight,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      secondaryLabelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceVariant,
      hintStyle: const TextStyle(
        color: AppColors.darkOnSurfaceVariant,
        fontSize: 14,
      ),
      prefixIconColor: AppColors.darkOnSurfaceVariant,
      suffixIconColor: AppColors.darkOnSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkDivider,
      thickness: 1,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.darkOnSurface,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.darkOnSurface,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.darkOnSurface,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.darkOnSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.darkOnSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.darkOnSurface,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: AppColors.darkOnSurfaceVariant,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryLight,
      ),
    ),
  );
}
