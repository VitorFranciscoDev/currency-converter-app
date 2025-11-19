import 'package:currency_converter/domain/entities/user.dart';
import 'package:currency_converter/domain/repositories/auth_repository.dart';

class AuthUseCases {
  const AuthUseCases({required AuthRepository repository})
      : _repository = repository;

  final AuthRepository _repository;

  String? validateName(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return "Name cannot be blank";
    }

    if (trimmedName.length < 2) {
      return "Name must have at least 2 characters";
    }

    if (trimmedName.length > 100) {
      return "Name must not exceed 100 characters";
    }

    return null;
  }

  String? validateEmail(String email) {
    final trimmedEmail = email.trim().toLowerCase();

    if (trimmedEmail.isEmpty) {
      return "Email cannot be blank";
    }

    // Email format validation using regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(trimmedEmail)) {
      return "Email format is invalid";
    }

    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Password cannot be blank";
    }

    if (password.length < 8) {
      return "Password must have at least 8 characters";
    }

    if (password.length > 128) {
      return "Password must not exceed 128 characters";
    }

    final hasUpperCase = password.contains(RegExp(r'[A-Z]'));
    final hasLowerCase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUpperCase) {
      return "Password must contain at least one uppercase letter";
    }

    if (!hasLowerCase) {
      return "Password must contain at least one lowercase letter";
    }

    if (!hasDigits) {
      return "Password must contain at least one number";
    }

    if (!hasSpecialChar) {
      return "Password must contain at least one special character";
    }

    return null;
  }

  Map<String, String> validateRegistrationFields({
    required String name,
    required String email,
    required String password,
  }) {
    final errors = <String, String>{};

    final nameError = validateName(name);
    if (nameError != null) {
      errors['name'] = nameError;
    }

    final emailError = validateEmail(email);
    if (emailError != null) {
      errors['email'] = emailError;
    }

    final passwordError = validatePassword(password);
    if (passwordError != null) {
      errors['password'] = passwordError;
    }

    return errors;
  }

  Future<User?> login(String email, String password) async {
    final emailError = validateEmail(email);
    if (emailError != null) {
      throw ValidationException(emailError);
    }

    final passwordError = validatePassword(password);
    if (passwordError != null) {
      throw ValidationException(passwordError);
    }

    return await _repository.login(email, password);
  }

  Future<User?> getUserByEmail(String email) async {
    final emailError = validateEmail(email);
    if (emailError != null) {
      throw ValidationException(emailError);
    }

    return await _repository.getUserByEmail(email);
  }

  Future<int> addUser(User user) async {
    final validationErrors = validateRegistrationFields(
      name: user.name,
      email: user.email,
      password: user.password,
    );

    if (validationErrors.isNotEmpty) {
      throw ValidationException.fields(validationErrors);
    }

    final existingUser = await getUserByEmail(user.email);
    if (existingUser != null) {
      throw DuplicateEmailException();
    }

    return await _repository.addUser(user);
  }

  Future<int> deleteUser(int? id) async {
    if (id == null || id <= 0) {
      throw ValidationException('User ID must be a positive integer');
    }

    return await _repository.deleteUser(id);
  }

  Future<int> updateUser(User user) async {
    if (user.id == null || user.id! <= 0) {
      throw ValidationException('User must have a valid ID to update');
    }

    final validationErrors = validateRegistrationFields(
      name: user.name,
      email: user.email,
      password: user.password,
    );

    if (validationErrors.isNotEmpty) {
      throw ValidationException.fields(validationErrors);
    }

    final existingUser = await getUserByEmail(user.email);
    if (existingUser != null && existingUser.id != user.id) {
      throw DuplicateEmailException();
    }

    return await _repository.updateUser(user);
  }
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? fieldErrors;

  const ValidationException(this.message, {this.fieldErrors});

  factory ValidationException.fields(Map<String, String> errors) {
    return ValidationException(
      'Validation failed for multiple fields',
      fieldErrors: errors,
    );
  }

  @override
  String toString() => 'ValidationException: $message';
}

class DuplicateEmailException implements Exception {
  const DuplicateEmailException();

  @override
  String toString() => 'DuplicateEmailException: Email already registered';
}