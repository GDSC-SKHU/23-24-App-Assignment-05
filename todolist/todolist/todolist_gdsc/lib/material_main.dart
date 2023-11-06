import 'package:flutter/material.dart';
import 'Model/todo.dart';
import 'Util/TodoSQLiteDatabaseProvider.dart';

class TodoMaterialMain extends StatefulWidget {
  const TodoMaterialMain({
    Key? key,
    required this.title,
    required this.databaseProvider,
  }) : super(key: key);

  final String title;
  final TodoSQLiteDatabaseProvider databaseProvider;

  @override
  State<TodoMaterialMain> createState() => _TodoMaterialMain();
}

class _TodoMaterialMain extends State<TodoMaterialMain> {
  Future<List<Todo>>? todoList;

  @override
  void initState() {
    super.initState();
    todoList = _getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _createTodo(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: Text('Add New Todo', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: todoList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (snapshot.hasData) {
                      return ListView.separated(
                        itemCount: (snapshot.data as List<Todo>).length,
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.grey,
                            thickness: 1,
                            height: 1,
                          );
                        },
                        itemBuilder: (context, index) {
                          Todo todo = (snapshot.data as List<Todo>)[index];
                          return Card(
                            elevation: 5,
                            child: ListTile(
                              leading: Icon(Icons.task, color: Colors.orange),
                              title: Text(
                                todo.title ?? "No Title",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("Description: ${todo.description}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      _deleteTodo(todo);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    color: Colors.blue,
                                    onPressed: () {
                                      _editTodo(context, todo);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Text("Empty data");
                    }
                  } else {
                    return Text("ConnectionState: ${snapshot.connectionState}");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Todo>> _getTodos() {
    return widget.databaseProvider.getTodos();
  }

  Future<void> _createTodo(BuildContext context) async {
    Todo? todo = await Navigator.of(context).pushNamed('/create') as Todo?;
    if (todo != null) {
      widget.databaseProvider.insertTodo(todo);
      setState(() {
        todoList = _getTodos();
      });
    }
  }

  Future<void> _deleteTodo(Todo todo) async {
    bool? res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${todo.id}: ${todo.title}"),
          content: const Text("Delete this todo?"),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            ElevatedButton(
              child: const Text("Cancel"),
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
      setState(() {
        todoList = _getTodos();
      });
    } else {
      setState(() {
        todoList = _getTodos();
      });
    }
  }


  Future<void> _editTodo(BuildContext context, Todo todo) async {
    Todo? editedTodo = await Navigator.of(context).pushNamed('/edit', arguments: todo) as Todo?;
    if (editedTodo != null) {
      widget.databaseProvider.updateTodo(editedTodo);
      setState(() {
        todoList = _getTodos();
      });
    }
  }
  
}
