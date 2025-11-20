import 'package:currency_converter/domain/entities/user.dart';

// User Contracts
abstract class UserRepository {
  // User's Query
  Future<User?> login(String email, String password);
  Future<User?> getUserByEmail(String email);

  // DDL commands
  Future<int> addUser(User user);
  Future<int> deleteUser(int? id);
  Future<int> updateUser(User user);
}