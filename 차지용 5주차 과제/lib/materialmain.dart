
import 'package:flutter/material.dart';
import 'model/todolist.dart';
import 'todo_sqlite_database_provider.dart';
import 'TodoCrad.dart';

class MaterialMain extends StatefulWidget{

  const MaterialMain(
    {super.key, required this.title, required this.databaseProvider});
  final String title;
  final TodoSQLiteDatabaseProvider databaseProvider;
    @override
    State<MaterialMain> createState() => _MaterialMain();
}
class _MaterialMain extends State<MaterialMain>{
  Future<List<Todo>>? todolist;

  @override
  void initState(){ //todolist를 가지고옴
    super.initState();
    todolist = _gettodos();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: FutureBuilder(
            future: todolist,
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting){ //로딩중일 경우
                return const CircularProgressIndicator(); //로딩 표시
              }
              else if (snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasError){
                  return Text("Error: ${snapshot.error}");
                }
                else if(snapshot.hasData){
                  return ListView.separated( //구분선 생성
                    itemCount: (snapshot.data as List<Todo>).length,
                    separatorBuilder: (context, index){
                      return Divider(
                        color: Colors.black.withOpacity(0.8),
                        thickness: 1,
                        height: 1,
                      );
                    },
                    itemBuilder: (context, index){
                      Todo todo = (snapshot.data as List<Todo>)[index];
                      return GestureDetector(
                        onTap: () => _updateTodo(todo,), //사용자가 터치할때 호출되는 콜백함수
                        onLongPress: (){
                          _deleteTodo(Todo as Todo);
                        },
                        child: Dismissible(
                          //스와이프 기능
                          key: Key(todo.id.toString()),
                          direction: DismissDirection.endToStart, //우측->왼쪽
                          onDismissed: (direction){
                            _deleteTodo(todo);
                          },
                          background: Container(
                            color: Colors.red,
                            padding: const EdgeInsets.all(16), 
                            alignment: Alignment.centerRight, //오른쪽 정렬
                            child: const Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                          ),
                          child: Row(children: [
                            Expanded(child: TodoCard(todo: todo),
                            ),

                          ],
                          ),
                        ),
                        
                      );
                    },
                    ); 
                }
                else{
                  return const Text("Empty data");
                }
              }
              else{
                return Text("ConnectionState: ${snapshot.connectionState}");
              }
            },
        ),
        ),
      ),
      floatingActionButton:FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
        onPressed: (){
          _createtodos();
        },
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
  Future<List<Todo>> _gettodos(){
    return widget.databaseProvider.getTodos();
  }
  Future<void> _createtodos() async {
    Todo? todo  = await Navigator.of(context).pushNamed('/create') as Todo?;
    if(todo != null){
      widget.databaseProvider.insertTodo(todo);
      setState(() {
        todolist = _gettodos();
      },
      );
    }
  }
 Future<void> _updateTodo(Todo todo) async {
  TextEditingController tecAgeController = 
  TextEditingController(text: todo.age);

  Todo? res = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("${todo.id}: ${todo.name}, ${todo.major}"),
        content: StatefulBuilder(builder: (context, setDialogState) {
          return SizedBox(
            height: 160,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: tecAgeController,
                  decoration: const InputDecoration(
                    labelText: "나이",
                  ),
                ),
              ],
            ),
          );
        }),
        actions: [
          ElevatedButton(
            child: const Text("수정"),
            onPressed: () {
              todo.age = tecAgeController.text;
              Navigator.of(context).pop(todo);
            },
          ),
          ElevatedButton(
            child: const Text("취소"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  if (res != null) {
    Todo updateTodo = res;
    widget.databaseProvider.updateTodo(updateTodo);
    setState(() {
      todolist = _gettodos();
    });
  }
}


Future<void> _deleteTodo(Todo todo) async {
  bool? res = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("${todo.id}: ${todo.name}, ${todo.major}"),
        content: const Text("삭제할까요?"),
        actions: <Widget>[
          ElevatedButton(
            child: Text("삭제"),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          ElevatedButton(
            child: Text("취소"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
  if (res != null && res) {
    await widget.databaseProvider.deleteTodo(todo);
    setState(() {
      todolist = _gettodos();
    });
  } else {
    setState(() {
      todolist = _gettodos();
    });
  }
}
}