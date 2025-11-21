import 'package:currency_converter/domain/entities/user.dart';

class UserModel extends User {
  // Constructor
  const UserModel({
    required super.id, 
    required super.name, 
    required super.email, 
    required super.password
  });

  // User => Json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  // Json => User
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'], 
      name: json['name'], 
      email: json['email'], 
      password: json['password'],
    );
  }
}