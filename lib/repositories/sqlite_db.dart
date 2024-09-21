import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_knovator/model/post_model.dart';

class SqliteDb {
  Future<Database> initializeDB() async {
    final path = await getDatabasesPath();

    return openDatabase(
      join(path, 'post_database.db'),
      version: 1,
      onCreate: (db, version) async {
        // log('Initializing sqlite db');
        await db.execute(
          "CREATE TABLE posts ("
          "id INTEGER PRIMARY KEY, "
          "userId INTEGER, "
          "title TEXT, "
          "body TEXT, "
          "is_read INTEGER NULL"
          ")",
        );
      },
    );
  }

  Future<List<Post>> getPosts() async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('posts');
    // log('Post result: $queryResult');
    final list = queryResult.map((e) => Post.fromLocalMap(e)).toList();
    return list;
  }

  Future<int> addPost(Post post) async {
    final db = await initializeDB();
    final id = await db.insert(
      'posts',
      post.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    // log('Insert id: $id');
    return id;
  }

  Future<void> storeToLocal(List<Post> posts) async {
    for (Post post in posts) {
      // log('Storing to local: $post');
      await addPost(post);
    }
  }

  Future<bool> markAsRead(int postId) async {
    final db = await initializeDB();
    final r = await db.rawUpdate(
      'UPDATE posts SET is_read = 1 WHERE id = $postId',
    );
    return r >= 0;
  }
}
