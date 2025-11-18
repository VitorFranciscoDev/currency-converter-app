import 'package:currency_converter/domain/entities/user.dart';
import 'package:currency_converter/domain/repositories/auth_repository.dart';

class AuthUseCases {
  const AuthUseCases({ required this.r });
  final AuthRepository r;

  String? validateName(String name) => name.isEmpty ? "Name cannot be blank" : null;
  String? validateEmail(String email) => !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email) ? "Email Invalid" : null;
  String? validatePassword(String password) => password.length < 8 ? "Password needs to have 8 characters" : null;

  Future<User?> login(String email, String password) async {
    return await r.login(email, password);
  }

  Future<User?> getUserByEmail(String email) async {
    return await r.getUserByEmail(email);
  }

  Future<int> addUser(User user) async {
    return await r.addUser(user);
  }

  Future<int> deleteUser(int? id) async {
    return await r.deleteUser(id);
  }

  Future<int> updateUser(User user) async {
    return await r.updateUser(user);
  }
}