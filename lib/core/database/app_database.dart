import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static const String _dbName = 'blog_app.db';
  static const int _dbVersion = 1;

  // Table and Column constants to avoid typos
  static const String tableBlogs = 'blogs';
  static const String colId = 'id';
  static const String colPosterId = 'poster_id';
  static const String colTitle = 'title';
  static const String colContent = 'content';
  static const String colImageUrl = 'image_url';
  // Topics will store as JSON string
  static const String colTopics = 'topics';
  static const String colUpdatedAt = 'updated_at';

  Future<Database> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableBlogs (
            $colId TEXT PRIMARY KEY,
            $colPosterId TEXT NOT NULL,
            $colTitle TEXT NOT NULL,
            $colContent TEXT NOT NULL,
            $colImageUrl TEXT NOT NULL,
            $colTopics TEXT NOT NULL,
            $colUpdatedAt TEXT NOT NULL
          )
        ''');
      },
    );
  }
}
