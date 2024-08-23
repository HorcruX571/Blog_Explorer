import 'package:sqflite/sqflite.dart';
import '../models/blog.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize your database with a new version to handle schema changes
    final db = await openDatabase(
      'blogs.db',
      version: 2, // Increment the version number to apply schema changes
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE blogs (
            id TEXT PRIMARY KEY,
            title TEXT,
            imageUrl TEXT,
            category TEXT,
            content TEXT,  // Added content column
            isFavorite INTEGER
          )
        ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          // Handle schema migration if the old version is less than 2
          await db.execute('ALTER TABLE blogs ADD COLUMN content TEXT');
        }
      },
    );
    return db;
  }

  Future<void> insertBlog(Blog blog) async {
    final db = await database;
    await db.insert(
      'blogs',
      blog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Blog?> getBlogById(String id) async {
    final db = await database;
    final maps = await db.query(
      'blogs',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Blog.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Blog>> fetchBlogs() async {
    final db = await database;
    final maps = await db.query('blogs');

    if (maps.isNotEmpty) {
      return maps.map((blog) => Blog.fromMap(blog)).toList();
    } else {
      return [];
    }
  }

  Future<void> deleteAllBlogs() async {
    final db = await database;
    await db.delete('blogs');
  }
}
