import 'package:currency_converter/infrastructure/database/users_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Singleton database manager for the Currency Converter application.
///
/// This class manages the SQLite database instance using the Singleton pattern,
/// ensuring that only one database connection exists throughout the app lifecycle.
/// It handles database initialization, version management, and table creation.
///
/// ## Architecture Layer:
/// Infrastructure/Data Layer - Handles low-level database operations
///
/// ## Responsibilities:
/// - Initialize SQLite database on first access
/// - Maintain a single database instance (Singleton)
/// - Handle database versioning and migrations
/// - Provide database access to data sources
/// - Create database tables on first run
///
/// ## Design Pattern:
/// **Singleton Pattern**: Ensures only one database instance exists,
/// preventing multiple connections and potential data inconsistencies.
///
/// ## Usage Example:
/// ```dart
/// // In a data source or repository implementation
/// class UserDataSource {
///   final CurrencyConverterDatabase dbManager;
///
///   Future<List<User>> getUsers() async {
///     final db = await dbManager.database;
///     final results = await db.query('users');
///     return results.map((json) => User.fromJson(json)).toList();
///   }
/// }
/// ```
///
/// ## Database File:
/// - Name: `currency_converter.db`
/// - Location: Platform-specific database directory
/// - Current Version: 1
///
/// ## Best Practices Followed:
/// - Lazy initialization (database created only when first accessed)
/// - Null safety with proper null checks
/// - Version control for future migrations
/// - Separation of concerns (table creation delegated to table classes)
class CurrencyConverterDatabase {
  // ==================== SINGLETON INSTANCE ====================

  /// Private static instance of the database.
  ///
  /// This is `null` initially and gets initialized on first access.
  /// Using static ensures the instance persists across the app lifecycle.
  static Database? _database;

  /// Private constructor to prevent external instantiation.
  ///
  /// This enforces the Singleton pattern by making it impossible
  /// to create instances using `CurrencyConverterDatabase()`.
  ///
  /// If you need to use this class, access it through dependency
  /// injection or create a getInstance() method.
  CurrencyConverterDatabase._();

  /// Singleton instance of the database manager.
  ///
  /// Use this to access the database manager throughout the app.
  ///
  /// Example:
  /// ```dart
  /// final dbManager = CurrencyConverterDatabase.instance;
  /// final db = await dbManager.database;
  /// ```
  static final CurrencyConverterDatabase instance = CurrencyConverterDatabase._();

  // ==================== DATABASE ACCESS ====================

  /// Gets the database instance, initializing it if necessary.
  ///
  /// This getter implements lazy initialization - the database is only
  /// created when it's first accessed. Subsequent calls return the
  /// existing instance.
  ///
  /// Returns:
  /// - The initialized [Database] instance.
  ///
  /// Throws:
  /// - [DatabaseException]: If database initialization fails.
  /// - [PathNotFoundException]: If database path cannot be determined.
  ///
  /// Example:
  /// ```dart
  /// final db = await dbManager.database;
  /// final users = await db.query('users');
  /// ```
  ///
  /// **Performance Note**: The first call may take longer as it creates
  /// the database file and tables. Subsequent calls are instant as they
  /// return the cached instance.
  Future<Database> get database async {
    // Return existing instance if already initialized
    if (_database != null) {
      return _database!;
    }

    // Initialize database on first access
    _database = await _initializeDatabase();
    return _database!;
  }

  // ==================== DATABASE INITIALIZATION ====================

  /// Initializes the database by creating or opening the database file.
  ///
  /// This method performs the following steps:
  /// 1. Determines the platform-specific database directory path
  /// 2. Constructs the full path to the database file
  /// 3. Opens the database (creates it if doesn't exist)
  /// 4. Executes the onCreate callback for initial setup
  ///
  /// Returns:
  /// - The initialized [Database] instance.
  ///
  /// Throws:
  /// - [DatabaseException]: If database creation/opening fails.
  /// - [PathNotFoundException]: If database directory cannot be found.
  ///
  /// **Database Location**:
  /// - Android: `/data/data/<package_name>/databases/`
  /// - iOS: `<Application Documents Directory>/`
  /// - Desktop: Platform-specific application data directory
  Future<Database> _initializeDatabase() async {
    // Get platform-specific database directory
    // Example paths:
    // Android: /data/data/com.example.app/databases/
    // iOS: /Users/.../Library/Application Support/databases/
    final databaseDirectoryPath = await getDatabasesPath();

    // Construct full database file path
    // join() ensures cross-platform path compatibility
    final databaseFilePath = join(
      databaseDirectoryPath,
      'currency_converter.db',
    );

    // Open or create the database
    return await openDatabase(
      databaseFilePath,
      version: _currentDatabaseVersion,
      onCreate: _onCreateDatabase,
      onUpgrade: _onUpgradeDatabase,
      onDowngrade: _onDowngradeDatabase,
    );
  }

  // ==================== DATABASE VERSION MANAGEMENT ====================

  /// Current version of the database schema.
  ///
  /// This should be incremented whenever the database schema changes.
  /// When the version number increases, the [_onUpgradeDatabase] callback
  /// will be triggered to handle migrations.
  ///
  /// **Version History**:
  /// - Version 1: Initial schema with users table
  static const int _currentDatabaseVersion = 1;

  /// Called when the database is created for the first time.
  ///
  /// This callback is executed only once when the app is first installed
  /// or when the database file is deleted and recreated.
  ///
  /// Parameters:
  /// - [db]: The database instance being created.
  /// - [version]: The version number (always equals [_currentDatabaseVersion]).
  ///
  /// **Responsibility**: Create all initial tables and seed initial data.
  ///
  /// Example flow:
  /// 1. User installs app
  /// 2. App first accesses database
  /// 3. onCreate is called
  /// 4. All tables are created
  Future<void> _onCreateDatabase(Database db, int version) async {
    // Create users table
    await UsersTable.createTable(db);

    // TODO: Add other table creations here as the app grows
    // Example:
    // await CurrenciesTable.createTable(db);
    // await ConversionsHistoryTable.createTable(db);
    // await FavoriteCurrenciesTable.createTable(db);

    // Optional: Insert seed data
    // await _insertSeedData(db);
  }

  /// Called when the database needs to be upgraded to a newer version.
  ///
  /// This callback is triggered when [_currentDatabaseVersion] is increased.
  /// It handles schema migrations to preserve existing data while updating
  /// the database structure.
  ///
  /// Parameters:
  /// - [db]: The database instance being upgraded.
  /// - [oldVersion]: The previous version number.
  /// - [newVersion]: The new version number.
  ///
  /// Example implementation for future migrations:
  /// ```dart
  /// Future<void> _onUpgradeDatabase(
  ///   Database db,
  ///   int oldVersion,
  ///   int newVersion,
  /// ) async {
  ///   if (oldVersion < 2) {
  ///     // Migration from version 1 to 2
  ///     await db.execute('ALTER TABLE users ADD COLUMN phone TEXT');
  ///   }
  ///
  ///   if (oldVersion < 3) {
  ///     // Migration from version 2 to 3
  ///     await ConversionsHistoryTable.createTable(db);
  ///   }
  /// }
  /// ```
  Future<void> _onUpgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Handle migrations based on version jumps
    // Each if block handles migration from a specific version

    // Example: Migrate from version 1 to 2
    // if (oldVersion < 2) {
    //   await _migrateToVersion2(db);
    // }

    // Example: Migrate from version 2 to 3
    // if (oldVersion < 3) {
    //   await _migrateToVersion3(db);
    // }
  }

  /// Called when the database needs to be downgraded to an older version.
  ///
  /// This is a rare scenario that typically occurs during development
  /// when rolling back to an older app version. In production, consider
  /// preventing downgrades by throwing an exception.
  ///
  /// Parameters:
  /// - [db]: The database instance being downgraded.
  /// - [oldVersion]: The previous (higher) version number.
  /// - [newVersion]: The new (lower) version number.
  ///
  /// **Warning**: Downgrading can cause data loss. Handle with care.
  Future<void> _onDowngradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Option 1: Prevent downgrades in production
    throw UnsupportedError(
      'Database downgrade from version $oldVersion to $newVersion is not supported. '
      'Please uninstall and reinstall the app.',
    );

    // Option 2: Allow downgrades (not recommended for production)
    // await _handleDowngrade(db, oldVersion, newVersion);
  }

  // ==================== DATABASE UTILITIES ====================

  /// Closes the database connection.
  ///
  /// This should be called when the app is being disposed or during testing.
  /// In most cases, you don't need to close the database as it will be
  /// closed automatically when the app terminates.
  ///
  /// Example:
  /// ```dart
  /// await dbManager.closeDatabase();
  /// ```
  ///
  /// **Warning**: After closing, the next call to [database] getter
  /// will reinitialize the database.
  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  /// Deletes the database file.
  ///
  /// This permanently removes the database file and all its data.
  /// Useful for:
  /// - Testing scenarios where you need a clean state
  /// - User-initiated data reset features
  /// - Development/debugging
  ///
  /// Returns `true` if deletion was successful.
  ///
  /// Example:
  /// ```dart
  /// // Reset app data
  /// await dbManager.deleteDatabase();
  /// // Database will be recreated on next access
  /// ```
  ///
  /// **Warning**: This is a destructive operation. All data will be lost.
  /// Consider backing up data before deletion or implementing soft reset.
  Future<bool> deleteDatabaseFile() async {
    try {
      // Close existing connection first
      await closeDatabase();

      // Get database path
      final databaseDirectoryPath = await getDatabasesPath();
      final databaseFilePath = join(
        databaseDirectoryPath,
        'currency_converter.db',
      );

      // Delete the database file
      await deleteDatabase(databaseFilePath);
      return true;
    } catch (e) {
      // Log error (consider using a logging package)
      print('Error deleting database: $e');
      return false;
    }
  }

  /// Checks if the database exists and is accessible.
  ///
  /// Returns `true` if the database has been initialized, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// if (dbManager.isDatabaseInitialized) {
  ///   print('Database is ready to use');
  /// }
  /// ```
  bool get isDatabaseInitialized => _database != null;

  /// Gets the current database version.
  ///
  /// Returns the version number of the initialized database.
  /// Returns `null` if database is not initialized yet.
  ///
  /// Example:
  /// ```dart
  /// final version = await dbManager.getDatabaseVersion();
  /// print('Database version: $version');
  /// ```
  Future<int?> getDatabaseVersion() async {
    if (_database == null) return null;
    return await _database!.getVersion();
  }
}

// ==================== MIGRATION EXAMPLES ====================

/*
 * MIGRATION STRATEGY GUIDELINES:
 *
 * When updating the database schema, follow these steps:
 *
 * 1. Increment [_currentDatabaseVersion]
 * 2. Add migration logic in [_onUpgradeDatabase]
 * 3. Test migration thoroughly with existing data
 * 4. Document the changes in version history
 *
 * Example Migration Scenarios:
 *
 * Adding a Column:
 * ```dart
 * await db.execute('ALTER TABLE users ADD COLUMN phone TEXT');
 * ```
 *
 * Creating a New Table:
 * ```dart
 * await db.execute('''
 *   CREATE TABLE favorites (
 *     id INTEGER PRIMARY KEY AUTOINCREMENT,
 *     user_id INTEGER,
 *     currency_code TEXT,
 *     FOREIGN KEY (user_id) REFERENCES users (id)
 *   )
 * ''');
 * ```
 *
 * Renaming a Column (SQLite limitation workaround):
 * ```dart
 * // 1. Create new table with correct schema
 * // 2. Copy data from old table to new table
 * // 3. Drop old table
 * // 4. Rename new table to old table name
 * ```
 *
 * Data Migration:
 * ```dart
 * // Transform existing data
 * final users = await db.query('users');
 * for (final user in users) {
 *   await db.update('users',
 *     {'email': user['email'].toString().toLowerCase()},
 *     where: 'id = ?',
 *     whereArgs: [user['id']],
 *   );
 * }
 * ```
 *
 * TESTING MIGRATIONS:
 * 1. Test upgrading from each old version to the new version
 * 2. Verify data integrity after migration
 * 3. Test on different devices/platforms
 * 4. Keep backups of production databases during rollout
 */