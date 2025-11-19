import 'package:currency_converter/infrastructure/database/users_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CurrencyConverterDatabase {
  static Database? _database;
  CurrencyConverterDatabase._();
  static final CurrencyConverterDatabase instance = CurrencyConverterDatabase._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initializeDatabase();
    return _database!;
  }

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
      onUpgrade: _onUpgradeDatabase,
      onDowngrade: _onDowngradeDatabase,
    );
  }

  static const int _currentDatabaseVersion = 1;

  Future<void> _onCreateDatabase(Database db, int version) async {
    await UsersTable.createTable(db);
  }

  Future<void> _onUpgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {}
  Future<void> _onDowngradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    throw UnsupportedError(
      'Database downgrade from version $oldVersion to $newVersion is not supported. '
      'Please uninstall and reinstall the app.',
    );
  }

  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  Future<bool> deleteDatabaseFile() async {
    try {
      await closeDatabase();

      final databaseDirectoryPath = await getDatabasesPath();
      final databaseFilePath = join(
        databaseDirectoryPath,
        'currency_converter.db',
      );

      await deleteDatabase(databaseFilePath);
      return true;
    } catch (e) {
      print('Error deleting database: $e');
      return false;
    }
  }

  bool get isDatabaseInitialized => _database != null;

  Future<int?> getDatabaseVersion() async {
    if (_database == null) return null;
    return await _database!.getVersion();
  }
}