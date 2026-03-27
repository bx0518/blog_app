import 'dart:convert';

import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:sqflite/sqflite.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});
  Future<List<BlogModel>> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Database database;
  BlogLocalDataSourceImpl(this.database);

  @override
  Future<List<BlogModel>> loadBlogs() async {
    // Query the table for all blogs
    final List<Map<String, dynamic>> maps = await database.query('blogs');

    if (maps.isEmpty) return [];

    return maps.map((json) {
      // Create a mutable copy because Sqflite maps are read-only
      final Map<String, dynamic> blogMap = Map<String, dynamic>.from(json);

      // SQLite stores lists as Strings, so we decode back to List<String>
      if (blogMap['topics'] is String) {
        blogMap['topics'] = jsonDecode(blogMap['topics'] as String);
      }

      return BlogModel.fromJson(blogMap);
    }).toList();
  }

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) async {
    // Use a Transaction/Batch for better performance and data integrity
    final batch = database.batch();

    // Clear old cache before adding new data
    batch.delete('blogs');

    for (final blog in blogs) {
      final blogMap = blog.toJson();
      // Convert List to JSON string for SQLite storage
      blogMap['topics'] = jsonEncode(blogMap['topics']);

      batch.insert(
        'blogs',
        blogMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }
}
