import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: 'Montserrat',
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFAB011)),
  scaffoldBackgroundColor: Colors.white,
  bottomNavigationBarTheme: bottomNavBarTheme,
);

class AppColors {
  const AppColors._();

  static Color get yellow => const Color(0xFFFAB011);
  static Color get green => const Color(0xFF19BF6B);
  static Color get blue => const Color(0xFF4CD7DE);
  static Color get grey => const Color(0xFF7B7979);
  static Color get inactiveGrey => const Color(0xFFE4E4E4);
  static Color get whiteBackground => const Color(0xFFFFFFFF);
  static Color get purple => const Color(0xFF7A67D0);
}

BottomNavigationBarThemeData bottomNavBarTheme = BottomNavigationBarThemeData(
  backgroundColor: AppColors.whiteBackground,
  selectedLabelStyle: const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  ),
  unselectedLabelStyle: const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  ),
  selectedItemColor: AppColors.yellow,
  unselectedItemColor: AppColors.grey,
  type: BottomNavigationBarType.fixed,
);

// ColorScheme scheme = ColorScheme(
//   brightness: Brightness.light,
//   primary: AppColors.yellow,
//   onPrimary: onPrimary,
//   secondary: secondary,
//   onSecondary: onSecondary,
//   error: error,
//   onError: onError,
//   background: Color(0xFFFFFFFF),
//   onBackground: onBackground,
//   surface: surface,
//   onSurface: onSurface,
// );
