import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider() {
    _initializeTheme();
  }

  static const String _themeStorageKey = "theme_mode";
  static const ThemeMode _defaultThemeMode = ThemeMode.light;

  ThemeMode _currentThemeMode = _defaultThemeMode;
  ThemeMode get currentThemeMode => _currentThemeMode;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isDarkMode => _currentThemeMode == ThemeMode.dark;
  bool get isLightMode => _currentThemeMode == ThemeMode.light;
  bool get isSystemMode => _currentThemeMode == ThemeMode.system;

  String get currentThemeName {
    switch (_currentThemeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  IconData get currentThemeIcon {
    switch (_currentThemeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  Future<void> _initializeTheme() async {
    _setInitialized(true);

    try {
      final savedThemeMode = await _loadThemeModeFromStorage();
      _setThemeMode(savedThemeMode ?? _defaultThemeMode);
    } catch (error) {
      debugPrint('Error loading theme: $error');
      _setThemeMode(_defaultThemeMode);
    } finally {
      _setInitialized(false);
    }
  }

  Future<ThemeMode?> _loadThemeModeFromStorage() async {
    final preferences = await SharedPreferences.getInstance();
    final isDark = preferences.getBool(_themeStorageKey);

    if (isDark == null) {
      return null;
    }

    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> _saveThemeModeToStorage(ThemeMode mode) async {
    final preferences = await SharedPreferences.getInstance();
    final isDark = mode == ThemeMode.dark;
    await preferences.setBool(_themeStorageKey, isDark);
  }

  Future<void> toggleTheme() async {
    final newThemeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newThemeMode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_currentThemeMode == mode) {
      return;
    }

    _setLoading(true);

    try {
      await _saveThemeModeToStorage(mode);
      _setThemeMode(mode);
    } catch (error) {
      debugPrint('Error changing theme: $error');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }

  Future<void> resetToDefault() async {
    await setThemeMode(_defaultThemeMode);
  }

  void _setThemeMode(ThemeMode mode) {
    _currentThemeMode = mode;
    notifyListeners();
  }

  void _setInitialized(bool initialized) {
    _isInitialized = initialized;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}