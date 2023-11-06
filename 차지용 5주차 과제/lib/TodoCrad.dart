import 'package:flutter/material.dart';
import 'model/todolist.dart';


class TodoCard extends StatelessWidget {
  final Todo todo;

  TodoCard({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text("${todo.name}"),
        subtitle: Text("${todo.major}"),
        trailing: Text("${todo.age}"),
      ),
    );
  }
}
