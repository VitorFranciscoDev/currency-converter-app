import 'package:currency_converter/domain/entities/user.dart';

abstract class UserRepository {
  Future<int> addUser(User user);
  Future<int> deleteUser(String? uuid);
  Future<int> updateUser(User user);
  Future<User?> login(String email, String password);
  Future<User?> getUserByEmail(String email);
}