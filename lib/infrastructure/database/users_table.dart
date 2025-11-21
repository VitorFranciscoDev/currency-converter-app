import 'package:currency_converter/core/constants/database.dart';
import 'package:sqflite/sqflite.dart';

// Users Table in SQLite Database
class UsersTable {
  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.usersTableName} (
        ${DatabaseConstants.usersColumnID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseConstants.usersColumnName} TEXT NOT NULL,
        ${DatabaseConstants.usersColumnEmail} TEXT UNIQUE NOT NULL,
        ${DatabaseConstants.usersColumnPassword} TEXT NOT NULL
      )
    ''');
  }
}