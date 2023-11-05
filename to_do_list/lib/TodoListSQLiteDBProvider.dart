import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/todo.dart';

//Todolist DB 관리하는 클래스
class TodoListSQLiteDBProvider {
  static const String DATABASE_FILENAME = "todoList_database.db";
  static const String TODOLIST_TABLENAME = "todoList";

  static TodoListSQLiteDBProvider databaseProvider =
      TodoListSQLiteDBProvider._();
  static Database? _database;

  TodoListSQLiteDBProvider._();

  static TodoListSQLiteDBProvider getDatabaseProvider() => databaseProvider;

  Future<Database> _getDatabase() async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), DATABASE_FILENAME),
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
            CREATE TABLE $TODOLIST_TABLENAME(
              id INTEGER PRIMARY KEY, 
              title TEXT, 
              content TEXT,
              due_to TEXT)
               ''');
      },
    );
  }

  Future<int> insertTodo(Todo todo) async {
    Database database = await _getDatabase();
    return database.insert(TODOLIST_TABLENAME, todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Todo>> getTodo() async {
    Database database = await _getDatabase();
    var maps = await database.query(TODOLIST_TABLENAME);

    List<Todo> todoList = List.empty(growable: true);
    for (Map<String, dynamic> map in maps) {
      todoList.add(Todo.fromMap(map));
    }
    return todoList;
  }

  Future<void> updateTodo(Todo todo) async {
    Database database = await _getDatabase();
    database.update(TODOLIST_TABLENAME, todo.toMap(),
        where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<void> deleteTodo(Todo todo) async {
    Database database = await _getDatabase();
    database.delete(TODOLIST_TABLENAME, where: 'id = ?', whereArgs: [todo.id]);
  }
}
