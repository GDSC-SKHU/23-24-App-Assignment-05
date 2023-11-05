import 'package:flutter/material.dart';
import 'model/todolist.dart';
import 'todo_sqlite_database_provider.dart';
import 'TodoCreate.dart';
import 'materialmain.dart';
import 'TodoCrad.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    TodoSQLiteDatabaseProvider databaseProvider =
        TodoSQLiteDatabaseProvider.getDatabaseProvider();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MaterialMain(
              title: 'Todo List',
              databaseProvider: databaseProvider,
            ),
        '/create': (context) => const TodoCreate(title: '항목'),
      },
    );
  }
}
