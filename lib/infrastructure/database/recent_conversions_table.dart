import 'package:currency_converter/core/constants/database.dart';
import 'package:sqflite/sqflite.dart';

// Recent Conversions Table in SQLite Database
class RecentConversionsTable {
  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.recentConversionsTableName} (
        ${DatabaseConstants.recentConversionsColumnUID} INTEGER,
        ${DatabaseConstants.recentConversionsColumnFrom} TEXT NOT NULL,
        ${DatabaseConstants.recentConversionsColumnTo} TEXT NOT NULL,
        ${DatabaseConstants.recentConversionsColumnAmount} REAL NOT NULL,
        ${DatabaseConstants.recentConversionsColumnResult} REAL NOT NULL,
        ${DatabaseConstants.recentConversionsColumnTime} TEXT NOT NULL,
        FOREIGN KEY(${DatabaseConstants.recentConversionsColumnUID}) REFERENCES users(${DatabaseConstants.usersColumnID}) ON DELETE CASCADE 
      )
    ''');
  }
}