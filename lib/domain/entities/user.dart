class User {
  final int? id;
  final String? uuid;
  final String name;
  final String email;
  final String password;

  const User({
    this.id,
    this.uuid,
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      uuid: json['uuid'],
      name: json['name'], 
      email: json['email'], 
      password: json['password'],
    );
  }

  @override
  String toString() {
    return "id: $id, uuid: $uuid, name: $name, email: $email, password: $password";
  }
}