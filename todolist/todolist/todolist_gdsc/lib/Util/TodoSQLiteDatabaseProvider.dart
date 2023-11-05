import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todolist_gdsc/Model/todo.dart';

class TodoSQLiteDatabaseProvider {
  static const String DATABASE_FILENAME = "todo_database.db";
  static const String TODOS_TABLENAME = "todos";

  static TodoSQLiteDatabaseProvider databaseProvider = TodoSQLiteDatabaseProvider._();
  static Database? _database;

  TodoSQLiteDatabaseProvider._();

  static TodoSQLiteDatabaseProvider getDatabaseProvider() => databaseProvider;

  Future<Database> _getDatabase() async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), DATABASE_FILENAME),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $TODOS_TABLENAME(
            id INTEGER PRIMARY KEY, 
            title TEXT, 
            description TEXT)
            ''',
        );
      },
    );
  }

  Future<void> insertTodo(Todo todo) async {
    Database database = await _getDatabase();
    database.insert(TODOS_TABLENAME, todo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Todo>> getTodos() async {
    Database database = await _getDatabase();
    var maps = await database.query(TODOS_TABLENAME);

    List<Todo> todoList = List.empty(growable: true);
    for (Map<String, dynamic> map in maps) {
      todoList.add(Todo.fromMap(map));
    }
    return todoList;
  }

  Future<void> updateTodo(Todo todo) async {
    Database database = await _getDatabase();
    database.update(
      TODOS_TABLENAME,
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo(Todo todo) async {
    Database database = await _getDatabase();
    database.delete(TODOS_TABLENAME, where: 'id = ?', whereArgs: [todo.id]);
  }
}
