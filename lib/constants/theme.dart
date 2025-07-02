import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  textTheme: TextTheme(),
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
  cardColor: const Color(0xffFEF3E2),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xffFA812F), // Set progress indicator color to match the theme
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white, // Light mode bottom sheet background
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  cardColor: const Color(0xff333333),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xffFA812F), // Set progress indicator color to match the theme
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xff121212), // Dark mode bottom sheet background
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  ),
);
