import 'package:currency_converter/infrastructure/database/users_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CurrencyConverterDatabase {
  static Database? db;

  Future<Database> get database async {
    if(db != null) return db!;
    db = await _initDatabase();
    return db!;
  }

  Future<Database> _initDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'currency_converter.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await UsersTable.createTable(db);
      },
    );
  }
}