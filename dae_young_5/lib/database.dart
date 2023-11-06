import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DB {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'todolist.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // 새로운 저널 만들어내는곳
  static Future<int> createItem(String title, String? descrption) async {
    final db = await DB.db();

    final data = {'title': title, 'description': descrption};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // 모든 저널 읽는곳
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DB.db();
    return db.query('items', orderBy: "id");
  }

  // 저널에 따라서 업데이트 하는곳
  static Future<int> updateItem(
      int id, String title, String? descrption) async {
    final db = await DB.db();

    final data = {
      'title': title,
      'description': descrption,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // 삭제하는곳
  static Future<void> deleteItem(int id) async {
    final db = await DB.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
