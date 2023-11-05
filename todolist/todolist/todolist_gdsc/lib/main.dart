import 'package:flutter/material.dart';
import 'package:todolist_gdsc/Model/todo.dart';
import 'package:todolist_gdsc/Util/TodoSQLiteDatabaseProvider.dart';
import 'Todo_create.dart';
import 'material_main.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    TodoSQLiteDatabaseProvider databaseProvider =
        TodoSQLiteDatabaseProvider.getDatabaseProvider();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODOLIST',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => TodoMaterialMain(
              title: 'Todo List',
              databaseProvider: databaseProvider,
            ),
        '/create': (context) => const TodoCreate(title: 'Add New Todo'),
      },
    );
  }
}
