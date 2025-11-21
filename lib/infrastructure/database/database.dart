import 'package:currency_converter/infrastructure/database/recent_conversions_table.dart';
import 'package:currency_converter/infrastructure/database/users_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Database of the Application
class CurrencyConverterDatabase {
  // Instances
  static Database? _database;
  CurrencyConverterDatabase._();
  static final CurrencyConverterDatabase instance = CurrencyConverterDatabase._();

  // Database Version
  static const int _currentDatabaseVersion = 1;

  // Getter to DB
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initializeDatabase();
    return _database!;
  }

  // Initializes the DB
  Future<Database> _initializeDatabase() async {
    final databaseDirectoryPath = await getDatabasesPath();

    final databaseFilePath = join(
      databaseDirectoryPath,
      'currency_converter.db',
    );

    return await openDatabase(
      databaseFilePath,
      version: _currentDatabaseVersion,
      onCreate: _onCreateDatabase,
    );
  }

  // Create Tables
  Future<void> _onCreateDatabase(Database db, int version) async {
    await UsersTable.createTable(db);
    await RecentConversionsTable.createTable(db);
  }
}