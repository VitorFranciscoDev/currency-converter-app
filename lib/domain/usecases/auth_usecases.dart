import 'package:currency_converter/domain/entities/user.dart';
import 'package:currency_converter/domain/repositories/auth_repository.dart';

/// Collection of authentication-related use cases.
///
/// This class encapsulates all business logic and validation rules
/// related to user authentication and management, following Clean
/// Architecture principles. It acts as an orchestrator between the
/// presentation layer and the repository (data layer).
///
/// ## Responsibilities:
/// - Execute authentication business logic
/// - Validate user input (name, email, password)
/// - Coordinate with the repository for data operations
/// - Enforce business rules and constraints
/// - Keep the domain layer independent of external frameworks
///
/// ## Design Pattern:
/// This follows the **Use Case Pattern** (also known as Interactor),
/// where each use case represents a specific business operation that
/// the application can perform.
///
/// ## Architecture Layer:
/// Domain Layer (Business Logic)
///
/// ## Usage Example:
/// ```dart
/// final authUseCases = AuthUseCases(repository: authRepository);
///
/// // Validate input
/// final emailError = authUseCases.validateEmail('user@example.com');
/// if (emailError != null) {
///   print('Validation error: $emailError');
///   return;
/// }
///
/// // Perform login
/// final user = await authUseCases.login('user@example.com', 'password');
/// ```
///
/// ## Clean Architecture Benefits:
/// - **Testability**: Easy to unit test without dependencies
/// - **Flexibility**: Can change UI or data sources without affecting logic
/// - **Maintainability**: Business rules are centralized and clear
/// - **Reusability**: Can be used by different presentation layers
class AuthUseCases {
  /// Creates an instance of [AuthUseCases] with the required repository.
  ///
  /// Parameters:
  /// - [repository]: The authentication repository for data operations.
  ///   This dependency is injected to follow the Dependency Inversion Principle.
  ///
  /// Example:
  /// ```dart
  /// final authUseCases = AuthUseCases(
  ///   repository: AuthRepositoryImpl(dataSource: remoteDataSource),
  /// );
  /// ```
  const AuthUseCases({required AuthRepository repository})
      : _repository = repository;

  /// The authentication repository used for data operations.
  ///
  /// This is marked private to encapsulate the data layer and prevent
  /// direct access from outside the use case. All data operations must
  /// go through the use case methods.
  final AuthRepository _repository;

  // ==================== VALIDATION USE CASES ====================

  /// Validates a user's name.
  ///
  /// Checks if the provided name meets the business requirements.
  ///
  /// ## Validation Rules:
  /// - Name cannot be empty or blank
  /// - Name must contain at least one character
  ///
  /// Parameters:
  /// - [name]: The name to validate.
  ///
  /// Returns:
  /// - `null` if the name is valid.
  /// - An error message [String] if validation fails.
  ///
  /// Example:
  /// ```dart
  /// final error = authUseCases.validateName('John Doe');
  /// if (error != null) {
  ///   showError(error); // Won't execute for valid name
  /// }
  /// ```
  ///
  /// **Future Enhancement**: Consider adding:
  /// - Minimum length validation (e.g., at least 2 characters)
  /// - Maximum length validation (e.g., max 100 characters)
  /// - Character restrictions (only letters and spaces)
  /// - Trim whitespace before validation
  String? validateName(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return "Name cannot be blank";
    }

    // Optional: Add minimum length validation
    if (trimmedName.length < 2) {
      return "Name must have at least 2 characters";
    }

    // Optional: Add maximum length validation
    if (trimmedName.length > 100) {
      return "Name must not exceed 100 characters";
    }

    return null;
  }

  /// Validates an email address.
  ///
  /// Checks if the provided email meets format requirements using
  /// a regular expression pattern.
  ///
  /// ## Validation Rules:
  /// - Must follow standard email format (user@domain.ext)
  /// - Must contain @ symbol
  /// - Must have a valid domain with at least 2 characters in TLD
  ///
  /// Parameters:
  /// - [email]: The email address to validate.
  ///
  /// Returns:
  /// - `null` if the email is valid.
  /// - An error message [String] if validation fails.
  ///
  /// Example:
  /// ```dart
  /// final error = authUseCases.validateEmail('user@example.com');
  /// if (error == null) {
  ///   print('Email is valid');
  /// }
  /// ```
  ///
  /// **Regex Pattern Explanation**:
  /// - `^[\w-\.]+`: Username part (alphanumeric, dash, dot)
  /// - `@`: Required @ symbol
  /// - `([\w-]+\.)+`: Domain parts with dots
  /// - `[\w-]{2,4}$`: TLD with 2-4 characters
  ///
  /// **Note**: This regex is a basic validation. For production,
  /// consider using a more robust validation or a dedicated library.
  /// Also consider checking email availability in the database.
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

  /// Validates a password.
  ///
  /// Checks if the provided password meets security requirements.
  ///
  /// ## Validation Rules:
  /// - Minimum length of 8 characters
  ///
  /// Parameters:
  /// - [password]: The password to validate.
  ///
  /// Returns:
  /// - `null` if the password is valid.
  /// - An error message [String] if validation fails.
  ///
  /// Example:
  /// ```dart
  /// final error = authUseCases.validatePassword('MySecurePass123');
  /// if (error == null) {
  ///   print('Password meets requirements');
  /// }
  /// ```
  ///
  /// **Security Recommendations**:
  /// For production applications, consider enforcing stronger rules:
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one number
  /// - At least one special character
  /// - Maximum length limit (e.g., 128 characters)
  /// - Check against common passwords list
  /// - Check for password similarity to email/name
  String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Password cannot be blank";
    }

    if (password.length < 8) {
      return "Password must have at least 8 characters";
    }

    // Optional: Add maximum length validation
    if (password.length > 128) {
      return "Password must not exceed 128 characters";
    }

    // Optional: Add complexity requirements
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

  /// Validates all registration fields at once.
  ///
  /// Convenience method that validates name, email, and password together.
  /// Useful for checking all fields before attempting registration.
  ///
  /// Parameters:
  /// - [name]: The user's name.
  /// - [email]: The user's email.
  /// - [password]: The user's password.
  ///
  /// Returns:
  /// - A map of field names to error messages for invalid fields.
  /// - An empty map if all fields are valid.
  ///
  /// Example:
  /// ```dart
  /// final errors = authUseCases.validateRegistrationFields(
  ///   name: 'John',
  ///   email: 'john@example.com',
  ///   password: 'Pass123!',
  /// );
  ///
  /// if (errors.isEmpty) {
  ///   // All valid, proceed with registration
  /// } else {
  ///   // Show errors to user
  ///   errors.forEach((field, error) => print('$field: $error'));
  /// }
  /// ```
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

  // ==================== AUTHENTICATION USE CASES ====================

  /// Authenticates a user with email and password credentials.
  ///
  /// This use case orchestrates the login process, which includes:
  /// 1. Delegating to the repository for authentication
  /// 2. Returning the authenticated user if successful
  ///
  /// Parameters:
  /// - [email]: The user's email address.
  /// - [password]: The user's password (will be hashed in repository).
  ///
  /// Returns:
  /// - A [User] object if authentication is successful.
  /// - `null` if authentication fails.
  ///
  /// Throws:
  /// - [InvalidCredentialsException]: If email or password is incorrect.
  /// - [NetworkException]: If there's a network connectivity issue.
  /// - [DatabaseException]: If there's a database error.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final user = await authUseCases.login(
  ///     'user@example.com',
  ///     'password123',
  ///   );
  ///
  ///   if (user != null) {
  ///     print('Welcome, ${user.name}!');
  ///   } else {
  ///     print('Invalid credentials');
  ///   }
  /// } on InvalidCredentialsException {
  ///   print('Wrong email or password');
  /// } on NetworkException {
  ///   print('No internet connection');
  /// }
  /// ```
  ///
  /// **Best Practice**: Always validate email and password format
  /// before calling this method to provide immediate feedback to users.
  Future<User?> login(String email, String password) async {
    // Optional: Add validation before attempting login
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

  // ==================== USER QUERY USE CASES ====================

  /// Retrieves a user by their email address.
  ///
  /// This use case is commonly used for:
  /// - Checking if an email is already registered
  /// - Password recovery flows
  /// - User lookup operations
  ///
  /// Parameters:
  /// - [email]: The email address to search for.
  ///
  /// Returns:
  /// - A [User] object if found.
  /// - `null` if no user exists with that email.
  ///
  /// Throws:
  /// - [ValidationException]: If email format is invalid.
  /// - [DatabaseException]: If there's a database error.
  /// - [NetworkException]: If using remote data source.
  ///
  /// Example:
  /// ```dart
  /// // Check if email is already registered
  /// final existingUser = await authUseCases.getUserByEmail(
  ///   'newuser@example.com',
  /// );
  ///
  /// if (existingUser != null) {
  ///   print('Email is already taken');
  /// } else {
  ///   print('Email is available for registration');
  /// }
  /// ```
  Future<User?> getUserByEmail(String email) async {
    // Validate email format before querying
    final emailError = validateEmail(email);
    if (emailError != null) {
      throw ValidationException(emailError);
    }

    return await _repository.getUserByEmail(email);
  }

  // ==================== USER MANAGEMENT USE CASES ====================

  /// Registers a new user in the system.
  ///
  /// This use case handles the complete user registration process:
  /// 1. Validates all user data
  /// 2. Checks for duplicate email
  /// 3. Creates the user in the repository
  ///
  /// Parameters:
  /// - [user]: The user object to register (ID should be null).
  ///
  /// Returns:
  /// - The newly created user ID (> 0) if successful.
  /// - `0` if registration fails.
  ///
  /// Throws:
  /// - [ValidationException]: If user data is invalid.
  /// - [DuplicateEmailException]: If email already exists.
  /// - [DatabaseException]: If there's a database error.
  ///
  /// Example:
  /// ```dart
  /// final newUser = User(
  ///   name: 'John Doe',
  ///   email: 'john@example.com',
  ///   password: 'hashedPassword',
  /// );
  ///
  /// try {
  ///   final userId = await authUseCases.addUser(newUser);
  ///   if (userId > 0) {
  ///     print('User registered with ID: $userId');
  ///   }
  /// } on DuplicateEmailException {
  ///   print('Email already registered');
  /// }
  /// ```
  ///
  /// **Security Note**: Ensure the password is hashed before creating
  /// the User object. Never pass plain-text passwords to this method.
  Future<int> addUser(User user) async {
    // Validate user data
    final validationErrors = validateRegistrationFields(
      name: user.name,
      email: user.email,
      password: user.password,
    );

    if (validationErrors.isNotEmpty) {
      throw ValidationException.fields(validationErrors);
    }

    // Check if email already exists
    final existingUser = await getUserByEmail(user.email);
    if (existingUser != null) {
      throw DuplicateEmailException();
    }

    return await _repository.addUser(user);
  }

  /// Deletes a user from the system.
  ///
  /// This use case permanently removes a user record.
  ///
  /// Parameters:
  /// - [id]: The unique identifier of the user to delete.
  ///
  /// Returns:
  /// - The number of affected rows (1 if successful, 0 if failed).
  ///
  /// Throws:
  /// - [ValidationException]: If ID is null or invalid.
  /// - [UserNotFoundException]: If user doesn't exist.
  /// - [DatabaseException]: If there's a database error.
  ///
  /// Example:
  /// ```dart
  /// final rowsAffected = await authUseCases.deleteUser(userId);
  /// if (rowsAffected > 0) {
  ///   print('User deleted successfully');
  /// }
  /// ```
  ///
  /// **Warning**: This is a destructive operation. Consider implementing
  /// soft delete (marking as inactive) instead of permanent deletion.
  Future<int> deleteUser(int? id) async {
    if (id == null || id <= 0) {
      throw ValidationException('User ID must be a positive integer');
    }

    return await _repository.deleteUser(id);
  }

  /// Updates an existing user's information.
  ///
  /// This use case handles user profile updates:
  /// 1. Validates the updated data
  /// 2. Checks for email conflicts (if email changed)
  /// 3. Updates the user in the repository
  ///
  /// Parameters:
  /// - [user]: The user object with updated information.
  ///
  /// Returns:
  /// - The number of affected rows (1 if successful, 0 if failed).
  ///
  /// Throws:
  /// - [ValidationException]: If user data is invalid.
  /// - [UserNotFoundException]: If user doesn't exist.
  /// - [DuplicateEmailException]: If new email already exists.
  /// - [DatabaseException]: If there's a database error.
  ///
  /// Example:
  /// ```dart
  /// final updatedUser = existingUser.copyWith(
  ///   name: 'Jane Doe',
  ///   email: 'jane@example.com',
  /// );
  ///
  /// final rowsAffected = await authUseCases.updateUser(updatedUser);
  /// if (rowsAffected > 0) {
  ///   print('User updated successfully');
  /// }
  /// ```
  Future<int> updateUser(User user) async {
    if (user.id == null || user.id! <= 0) {
      throw ValidationException('User must have a valid ID to update');
    }

    // Validate updated data
    final validationErrors = validateRegistrationFields(
      name: user.name,
      email: user.email,
      password: user.password,
    );

    if (validationErrors.isNotEmpty) {
      throw ValidationException.fields(validationErrors);
    }

    // Check if email is taken by another user
    final existingUser = await getUserByEmail(user.email);
    if (existingUser != null && existingUser.id != user.id) {
      throw DuplicateEmailException();
    }

    return await _repository.updateUser(user);
  }
}

// ==================== CUSTOM EXCEPTIONS ====================

/// Exception thrown when validation fails.
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

/// Exception thrown when email already exists.
class DuplicateEmailException implements Exception {
  const DuplicateEmailException();

  @override
  String toString() => 'DuplicateEmailException: Email already registered';
}