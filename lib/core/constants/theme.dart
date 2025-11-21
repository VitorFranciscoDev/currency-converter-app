import 'package:flutter/material.dart';

// Theme

// Light Theme
final lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: const Color.fromARGB(255, 36, 16, 185),
    secondary: const Color.fromARGB(150, 36, 16, 185),
    background: Colors.white,
  ),
);

// Dark Theme
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF64B5F6),
    secondary: Color(0xFF4FC3F7),
    background: Color(0xFF121212),
  ),
);