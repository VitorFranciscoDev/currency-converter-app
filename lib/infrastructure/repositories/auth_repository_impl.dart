import 'package:currency_converter/domain/entities/user.dart';
import 'package:currency_converter/domain/repositories/auth_repository.dart';
import 'package:currency_converter/infrastructure/database/database.dart';
import 'package:currency_converter/infrastructure/models/user_model.dart';

// Auth Repository Implementation
class AuthRepositoryImpl implements AuthRepository {
  final database = CurrencyConverterDatabase();

  @override
  Future<User?> login(String email, String password) async {
    try {
      final db = await database.database;

      final user = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );

      return UserModel.fromJson(user.first);
    } catch(e) {
      throw Exception("Error in Login: $e");
    }
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    try {
      final db = await database.database;

      final user = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      return UserModel.fromJson(user.first);
    } catch(e) {
      throw Exception("Error in Get User By Email: $e");
    }
  }

  @override
  Future<int> addUser(User user) async {
    try {
      final db = await database.database;

      final userModel = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password,
      );

      return await db.insert('users', userModel.toJson());
    } catch(e) {
      throw Exception("Error in Add User: $e");
    }
  }

  @override
  Future<int> deleteUser(int? id) async {
    try {
      final db = await database.database;

      return await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch(e) {
      throw Exception("Error in Delete User: $e");
    }
  }

  @override
  Future<int> updateUser(User user) async {
    try {
      final db = await database.database;

      final userModel = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password,
      );

      return await db.update(
        'users', 
        userModel.toJson(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    } catch(e) {
      throw Exception("Error in Update User: $e");
    }
  }
}