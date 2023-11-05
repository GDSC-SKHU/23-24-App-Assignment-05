

import 'model/todolist.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TodoSQLiteDatabaseProvider {
  // 데이터베이스 파일 이름 및 테이블 이름 상수 정의
  static const String DATABASE_FILENAME = "todo_database.db";
  static const String TODOS_TABLENAME = "todos";

  // 데이터베이스 제공자의 인스턴스를 저장하는 정적 변수
  static TodoSQLiteDatabaseProvider databaseProvider =
      TodoSQLiteDatabaseProvider._();
  static Database? _database; // 데이터베이스 객체

  // 생성자
  TodoSQLiteDatabaseProvider._();

  // 데이터베이스 제공자의 인스턴스를 반환하는 정적 메서드
  static TodoSQLiteDatabaseProvider getDatabaseProvider() => databaseProvider;

  // 데이터베이스를 가져오는 비동기 메서드
  Future<Database> _getDatabase() async {
    return _database ??=
        await _initDatabase(); // null인 경우 _initDatabase()의 반환값을 _database에 저장하고 반환
  }

  // 데이터베이스 초기화 메서드
  Future<Database> _initDatabase() async {
    // 데이터베이스를 초기화하고 테이블을 생성
    return openDatabase(
      join(await getDatabasesPath(), DATABASE_FILENAME),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $TODOS_TABLENAME(
            id INTEGER PRIMARY KEY, 
            name TEXT, 
            age TEXT,
            major TEXT)
            ''',
        );
      },
    );
  }

  // Todo 객체를 데이터베이스에 삽입하는 메서드
  Future<void> insertTodo(Todo todo) async {
    Database database = await _getDatabase();
    database.insert(TODOS_TABLENAME, todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // 데이터베이스에서 모든 Todo 항목을 가져오는 메서드
  Future<List<Todo>> getTodos() async {
    Database database = await _getDatabase();
    var maps = await database.query(TODOS_TABLENAME);

    List<Todo> todoList = List.empty(growable: true);
    for (Map<String, dynamic> map in maps) {
      todoList.add(Todo.fromMap(map)); // Map을 객체로 변환 후 todoList에 추가
    }
    return todoList;
  }

  // Todo 항목을 업데이트하는 메서드
  Future<void> updateTodo(Todo todo) async {
    Database database = await _getDatabase();
    database.update(
      TODOS_TABLENAME,
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  // Todo 항목을 삭제하는 메서드
  Future<void> deleteTodo(Todo todo) async {
    Database database = await _getDatabase();
    database.delete(TODOS_TABLENAME, where: 'id = ?', whereArgs: [todo.id]);
  }
}