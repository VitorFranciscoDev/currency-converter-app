import 'package:currency_converter/core/constants/default.dart';
import 'package:currency_converter/core/constants/shared_preferences_keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider to manage the Internalization of the Application
class IntlProvider extends ChangeNotifier {
  // Contructor (Load Intl Data)
  IntlProvider() {
    _initializeLanguage();
  }

  // Current Locale
  Locale _currentLocale = Default.defaultLocale;
  Locale get currentLocale => _currentLocale;

  // Is Initialized Boolean
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Is Loading Boolean
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Initializes the Language
  Future<void> _initializeLanguage() async {
    _setInitialized(true);

    try {
      final savedLocale = await _loadLocaleFromStorage();
      _setLocale(savedLocale ?? Default.defaultLocale);
    } catch (error) {
      debugPrint('Error loading language: $error');
      _setLocale(Default.defaultLocale);
    } finally {
      _setInitialized(false);
    }
  }

  // Load Locale
  Future<Locale?> _loadLocaleFromStorage() async {
    final preferences = await SharedPreferences.getInstance();
    final savedLanguageCode = preferences.getString(SharedPreferencesKeys.intlStorageKey);

    if (savedLanguageCode == null) {
      return null;
    }

    return _parseLocaleFromCode(savedLanguageCode);
  }

  // Save Locale
  Future<void> _saveLocaleToStorage(String languageCode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(SharedPreferencesKeys.intlStorageKey, languageCode);
  }

  // Change Language
  Future<void> changeLanguage(String languageCode) async {
    if (_currentLocale.languageCode == languageCode) {
      return;
    }

    _setLoading(true);

    try {
      final newLocale = _parseLocaleFromCode(languageCode);
      await _saveLocaleToStorage(languageCode);
      _setLocale(newLocale);
    } catch (error) {
      debugPrint('Error changing language: $error');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Setters
  void _setLocale(Locale locale) {
    _currentLocale = locale;
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

  // Code => Locale
  Locale _parseLocaleFromCode(String code) {
    switch (code.toLowerCase()) {
      case 'en':
        return const Locale('en', 'US');
      case 'pt':
        return const Locale('pt', 'BR');
      case 'es':
        return const Locale('es', 'ES');
      default:
        return Default.defaultLocale;
    }
  }
}