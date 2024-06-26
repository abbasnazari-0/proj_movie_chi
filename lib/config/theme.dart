// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

ThemeData buildDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    primaryColor: const Color(0xFF242529),
    // backgroundColor: const Color(0xFF17191A),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xFF242529)),
    )),
    primaryTextTheme: const TextTheme(
        bodyMedium: TextStyle(
          color: Colors.white,
          fontFamily: 'vazir',
        ),
        displayMedium: TextStyle(
          color: Color(0xFF1F2B37),
          fontFamily: 'vazir',
        )),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    fontFamily: 'vazir',
    primaryIconTheme: const IconThemeData(
      color: Color(0xFFD664BE),
    ),
    colorScheme: const ColorScheme.dark(
      background: Color(0xFF17191A),
      secondary: Color(0xFFD664BE),
      primary: Color(0xFFFfffff),
    ).copyWith(secondary: const Color(0xFFD664BE)),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
    ),
  );
}

ThemeData buildLightTheme() {
  return ThemeData(
    useMaterial3: true,
    primaryColor: const Color(0xFFF9FBFC),
    // backgroundColor: const Color(0xFFFfffff),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'vazir',
    primaryTextTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Color(0xFF1F2B37),
        fontFamily: 'vazir',
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontFamily: 'vazir',
      ),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFF1F2B37),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStateProperty.all<Color>(const Color(0xFF1F2B37)),
      ),
    ),
    primaryIconTheme: const IconThemeData(
      color: Color(0xFF1F2B37),
    ),
    colorScheme: const ColorScheme.light(
      background: Color(0xFFFfffff),
      secondary: Color(0xFFD664BE),
      primary: Color(0xFFFfffff),
    ).copyWith(
      secondary: const Color(0xFFD664BE),
    ),
  );
}
