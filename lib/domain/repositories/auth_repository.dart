import 'package:currency_converter/domain/entities/user.dart';

// Auth Contracts
abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<User?> getUserByEmail(String email);
  Future<int> addUser(User user);
  Future<int> deleteUser(int? id);
  Future<int> updateUser(User user);
}