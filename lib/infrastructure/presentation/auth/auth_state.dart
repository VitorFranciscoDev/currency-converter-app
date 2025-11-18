import 'dart:convert';
import 'package:currency_converter/domain/entities/user.dart';
import 'package:currency_converter/domain/usecases/auth_usecases.dart';
import 'package:currency_converter/infrastructure/models/user_model.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider({ required this.u }) { loadUser(); }
  final AuthUseCases u;

  static const userKey = "user";

  User? _user;
  User? get user => _user;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  void _setInitialized(bool initialized) {
    _isInitialized = initialized;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  String? _errorName;
  String? get errorName => _errorName;

  String? _errorEmail;
  String? get errorEmail => _errorEmail;

  String? _errorPassword;
  String? get errorPassword => _errorPassword;

  bool validateLoginFields(String email, String password) {
    _errorEmail = u.validateEmail(email);
    _errorPassword = u.validatePassword(password);

    notifyListeners();

    return _errorEmail == null && _errorPassword == null;
  }

  bool validateRegisterFields(String name, String email, String password) {
    _errorName = u.validateName(name);
    _errorEmail = u.validateEmail(email);
    _errorPassword = u.validatePassword(password);
    
    notifyListeners();

    return _errorName == null && _errorEmail == null && _errorPassword == null;
  }

  void clearErrors() {
    _errorName = null;
    _errorEmail = null;
    _errorPassword = null;

    notifyListeners();
  }

  Future<void> loadUser() async {
    _setInitialized(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(userKey);

      if(userData != null) {
        final userMap = jsonDecode(userData);
        _user = UserModel.fromJson(userMap);
      }
    } catch(e) {
      _user = null;
    } finally {
      _setInitialized(false);
    }
  }

  Future<User?> login(String email, String password) async {
    _setLoading(true);
    
    try {
      _user = await u.login(email, password);

      if(_user != null) {
        final userModel = UserModel(
          id: _user!.id, 
          name: _user!.name, 
          email: _user!.email, 
          password: _user!.password,
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(userKey, jsonEncode(userModel.toJson()));
      }

      return _user;
    } catch(e) {
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Get User By Email [Register Validation]
  Future<User?> getUserByEmail(String email) async {
    try {
      return u.getUserByEmail(email);
    } catch(e) {
      return null;
    }
  }

  // Add User in DB
  Future<int> addUser(User user) async {
    try {
      return u.addUser(user);
    } catch(e) {
      return 0;
    }
  }

  // Delete User from DB
  Future<int> deleteUser(int? id) async {
    try {
      return u.deleteUser(id);
    } catch(e) {
      return 0;
    }
  }

  // Update User from DB
  Future<int> updateUser(User user) async {
    try {
      return u.updateUser(user);
    } catch(e) {
      return 0;
    }
  }
}