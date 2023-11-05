import 'package:flutter/material.dart';
import 'package:todolist_gdsc/Model/todo.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;

  TodoCard({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.task),
        title: Text(
          todo.title ?? "No Title",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          "Description: ${todo.description}",
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }
}
