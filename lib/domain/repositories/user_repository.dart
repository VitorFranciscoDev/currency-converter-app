import 'package:currency_converter/domain/entities/user.dart';

// Interface
abstract class UserRepository {
  Future<User?> login(String email, String password);
  Future<User?> getUserByEmail(String email);
  Future<int> addUser(User user);
  Future<int> deleteUser(int? id);
  Future<int> updateUser(User user);
}