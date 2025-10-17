import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'text_theme.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary600,
        secondary: AppColors.slate600,
        surface: AppColors.background,
      ),
      textTheme: AppTextTheme.lightTextTheme,
      fontFamily: AppTextTheme.fontFamily,
      
      // AppBar theme - Tailwind-inspired
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.slate900,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppColors.slate200,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: AppTextTheme.fontFamily,
          fontSize: 20, // text-xl
          fontWeight: FontWeight.w600, // font-semibold
          color: AppColors.slate900,
        ),
        // Tailwind-style border
        shape: const Border(
          bottom: BorderSide(
            color: AppColors.slate200,
            width: 1,
          ),
        ),
      ),
      
      // Bottom navigation theme - Tailwind-inspired
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary600,
        unselectedItemColor: AppColors.slate400,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontFamily: AppTextTheme.fontFamily,
          fontSize: 12, // text-xs
          fontWeight: FontWeight.w500, // font-medium
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: AppTextTheme.fontFamily,
          fontSize: 12, // text-xs
          fontWeight: FontWeight.w400, // font-normal
        ),
      ),
      
      // Card theme - Tailwind shadow-lg inspired
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // rounded-xl
          side: const BorderSide(
            color: AppColors.slate200,
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // Button themes - Tailwind-inspired
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary600,
          foregroundColor: AppColors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // rounded-lg
          ),
          textStyle: const TextStyle(
            fontFamily: AppTextTheme.fontFamily,
            fontSize: 14, // text-sm
            fontWeight: FontWeight.w500, // font-medium
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // px-4 py-3
          minimumSize: const Size(0, 44),
        ).copyWith(
          // Hover and focus states
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return AppColors.primary700;
              }
              if (states.contains(WidgetState.pressed)) {
                return AppColors.primary700;
              }
              return null;
            },
          ),
        ),
      ),
      
      // Text button - Tailwind link style
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary600,
          textStyle: const TextStyle(
            fontFamily: AppTextTheme.fontFamily,
            fontSize: 14, // text-sm
            fontWeight: FontWeight.w500, // font-medium
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), // rounded-md
          ),
        ),
      ),
      
      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.slate700,
          backgroundColor: AppColors.white,
          side: const BorderSide(color: AppColors.slate300, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // rounded-lg
          ),
          textStyle: const TextStyle(
            fontFamily: AppTextTheme.fontFamily,
            fontSize: 14, // text-sm
            fontWeight: FontWeight.w500, // font-medium
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          minimumSize: const Size(0, 44),
        ),
      ),
      
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.slate600,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // rounded-lg
          ),
        ),
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary500,
        secondary: AppColors.slate400,
        surface: AppColors.backgroundDark,
      ),
      textTheme: AppTextTheme.darkTextTheme,
      fontFamily: AppTextTheme.fontFamily,
      
      // AppBar theme - Dark mode Tailwind-inspired
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.slate900,
        foregroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppColors.slate800,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: AppTextTheme.fontFamily,
          fontSize: 20, // text-xl
          fontWeight: FontWeight.w600, // font-semibold
          color: AppColors.white,
        ),
        // Tailwind-style border for dark mode
        shape: const Border(
          bottom: BorderSide(
            color: AppColors.slate800,
            width: 1,
          ),
        ),
      ),
      
      // Bottom navigation theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.slate900,
        selectedItemColor: AppColors.primary500,
        unselectedItemColor: AppColors.slate400,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontFamily: AppTextTheme.fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: AppTextTheme.fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.slate800,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // rounded-xl
          side: const BorderSide(
            color: AppColors.slate700,
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary600,
          foregroundColor: AppColors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: AppTextTheme.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary500,
          textStyle: const TextStyle(
            fontFamily: AppTextTheme.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.slate300,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
