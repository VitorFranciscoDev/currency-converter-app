import 'package:currency_converter/domain/entities/user.dart';
import 'package:currency_converter/domain/repositories/auth_repository.dart';
import 'package:currency_converter/infrastructure/database/database.dart';
import 'package:currency_converter/infrastructure/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    CurrencyConverterDatabase? databaseManager,
  }) : _databaseManager = databaseManager ?? CurrencyConverterDatabase.instance;

  final CurrencyConverterDatabase _databaseManager;

  static const String _usersTableName = 'users';
  static const String _idColumn = 'id';
  static const String _emailColumn = 'email';
  static const String _passwordColumn = 'password';

  @override
  Future<User?> login(String email, String password) async {
    try {
      final db = await _databaseManager.database;

      final results = await db.query(
        _usersTableName,
        where: '$_emailColumn = ? AND $_passwordColumn = ?',
        whereArgs: [email, password],
        limit: 1,
      );

      if (results.isEmpty) {
        return null;
      }

      return UserModel.fromJson(results.first);
    } on DatabaseException catch (e) {
      throw DatabaseException('Failed to authenticate user: ${e.toString()}');
    } catch (e) {
      throw DatabaseException('Unexpected error during login: ${e.toString()}');
    }
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    try {
      final db = await _databaseManager.database;

      final results = await db.query(
        _usersTableName,
        where: '$_emailColumn = ?',
        whereArgs: [email],
        limit: 1,
      );

      if (results.isEmpty) {
        return null;
      }

      return UserModel.fromJson(results.first);
    } on DatabaseException catch (e) {
      throw DatabaseException('Failed to fetch user by email: ${e.toString()}');
    } catch (e) {
      throw DatabaseException('Unexpected error fetching user: ${e.toString()}');
    }
  }

  @override
  Future<int> addUser(User user) async {
    try {
      final existingUser = await getUserByEmail(user.email);
      if (existingUser != null) {
        throw DuplicateEmailException();
      }

      final db = await _databaseManager.database;

      final userModel = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password,
      );

      final userId = await db.insert(
        _usersTableName,
        userModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      return userId;
    } on DuplicateEmailException {
      rethrow;
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw DuplicateEmailException();
      }
      throw DatabaseException('Failed to add user: ${e.toString()}');
    } catch (e) {
      throw DatabaseException('Unexpected error adding user: ${e.toString()}');
    }
  }

  @override
  Future<int> deleteUser(int? id) async {
    if (id == null || id <= 0) {
      throw ValidationException('User ID must be a positive integer');
    }

    try {
      final db = await _databaseManager.database;

      final rowsAffected = await db.delete(
        _usersTableName,
        where: '$_idColumn = ?',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        throw UserNotFoundException();
      }

      return rowsAffected;
    } on UserNotFoundException {
      rethrow;
    } on DatabaseException catch (e) {
      throw DatabaseException('Failed to delete user: ${e.toString()}');
    } catch (e) {
      throw DatabaseException('Unexpected error deleting user: ${e.toString()}');
    }
  }

  @override
  Future<int> updateUser(User user) async {
    if (user.id == null || user.id! <= 0) {
      throw ValidationException('User must have a valid ID to update');
    }

    try {
      final existingUser = await getUserByEmail(user.email);
      if (existingUser != null && existingUser.id != user.id) {
        throw DuplicateEmailException();
      }

      final db = await _databaseManager.database;

      final userModel = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password,
      );

      final rowsAffected = await db.update(
        _usersTableName,
        userModel.toJson(),
        where: '$_idColumn = ?',
        whereArgs: [user.id],
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      if (rowsAffected == 0) {
        throw UserNotFoundException();
      }

      return rowsAffected;
    } on DuplicateEmailException {
      rethrow;
    } on UserNotFoundException {
      rethrow;
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw DuplicateEmailException();
      }
      throw DatabaseException('Failed to update user: ${e.toString()}');
    } catch (e) {
      throw DatabaseException('Unexpected error updating user: ${e.toString()}');
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      final db = await _databaseManager.database;

      final results = await db.query(
        _usersTableName,
        orderBy: '$_idColumn ASC',
      );

      return results.map((json) => UserModel.fromJson(json)).toList();
    } on DatabaseException catch (e) {
      throw DatabaseException('Failed to fetch all users: ${e.toString()}');
    } catch (e) {
      throw DatabaseException('Unexpected error fetching users: ${e.toString()}');
    }
  }

  Future<bool> userExists(int id) async {
    try {
      final db = await _databaseManager.database;

      final results = await db.query(
        _usersTableName,
        where: '$_idColumn = ?',
        whereArgs: [id],
        limit: 1,
      );

      return results.isNotEmpty;
    } on DatabaseException catch (e) {
      throw DatabaseException('Failed to check user existence: ${e.toString()}');
    } catch (e) {
      throw DatabaseException('Unexpected error checking user: ${e.toString()}');
    }
  }

  Future<int> getUserCount() async {
    try {
      final db = await _databaseManager.database;

      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $_usersTableName',
      );

      return Sqflite.firstIntValue(result) ?? 0;
    } on DatabaseException catch (e) {
      throw DatabaseException('Failed to count users: ${e.toString()}');
    } catch (e) {
      throw DatabaseException('Unexpected error counting users: ${e.toString()}');
    }
  }
}

class DatabaseException implements Exception {
  final String message;
  
  DatabaseException(this.message);
  
  @override
  String toString() => 'DatabaseException: $message';
}

class DuplicateEmailException implements Exception {
  @override
  String toString() => 'DuplicateEmailException: Email already exists';
}

class UserNotFoundException implements Exception {
  @override
  String toString() => 'UserNotFoundException: User not found';
}

class ValidationException implements Exception {
  final String message;
  
  ValidationException(this.message);
  
  @override
  String toString() => 'ValidationException: $message';
}

extension DatabaseExceptionExtension on DatabaseException {
  bool isUniqueConstraintError() {
    return toString().toLowerCase().contains('unique');
  }
}