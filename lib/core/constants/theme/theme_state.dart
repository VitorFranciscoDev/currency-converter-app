import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider() { loadTheme(); }

  static const String themeKey = "theme_mode";

  ThemeMode themeMode = ThemeMode.light;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadTheme() async {
    _isInitialized = false;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final darkTheme = prefs.getBool(themeKey) ?? false;
      
      themeMode = darkTheme ? ThemeMode.dark : ThemeMode.light;
    } catch (e) {
      throw Exception("Error in Load Theme Provider: $e");
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> toggleTheme(bool darkTheme) async {
    themeMode = darkTheme ? ThemeMode.dark : ThemeMode.light;
    _isLoading = true;
    notifyListeners();

    try {
      await saveTheme(darkTheme);
    } catch(e) {
      throw Exception("Error in Toggle Theme Provider: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveTheme(bool darkTheme) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(themeKey, darkTheme);
    } catch(e) {
      throw Exception("Error in Save Theme Provider: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}