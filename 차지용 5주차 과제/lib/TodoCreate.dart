    // ignore_for_file: avoid_unnecessary_containers

    import 'package:flutter/material.dart';
    import 'model/todolist.dart';



    class TodoCreate extends StatefulWidget {
      const TodoCreate({super.key, required this.title});
      final String title;
      
      @override
      State<TodoCreate> createState() => _TodoCreate();
    }

    class _TodoCreate extends State<TodoCreate> {
      final TextEditingController _tecAgeController = TextEditingController();
      final TextEditingController _tecNameController = TextEditingController();
      final TextEditingController _tecMajorController = TextEditingController();

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _tecNameController,
                      decoration: const InputDecoration(
                        labelText: "이름",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _tecMajorController,
                      decoration: const InputDecoration(
                        labelText: "전공",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _tecAgeController,
                      decoration: const InputDecoration(
                        labelText: "나이",
                      ),
                    ),
                  ),
                    ElevatedButton(
                      child: const Text("저장"),
                      onPressed: () {
                        if (_tecNameController.text.isEmpty ||
                            _tecAgeController.text.isEmpty || _tecMajorController.text.isEmpty) {
                          return;
                        }
                        Todo todo = Todo(
                          name: _tecNameController.text,
                          major: _tecMajorController.text,
                          age: _tecAgeController.text,
                        );
                        Navigator.of(context).pop(todo); // 데이터 반환
                      },
                    )
                ],
              ),
            ),
          ),
        );
      }
    }
