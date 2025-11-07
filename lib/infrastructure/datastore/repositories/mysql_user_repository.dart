import 'package:currency_converter/domain/entities/user.dart';
import 'package:currency_converter/infrastructure/datastore/interfaces/user_repository.dart';

class MySQLUserRepository implements UserRepository {
  @override
  Future<int> addUser(User user) async {
    return 0;
  }

  @override
  Future<int> deleteUser(String? uuid) async {
    return 0;
  }
  
  @override
  Future<int> updateUser(User user) async {
    return 0;
  }

  @override
  Future<User?> login(String email, String password) async {
    return null;
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    return null;
  }
}