import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/shopping_item.dart';

// Add these imports for desktop support
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Database helper class for managing SQLite database operations.
/// Implements singleton pattern to ensure single database instance.
class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Factory constructor returns singleton instance
  factory DatabaseHelper() {
    return _instance;
  }

  // Private constructor
  DatabaseHelper._internal();

  /// Get database instance, creates if doesn't exist
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Initialize ffi for desktop platforms
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    // Get database path
    String path = join(await getDatabasesPath(), 'shopping_list.db');

    // Open database
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Create database table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE shopping_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');
  }

  /// Insert a shopping item into database
  /// Returns the id of the inserted item
  Future<int> insertItem(ShoppingItem item) async {
    Database db = await database;
    return await db.insert('shopping_items', item.toMap());
  }

  /// Get all shopping items from database
  /// Returns list of ShoppingItem objects
  Future<List<ShoppingItem>> getAllItems() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('shopping_items');

    return List.generate(maps.length, (i) {
      return ShoppingItem.fromMap(maps[i]);
    });
  }

  /// Delete a shopping item from database
  /// Returns number of rows affected
  Future<int> deleteItem(int id) async {
    Database db = await database;
    return await db.delete(
      'shopping_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete all items from database
  Future<int> deleteAllItems() async {
    Database db = await database;
    return await db.delete('shopping_items');
  }

  /// Close database connection
  Future<void> close() async {
    Database db = await database;
    db.close();
  }
}