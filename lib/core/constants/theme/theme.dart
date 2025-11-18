import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: const Color(0xFF2196F3),
    secondary: const Color(0xFF03A9F4),
    background: const Color(0xFFFFFFFF),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF64B5F6),
    secondary: Color(0xFF4FC3F7),
    background: Color(0xFF121212),
  ),
);