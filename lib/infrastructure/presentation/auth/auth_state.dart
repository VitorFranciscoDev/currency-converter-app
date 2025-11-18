import 'dart:convert';
import 'package:currency_converter/core/constants/shared_preferences_keys.dart';
import 'package:currency_converter/domain/entities/user.dart';
import 'package:currency_converter/domain/usecases/auth_usecases.dart';
import 'package:currency_converter/infrastructure/models/user_model.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider responsible for managing authentication and user state.
/// 
/// Manages:
/// - Authentication state (login/logout)
/// - User data persistence
/// - Form validation
/// - Loading and initialization states
class AuthProvider with ChangeNotifier {
  AuthProvider({required AuthUseCases authUseCases}) 
      : _authUseCases = authUseCases {
    _initializeUser();
  }

  // ==================== DEPENDENCIES ====================
  
  /// Authentication use cases (domain layer)
  final AuthUseCases _authUseCases;

  // ==================== USER STATE ====================
  
  /// Currently authenticated user
  User? _user;
  User? get user => _user;

  /// Indicates whether the user is authenticated
  bool get isAuthenticated => _user != null;

  // ==================== LOADING STATES ====================
  
  /// Indicates whether the app has been initialized (loaded persisted data)
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Indicates whether there is an ongoing operation (login, register, etc)
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ==================== VALIDATION ERRORS ====================
  
  /// Error message for the name field
  String? _errorName;
  String? get errorName => _errorName;

  /// Error message for the email field
  String? _errorEmail;
  String? get errorEmail => _errorEmail;

  /// Error message for the password field
  String? _errorPassword;
  String? get errorPassword => _errorPassword;

  /// Indicates whether there are any validation errors present
  bool get hasValidationErrors => 
      _errorName != null || _errorEmail != null || _errorPassword != null;

  // ==================== PRIVATE STATE CONTROL METHODS ====================
  
  /// Updates the initialization state and notifies listeners
  void _setInitialized(bool initialized) {
    _isInitialized = initialized;
    notifyListeners();
  }

  /// Updates the loading state and notifies listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Sets the current user and notifies listeners
  void _setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  // ==================== INITIALIZATION ====================
  
  /// Initializes the provider by loading persisted user data
  Future<void> _initializeUser() async {
    _setInitialized(true);

    try {
      final user = await _loadUserFromStorage();
      _setUser(user);
    } catch (error) {
      // Error logging could be added here
      _setUser(null);
    } finally {
      _setInitialized(false);
    }
  }

  /// Loads user data from local storage
  /// 
  /// Returns: User if found, null otherwise
  /// Throws: Exception if there is an error decoding the data
  Future<User?> _loadUserFromStorage() async {
    final preferences = await SharedPreferences.getInstance();
    final userJson = preferences.getString(SharedPreferencesKeys.userStorageKey);

    if (userJson == null) {
      return null;
    }

    final userMap = jsonDecode(userJson) as Map<String, dynamic>;
    return UserModel.fromJson(userMap);
  }

  /// Persists user data to local storage
  /// 
  /// [user] User to be persisted
  /// Throws: Exception if there is an error saving
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

  /// Removes user data from local storage
  Future<void> _clearUserFromStorage() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(SharedPreferencesKeys.userStorageKey);
  }

  // ==================== FORM VALIDATION ====================
  
  /// Validates login form fields
  /// 
  /// [email] Email to be validated
  /// [password] Password to be validated
  /// 
  /// Returns: true if all fields are valid, false otherwise
  bool validateLoginFields(String email, String password) {
    _errorEmail = _authUseCases.validateEmail(email);
    _errorPassword = _authUseCases.validatePassword(password);

    notifyListeners();

    return !hasValidationErrors;
  }

  /// Validates registration form fields
  /// 
  /// [name] Name to be validated
  /// [email] Email to be validated
  /// [password] Password to be validated
  /// 
  /// Returns: true if all fields are valid, false otherwise
  bool validateRegisterFields(String name, String email, String password) {
    _errorName = _authUseCases.validateName(name);
    _errorEmail = _authUseCases.validateEmail(email);
    _errorPassword = _authUseCases.validatePassword(password);

    notifyListeners();

    return !hasValidationErrors;
  }

  /// Clears all validation error messages
  void clearValidationErrors() {
    _errorName = null;
    _errorEmail = null;
    _errorPassword = null;

    notifyListeners();
  }

  // ==================== AUTHENTICATION ====================
  
  /// Performs user login
  /// 
  /// [email] User's email
  /// [password] User's password
  /// 
  /// Returns: User if login successful, null otherwise
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
      // TODO: Implement specific error handling
      // Custom exceptions can be thrown here
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Performs user logout
  /// 
  /// Clears local state and removes persisted data
  Future<void> logout() async {
    await _clearUserFromStorage();
    _setUser(null);
    clearValidationErrors();
  }

  // ==================== USER OPERATIONS ====================
  
  /// Fetches a user by email
  /// 
  /// Useful for validation during registration (check for duplicates)
  /// 
  /// [email] Email to search for
  /// Returns: User if found, null otherwise
  Future<User?> getUserByEmail(String email) async {
    try {
      return await _authUseCases.getUserByEmail(email);
    } catch (error) {
      // TODO: Handle error appropriately
      return null;
    }
  }

  /// Adds a new user to the database
  /// 
  /// [user] User to be added
  /// Returns: Created user ID (> 0 if success, 0 if failure)
  Future<int> registerUser(User user) async {
    _setLoading(true);

    try {
      final userId = await _authUseCases.addUser(user);
      
      // If registration was successful, auto-login
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
      // TODO: Handle error appropriately
      return 0;
    } finally {
      _setLoading(false);
    }
  }

  /// Updates user data in the database
  /// 
  /// [user] User with updated data
  /// Returns: Number of affected rows (> 0 if success)
  Future<int> updateUser(User user) async {
    _setLoading(true);

    try {
      final rowsAffected = await _authUseCases.updateUser(user);

      // If update was successful, update local state
      if (rowsAffected > 0) {
        await _saveUserToStorage(user);
        _setUser(user);
      }

      return rowsAffected;
    } catch (error) {
      // TODO: Handle error appropriately
      return 0;
    } finally {
      _setLoading(false);
    }
  }

  /// Deletes user from the database
  /// 
  /// [id] ID of the user to be deleted
  /// Returns: Number of affected rows (> 0 if success)
  Future<int> deleteUser(int? id) async {
    if (id == null) {
      return 0;
    }

    _setLoading(true);

    try {
      final rowsAffected = await _authUseCases.deleteUser(id);

      // If deletion was successful and it's the current user, logout
      if (rowsAffected > 0 && _user?.id == id) {
        await logout();
      }

      return rowsAffected;
    } catch (error) {
      // TODO: Handle error appropriately
      return 0;
    } finally {
      _setLoading(false);
    }
  }
}