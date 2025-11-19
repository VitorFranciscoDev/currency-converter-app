import 'package:currency_converter/core/constants/shared_preferences_keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider to manage the Internalization of the Application
class IntlProvider extends ChangeNotifier {

  // Contructor (Load Intl Data)
  IntlProvider() {
    _initializeLanguage();
  }

  // Default Locale (English)
  static const Locale _defaultLocale = Locale('en', 'US');

  // Current Locale
  Locale _currentLocale = _defaultLocale;
  Locale get currentLocale => _currentLocale;

  // Is Initialized Boolean
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Is Loading Boolean
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Supported Locales by the Application
  List<Locale> get supportedLocales => const [
    Locale('en', 'US'),
    Locale('pt', 'BR'),
    Locale('es', 'ES'),
  ];

  // Supported Locales Codes
  List<String> get supportedLanguageCodes => ['en', 'pt', 'es'];

  // Current Language Code Getter
  String get currentLanguageCode {
    return _currentLocale.languageCode;
  }

  // Getter to Name of Current Language
  String get currentLanguageName {
    switch (_currentLocale.languageCode) {
      case 'en':
        return 'English';
      case 'pt':
        return 'Português';
      case 'es':
        return 'Español';
      default:
        return 'English';
    }
  }

  // bool to Language Supported
  bool isLanguageSupported(String languageCode) {
    return supportedLanguageCodes.contains(languageCode);
  }

  // Initializes the Language
  Future<void> _initializeLanguage() async {
    _setInitialized(true);

    try {
      final savedLocale = await _loadLocaleFromStorage();
      _setLocale(savedLocale ?? _defaultLocale);
    } catch (error) {
      debugPrint('Error loading language: $error');
      _setLocale(_defaultLocale);
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
    if (!isLanguageSupported(languageCode)) {
      throw Exception("Unsupported Language.");
    }

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
        return _defaultLocale;
    }
  }
}