import 'package:currency_converter/domain/entities/user.dart';
import 'package:currency_converter/domain/repositories/user_repository.dart';

class UserUseCases {
  // Constructor
  const UserUseCases({ required UserRepository repository })
      : _repository = repository;

  // Repository
  final UserRepository _repository;

  // Validation

  // Name Validation
  String? validateName(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return "Name cannot be blank";
    }

    if (trimmedName.length < 2) {
      return "Name must have at least 2 characters";
    }

    if (trimmedName.length > 50) {
      return "Name must not exceed 50 characters";
    }

    return null;
  }

  // Email Validation
  String? validateEmail(String email) {
    final trimmedEmail = email.trim().toLowerCase();

    if (trimmedEmail.isEmpty) {
      return "Email cannot be blank";
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(trimmedEmail)) {
      return "Email format is invalid";
    }

    return null;
  }

  // Password Validation
  String? validatePassword(String password) {
    final trimmedPassword = password.trim();

    if (trimmedPassword.isEmpty) {
      return "Password cannot be blank";
    }

    if (trimmedPassword.length < 8) {
      return "Password must have at least 8 characters";
    }

    if (trimmedPassword.length > 50) {
      return "Password must not exceed 50 characters";
    }
    
    return null;
  }

  // Repository
  
  Future<User?> login(String email, String password) async {
    return await _repository.login(email, password);
  }

  Future<User?> getUserByEmail(String email) async {
    return await _repository.getUserByEmail(email);
  }

  Future<int> addUser(User user) async {
    return await _repository.addUser(user);
  }

  Future<int> deleteUser(int? id) async {
    return await _repository.deleteUser(id);
  }

  Future<int> updateUser(User user) async {
    return await _repository.updateUser(user);
  }
}