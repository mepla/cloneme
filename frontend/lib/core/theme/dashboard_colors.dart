import 'package:flutter/material.dart';

class DashboardColors {
  // Primary brand colors
  static const Color primaryBlue = Color(0xFF2697FF);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF212332);
  static const Color sidebarDark = Color(0xFF2A2D3E);
  
  // Status and trend colors
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFF44336);
  static const Color neutralGray = Color(0xFF9E9E9E);
  
  // Card and surface colors
  static const Color cardBackground = Colors.white;
  static const Color cardShadow = Color(0x0D000000);
  static const Color dividerColor = Color(0xFFE0E0E0);

  // EverMynd brand colors (keeping existing brand)
  static const Color evermyndPrimary = Color(0xFF8C52FF);
  static const Color evermyndSecondary = Color(0xFF4D0F99);
}

class DashboardTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: DashboardColors.evermyndPrimary,
        secondary: DashboardColors.primaryBlue,
        surface: DashboardColors.cardBackground,
        surfaceContainerHighest: DashboardColors.sidebarDark,
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shadowColor: DashboardColors.cardShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: DashboardColors.evermyndPrimary,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}