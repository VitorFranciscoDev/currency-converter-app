import 'package:currency_converter/infrastructure/database/users_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Table Creation
class CurrencyConverterDatabase {
  // Instances
  static final CurrencyConverterDatabase _instance = CurrencyConverterDatabase._internal();
  factory CurrencyConverterDatabase() => _instance;
  CurrencyConverterDatabase._internal();
  static Database? db;

  // Getter
  Future<Database> get database async {
    if(db != null) return db!;
    db = await _initDatabase();
    return db!;
  }

  // Init Database
  Future<Database> _initDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'trip_planner.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await UsersTable.createTable(db);
      },
    );
  }
}