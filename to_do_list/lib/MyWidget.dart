import 'package:flutter/material.dart';
import 'package:to_do_list/TodoListCard.dart';
import 'package:to_do_list/TodoListSQLiteDBProvider.dart';
import 'package:to_do_list/todo.dart';

// 메인화면 todoList들이 모아져 있는곳
class MyWidget extends StatefulWidget {
  const MyWidget(
      {super.key, required this.title, required this.databaseProvider});
  final String title;
  final TodoListSQLiteDBProvider databaseProvider;

  @override
  State<MyWidget> createState() => _MyWidget();
}

class _MyWidget extends State<MyWidget> {
  Future<List<Todo>>? todoList;

  @override
  void initState() {
    super.initState();
    todoList = _getTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
          future: todoList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (snapshot.hasData) {
                return ListView.separated(
                  itemCount: (snapshot.data as List<Todo>).length,
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.black.withOpacity(0.8),
                      thickness: 1,
                      height: 1,
                    );
                  },
                  itemBuilder: (context, index) {
                    Todo todo = (snapshot.data as List<Todo>)[index];
                    return GestureDetector(
                      onTap: () {
                        _updateTodo(todo);
                      },
                      onLongPress: () {
                        _deleteTodo(todo);
                      },
                      child: Dismissible(
                        // 스와이프 기능
                        key: Key(todo.id.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _deleteTodo(todo);
                        },
                        background: Container(
                          color: Colors.deepPurple,
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.centerRight,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TodoListCard(
                                todo: todo,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Text("Empty data");
              }
            } else {
              return Text("ConnectionState: ${snapshot.connectionState}");
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        onPressed: () {
          _createTodo();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<List<Todo>> _getTodo() {
    return widget.databaseProvider.getTodo();
  }

  Future<void> _createTodo() async {
    Todo? todo = await Navigator.of(context).pushNamed('/create') as Todo?;
    if (todo != null) {
      widget.databaseProvider.insertTodo(todo);
      setState(
        () {
          todoList = _getTodo();
        },
      );
    }
  }

  Future<void> _updateTodo(Todo todo) async {
    TextEditingController tecContentController =
        TextEditingController(text: todo.content);
    TextEditingController tecDuetoController =
        TextEditingController(text: todo.due_to);
    Todo? res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${todo.id}: ${todo.title}"),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return SizedBox(
                height: 150,
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: tecContentController,
                      decoration: const InputDecoration(labelText: "내용 : "),
                    ),
                    TextField(
                      controller: tecDuetoController,
                      decoration: const InputDecoration(labelText: "기한: "),
                    )
                  ],
                ),
              );
            },
          ),
          actions: [
            ElevatedButton(
              child: const Text("수정"),
              onPressed: () {
                todo.content = tecContentController.value.text;
                Navigator.of(context).pop(todo);
              },
            ),
            ElevatedButton(
              child: const Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );

    if (res != null) {
      Todo updatedDog = res;
      widget.databaseProvider.updateTodo(updatedDog);
      setState(
        () {
          todoList = _getTodo();
        },
      );
    }
  }

  Future<void> _deleteTodo(Todo todo) async {
    bool? res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${todo.id}: ${todo.title}"),
          content: const Text("삭제하시겠습니까?"),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("삭제"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            ElevatedButton(
              child: const Text("취소"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            )
          ],
        );
      },
    );

    if (res != null && res) {
      await widget.databaseProvider.deleteTodo(todo);
      setState(
        () {
          todoList = _getTodo();
        },
      );
    } else {
      setState(() {
        todoList = _getTodo();
      });
    }
  }
}
