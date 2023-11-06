import 'package:flutter/material.dart';
import 'package:to_do_list/TodoListSQLiteDBProvider.dart';
import 'package:to_do_list/createtodo.dart';
import 'package:to_do_list/MyWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TodoListSQLiteDBProvider databaseProvider =
        TodoListSQLiteDBProvider.getDatabaseProvider();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'todo_list',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ), // 네비게이션을 이용해 화면 전환
        initialRoute: '/',
        routes: {
          '/': (context) => MyWidget(
                title: 'todo_list',
                databaseProvider: databaseProvider,
              ),
          '/create': (context) => const CreateTodoList(title: 'todo Create'),
        });
  }
}
