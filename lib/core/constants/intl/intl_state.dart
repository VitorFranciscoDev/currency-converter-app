import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntlProvider extends ChangeNotifier {
  IntlProvider() { loadLanguage(); }

  static const String _languageKey = 'selected_language';

  Locale _locale = const Locale('en', 'US');
  Locale get locale => _locale;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadLanguage() async {
    _isInitialized = false;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey);
      
      if (savedLanguage != null) {
        _locale = _getLocaleFromCode(savedLanguage);
      }
    } catch (e) {
      throw Exception("Error in Load Language Provider: $e");
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> setLanguage(String languageCode) async {
    _locale = _getLocaleFromCode(languageCode);
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
    } catch(e) {
      throw Exception("Error in Set Language Provider: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Locale _getLocaleFromCode(String code) {
    switch (code) {
      case 'en':
        return const Locale('en', 'US');
      case 'pt':
        return const Locale('pt', 'BR');
      case 'es':
        return const Locale('es', 'ES');
      default:
        return const Locale('en', 'US');
    }
  }
}