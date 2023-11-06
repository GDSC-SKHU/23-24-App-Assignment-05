import 'package:flutter/material.dart';
import 'package:todolist_gdsc/Model/todo.dart';

class TodoCreate extends StatefulWidget {
  const TodoCreate({super.key, required this.title});
  final String title;

  @override
  State<TodoCreate> createState() => _TodoCreate();
}

class _TodoCreate extends State<TodoCreate> {
  final TextEditingController _tecTitleController = TextEditingController();
  final TextEditingController _tecDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: _tecTitleController,
                  decoration: InputDecoration(
                    labelText: "Todo Title",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: _tecDescriptionController,
                  decoration: InputDecoration(
                    labelText: "Todo Description",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  if (_tecTitleController.value.text.isEmpty ||
                      _tecDescriptionController.value.text.isEmpty) {
                    return;
                  }
                  Todo todo = Todo(
                    title: _tecTitleController.value.text,
                    description: _tecDescriptionController.value.text,
                  );
                  Navigator.of(context).pop(todo);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
