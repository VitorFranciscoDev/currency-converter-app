/// Represents a user entity in the domain layer.
///
/// This is a domain entity that encapsulates user data and follows
/// Clean Architecture principles. It contains only business logic
/// properties without any framework-specific dependencies.
///
/// ## Properties:
/// - [id]: Unique identifier for the user. Nullable for new users not yet persisted.
/// - [name]: Full name of the user.
/// - [email]: Email address used for authentication and communication.
/// - [password]: User's password (should be hashed in production).
///
/// ## Usage Example:
/// ```dart
/// // Creating a new user (without ID)
/// final newUser = User(
///   name: 'John Doe',
///   email: 'john@example.com',
///   password: 'hashedPassword123',
/// );
///
/// // Creating an existing user (with ID from database)
/// final existingUser = User(
///   id: 1,
///   name: 'John Doe',
///   email: 'john@example.com',
///   password: 'hashedPassword123',
/// );
/// ```
class User {
  /// Unique identifier for the user.
  ///
  /// This is nullable to support two scenarios:
  /// 1. New users that haven't been saved to the database yet (id is null)
  /// 2. Existing users retrieved from the database (id has a value)
  final int? id;

  /// Full name of the user.
  ///
  /// Required field that represents the user's display name.
  /// Should be validated before creating a User instance.
  final String name;

  /// Email address of the user.
  ///
  /// Required field used for:
  /// - User authentication
  /// - Account identification
  /// - Communication purposes
  ///
  /// Must be unique across all users and should be validated
  /// for proper email format before creating a User instance.
  final String email;

  /// User's password.
  ///
  /// Required field for authentication.
  ///
  /// **Security Note**: In production, this should always be a hashed
  /// password, never stored or transmitted in plain text. Consider using
  /// bcrypt, argon2, or similar hashing algorithms.
  final String password;

  /// Creates a new [User] instance.
  ///
  /// All parameters except [id] are required to ensure data integrity.
  ///
  /// Parameters:
  /// - [id]: Optional user identifier. Null for new users, present for existing ones.
  /// - [name]: Required user's full name.
  /// - [email]: Required user's email address.
  /// - [password]: Required user's password (should be hashed).
  ///
  /// Example:
  /// ```dart
  /// final user = User(
  ///   id: 1,
  ///   name: 'Jane Smith',
  ///   email: 'jane@example.com',
  ///   password: 'hashed_password_here',
  /// );
  /// ```
  const User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  /// Creates a copy of this user with the given fields replaced with new values.
  ///
  /// This method is useful for updating user information while maintaining
  /// immutability of the entity.
  ///
  /// Example:
  /// ```dart
  /// final updatedUser = user.copyWith(
  ///   name: 'New Name',
  ///   email: 'newemail@example.com',
  /// );
  /// ```
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  /// Checks if this user is a new user (not yet persisted to database).
  ///
  /// Returns `true` if the user has no ID, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// if (user.isNew) {
  ///   print('This user needs to be saved to the database');
  /// }
  /// ```
  bool get isNew => id == null;

  /// Checks if this user is an existing user (already persisted to database).
  ///
  /// Returns `true` if the user has an ID, `false` otherwise.
  bool get isExisting => id != null;

  /// Compares this user with another object for equality.
  ///
  /// Two users are considered equal if they have the same ID (for existing users)
  /// or the same email (for new users, since email should be unique).
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.password == password;
  }

  /// Returns a hash code for this user.
  ///
  /// The hash code is computed based on all properties to ensure
  /// consistent behavior with the equality operator.
  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        password.hashCode;
  }

  /// Returns a string representation of this user.
  ///
  /// Useful for debugging purposes. Note that the password is not included
  /// in the string representation for security reasons.
  ///
  /// Example output: `User(id: 1, name: John Doe, email: john@example.com)`
  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }
}

// ==================== OPTIONAL ENHANCEMENTS ====================

/// Extension methods for User entity to add additional utility functions.
///
/// These methods provide convenient ways to work with User objects
/// without modifying the core entity class.
extension UserExtensions on User {
  /// Gets the user's first name from the full name.
  ///
  /// Example:
  /// ```dart
  /// final user = User(name: 'John Doe', ...);
  /// print(user.firstName); // Output: John
  /// ```
  String get firstName => name.split(' ').first;

  /// Gets the user's last name from the full name.
  ///
  /// Returns an empty string if the user has only one name.
  ///
  /// Example:
  /// ```dart
  /// final user = User(name: 'John Doe', ...);
  /// print(user.lastName); // Output: Doe
  /// ```
  String get lastName {
    final parts = name.split(' ');
    return parts.length > 1 ? parts.last : '';
  }

  /// Gets the user's initials from the name.
  ///
  /// Example:
  /// ```dart
  /// final user = User(name: 'John Doe', ...);
  /// print(user.initials); // Output: JD
  /// ```
  String get initials {
    final parts = name.split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  /// Gets the domain from the user's email address.
  ///
  /// Example:
  /// ```dart
  /// final user = User(email: 'john@example.com', ...);
  /// print(user.emailDomain); // Output: example.com
  /// ```
  String get emailDomain {
    final parts = email.split('@');
    return parts.length > 1 ? parts[1] : '';
  }

  /// Checks if the user's email is from a specific domain.
  ///
  /// Example:
  /// ```dart
  /// if (user.isEmailFromDomain('company.com')) {
  ///   print('This is a company email');
  /// }
  /// ```
  bool isEmailFromDomain(String domain) {
    return emailDomain.toLowerCase() == domain.toLowerCase();
  }
}