import 'package:currency_converter/core/constants/database_constants.dart';
import 'package:currency_converter/domain/entities/user.dart';
import 'package:currency_converter/domain/repositories/user_repository.dart';
import 'package:currency_converter/infrastructure/database/database.dart';
import 'package:currency_converter/infrastructure/models/user_model.dart';

// Implementation of User Contracts
class UserRepositoryImpl implements UserRepository {
  // Constructor
  UserRepositoryImpl({
    CurrencyConverterDatabase? databaseManager,
  }) : _databaseManager = databaseManager ?? CurrencyConverterDatabase.instance;

  final CurrencyConverterDatabase _databaseManager;

  @override
  Future<User?> login(String email, String password) async {
    try {
      final db = await _databaseManager.database;

      final user = await db.query(
        DatabaseConstants.usersTableName,
        where: '${DatabaseConstants.usersColumnEmail} = ? AND ${DatabaseConstants.usersColumnPassword} = ?',
        whereArgs: [email, password],
        limit: 1,
      );

      if (user.isEmpty) {
        return null;
      }

      return UserModel.fromJson(user.first);
    } catch (error) {
      throw Exception("Error on Authentication: $error");
    }
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    try {
      final db = await _databaseManager.database;

      final user = await db.query(
        DatabaseConstants.usersTableName,
        where: '${DatabaseConstants.usersColumnEmail} = ?',
        whereArgs: [email],
        limit: 1,
      );

      if (user.isEmpty) {
        return null;
      }

      return UserModel.fromJson(user.first);
    } catch (error) {
      throw Exception("Error on Get User By Email: $error");
    }
  }

  @override
  Future<int> addUser(User user) async {
    try {
      final db = await _databaseManager.database;

      final userModel = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password,
      );

      final userId = await db.insert(
        DatabaseConstants.usersTableName,
        userModel.toJson(),
      );

      return userId;
    } catch (error) {
      throw Exception("Error on Add User: $error");
    }
  }

  @override
  Future<int> deleteUser(int? id) async {
    try {
      final db = await _databaseManager.database;

      return await db.delete(
        DatabaseConstants.usersTableName,
        where: '${DatabaseConstants.usersColumnID} = ?',
        whereArgs: [id],
      );
    } catch (error) {
      throw Exception("Error on Delete User: $error");
    }
  }

  @override
  Future<int> updateUser(User user) async {
    try {
      final db = await _databaseManager.database;

      final userModel = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password,
      );

      return await db.update(
        DatabaseConstants.usersTableName,
        userModel.toJson(),
        where: '${DatabaseConstants.usersColumnID} = ?',
        whereArgs: [user.id],
      );
    } catch (error) {
      throw Exception("Error on Update User: $error");
    }
  }
}