import 'package:flutter/material.dart';
import 'package:to_do_list/todo.dart';

//todolist를 수정할 때 사용하는 클래스
class TodoListCard extends StatelessWidget {
  const TodoListCard({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              todo.title!,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "내용:  ${todo.content}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "기한: ${todo.due_to}",
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
