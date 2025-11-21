class User {
  // Attributes
  final int? _id;
  final String _name;
  final String _email;
  final String _password;

  // Constructor
  const User({
    int? id,
    required String name,
    required String email,
    required String password,
  }) :
    _id = id,
    _name = name,
    _email = email,
    _password = password;

  // Getters
  int? get id => _id;
  String get name => _name;
  String get email => _email;
  String get password => _password;

  // Debug
  @override
  String toString() {
    return 'User(id: $_id, name: $_name, email: $_email)';
  }
}