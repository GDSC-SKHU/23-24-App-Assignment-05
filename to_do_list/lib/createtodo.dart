import 'package:flutter/material.dart';
import 'package:to_do_list/todo.dart';

//todoList 만드는 클래스
class CreateTodoList extends StatefulWidget {
  const CreateTodoList({super.key, required this.title});

  final String title;

  @override
  State<CreateTodoList> createState() => _CreateTodoList();
}

class _CreateTodoList extends State<CreateTodoList> {
  final TextEditingController _textTitleController = TextEditingController();
  final TextEditingController _textContentController = TextEditingController();
  final TextEditingController _textDueToController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            child: Column(
          children: [
            TextField(
              controller: _textTitleController,
              decoration: const InputDecoration(
                labelText: "제목 : ",
              ),
            ),
            TextField(
              controller: _textContentController,
              decoration: const InputDecoration(
                labelText: "내용 : ",
              ),
            ),
            TextField(
              controller: _textDueToController,
              decoration: const InputDecoration(
                labelText: "기한 : ",
              ),
            ),
            ElevatedButton(
                child: const Text("저장"),
                onPressed: () {
                  if (_textContentController.value.text.isEmpty ||
                      _textTitleController.value.text.isEmpty ||
                      _textDueToController.value.text.isEmpty) return;

                  Todo todo = Todo(
                      title: _textTitleController.value.text,
                      content: _textContentController.value.text,
                      due_to: _textDueToController.value.text);
                  Navigator.of(context).pop(todo);
                }),
          ],
        )));
  }
}
