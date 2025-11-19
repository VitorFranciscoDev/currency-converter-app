import 'dart:convert';
import 'package:currency_converter/core/constants/shared_preferences_keys.dart';
import 'package:currency_converter/domain/entities/user.dart';
import 'package:currency_converter/domain/usecases/auth_usecases.dart';
import 'package:currency_converter/infrastructure/models/user_model.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider to manage authentication and user state.
class AuthProvider with ChangeNotifier {
  AuthProvider({required AuthUseCases authUseCases}) 
      : _authUseCases = authUseCases {
    _initializeUser();
  }

  final AuthUseCases _authUseCases;

  User? _user;
  User? get user => _user;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorName;
  String? get errorName => _errorName;

  String? _errorEmail;
  String? get errorEmail => _errorEmail;

  String? _errorPassword;
  String? get errorPassword => _errorPassword;

  bool get hasValidationErrors => 
      _errorName != null || _errorEmail != null || _errorPassword != null;

  void _setInitialized(bool initialized) {
    _isInitialized = initialized;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> _initializeUser() async {
    _setInitialized(true);

    try {
      final user = await _loadUserFromStorage();
      _setUser(user);
    } catch (error) {
      _setUser(null);
    } finally {
      _setInitialized(false);
    }
  }

  Future<User?> _loadUserFromStorage() async {
    final preferences = await SharedPreferences.getInstance();
    final userJson = preferences.getString(SharedPreferencesKeys.userStorageKey);

    if (userJson == null) {
      return null;
    }

    final userMap = jsonDecode(userJson) as Map<String, dynamic>;
    return UserModel.fromJson(userMap);
  }

  Future<void> _saveUserToStorage(User user) async {
    final userModel = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
    );

    final preferences = await SharedPreferences.getInstance();
    final userJson = jsonEncode(userModel.toJson());
    await preferences.setString(SharedPreferencesKeys.userStorageKey, userJson);
  }

  Future<void> _clearUserFromStorage() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(SharedPreferencesKeys.userStorageKey);
  }

  bool validateLoginFields(String email, String password) {
    _errorEmail = _authUseCases.validateEmail(email);
    _errorPassword = _authUseCases.validatePassword(password);

    notifyListeners();

    return !hasValidationErrors;
  }

  bool validateRegisterFields(String name, String email, String password) {
    _errorName = _authUseCases.validateName(name);
    _errorEmail = _authUseCases.validateEmail(email);
    _errorPassword = _authUseCases.validatePassword(password);

    notifyListeners();

    return !hasValidationErrors;
  }

  void clearValidationErrors() {
    _errorName = null;
    _errorEmail = null;
    _errorPassword = null;

    notifyListeners();
  }

  Future<User?> login(String email, String password) async {
    _setLoading(true);

    try {
      final user = await _authUseCases.login(email, password);

      if (user != null) {
        await _saveUserToStorage(user);
        _setUser(user);
      }

      return user;
    } catch (error) {
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _clearUserFromStorage();
    _setUser(null);
    clearValidationErrors();
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      return await _authUseCases.getUserByEmail(email);
    } catch (error) {
      // TODO: Handle error appropriately
      return null;
    }
  }

  Future<int> registerUser(User user) async {
    _setLoading(true);

    try {
      final userId = await _authUseCases.addUser(user);
      
      if (userId > 0) {
        final registeredUser = User(
          id: userId,
          name: user.name,
          email: user.email,
          password: user.password,
        );
        
        await _saveUserToStorage(registeredUser);
        _setUser(registeredUser);
      }

      return userId;
    } catch (error) {
      return 0;
    } finally {
      _setLoading(false);
    }
  }

  Future<int> updateUser(User user) async {
    _setLoading(true);

    try {
      final rowsAffected = await _authUseCases.updateUser(user);

      if (rowsAffected > 0) {
        await _saveUserToStorage(user);
        _setUser(user);
      }

      return rowsAffected;
    } catch (error) {
      return 0;
    } finally {
      _setLoading(false);
    }
  }

  Future<int> deleteUser(int? id) async {
    if (id == null) {
      return 0;
    }

    _setLoading(true);

    try {
      final rowsAffected = await _authUseCases.deleteUser(id);

      if (rowsAffected > 0 && _user?.id == id) {
        await logout();
      }

      return rowsAffected;
    } catch (error) {
      return 0;
    } finally {
      _setLoading(false);
    }
  }
}