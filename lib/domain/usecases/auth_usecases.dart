import 'package:currency_converter/domain/entities/user.dart';
import 'package:currency_converter/domain/repositories/auth_repository.dart';

class AuthUseCases {
  const AuthUseCases({ required this.r });
  final AuthRepository r;

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