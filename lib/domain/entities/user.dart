// User's Entitie
class User {
  // Attributes
  final int? id;
  final String name;
  final String email;
  final String password;

  // Constructor
  const User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  // User's Copy
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

  // Override to Compare Objects
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
      other.id == id &&
      other.name == name &&
      other.email == email &&
      other.password == password;
  }

  // Override to Compare Objects
  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      password.hashCode;
  }

  // Debug Print
  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }
}