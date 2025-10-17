import 'package:flutter/material.dart';

class AppTextTheme {
  static const String fontFamily = 'Pretendard';
  
  // Tailwind CSS Typography Scale
  static const TextTheme lightTextTheme = TextTheme(
    // Display styles (Tailwind text-6xl to text-9xl equivalent)
    displayLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 72, // text-7xl
      fontWeight: FontWeight.w800, // font-extrabold
      height: 1.0,
      letterSpacing: -0.025,
    ),
    displayMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 60, // text-6xl
      fontWeight: FontWeight.w800,
      height: 1.0,
    ),
    displaySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 48, // text-5xl
      fontWeight: FontWeight.w700, // font-bold
      height: 1.0,
    ),
    
    // Headline styles (Tailwind text-2xl to text-4xl)
    headlineLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 36, // text-4xl
      fontWeight: FontWeight.w700,
      height: 1.1,
      letterSpacing: -0.025,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 30, // text-3xl
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.025,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 24, // text-2xl
      fontWeight: FontWeight.w600, // font-semibold
      height: 1.33,
    ),
    
    // Title styles (Tailwind text-lg to text-xl)
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 20, // text-xl
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 18, // text-lg
      fontWeight: FontWeight.w600,
      height: 1.44,
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16, // text-base
      fontWeight: FontWeight.w500, // font-medium
      height: 1.5,
    ),
    
    // Body styles (Tailwind text-sm to text-base)
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16, // text-base
      fontWeight: FontWeight.w400, // font-normal
      height: 1.6,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14, // text-sm
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12, // text-xs
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    
    // Label styles (Tailwind text-xs to text-sm)
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14, // text-sm
      fontWeight: FontWeight.w500,
      height: 1.43,
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12, // text-xs
      fontWeight: FontWeight.w500,
      height: 1.33,
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 10, // text-xs (small)
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
  );
  
  static const TextTheme darkTextTheme = lightTextTheme;
  
  // Verse card specific styles with Tailwind-inspired design
  static const TextStyle verseText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15, // 15px as requested
    fontWeight: FontWeight.w600, // font-semibold
    height: 1.4,
    color: Colors.white,
    shadows: [
      Shadow(
        offset: Offset(0, 2),
        blurRadius: 8,
        color: Colors.black38,
      ),
    ],
  );
  
  static const TextStyle verseReference = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14, // text-sm
    fontWeight: FontWeight.w500, // font-medium
    height: 1.4,
    color: Colors.white70,
    shadows: [
      Shadow(
        offset: Offset(0, 1),
        blurRadius: 4,
        color: Colors.black26,
      ),
    ],
  );
}

