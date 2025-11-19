import 'package:currency_converter/core/constants/default.dart';
import 'package:currency_converter/core/constants/shared_preferences_keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider to manage the Theme in the Application
class ThemeProvider with ChangeNotifier {
  // Constructor [Initializes Theme]
  ThemeProvider() {
    _initializeTheme();
  }

  // Current Theme
  ThemeMode _currentThemeMode = Default.defaultThemeMode;
  ThemeMode get currentThemeMode => _currentThemeMode;

  // Is Initialized Boolean
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Is Loading Boolean
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Initializes Theme
  Future<void> _initializeTheme() async {
    _setInitialized(true);

    try {
      final savedThemeMode = await _loadThemeModeFromStorage();
      _setThemeMode(savedThemeMode ?? Default.defaultThemeMode);
    } catch (error) {
      debugPrint('Error loading theme: $error');
      _setThemeMode(Default.defaultThemeMode);
    } finally {
      _setInitialized(false);
    }
  }

  // Load Theme Mode
  Future<ThemeMode?> _loadThemeModeFromStorage() async {
    final preferences = await SharedPreferences.getInstance();
    final isDark = preferences.getBool(SharedPreferencesKeys.themeStorageKey);

    if (isDark == null) {
      return null;
    }

    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  // Save Theme
  Future<void> _saveThemeModeToStorage(ThemeMode mode) async {
    final preferences = await SharedPreferences.getInstance();
    final isDark = mode == ThemeMode.dark;
    await preferences.setBool(SharedPreferencesKeys.themeStorageKey, isDark);
  }

  // Toggle Theme
  Future<void> toggleTheme(bool mode) async {
    final newThemeMode = mode ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newThemeMode);
  }

  // Set Theme
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

  // Setters
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