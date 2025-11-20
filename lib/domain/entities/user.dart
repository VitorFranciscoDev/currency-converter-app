// User's Entitie
class User {
  // Attributes
  final int? _id;
  final String _name;
  final String _email;
  final String password;

  // Constructor
  const User({
    int? id,
    required String name,
    required String email,
    required this.password,
  }) :
    _id = id,
    _name = name,
    _email = email;

  // Getters
  int? get id => _id;
  String get name => _name;
  String get email => _email;

  // Debug Print
  @override
  String toString() {
    return 'User(id: $_id, name: $_name, email: $_email)';
  }
}