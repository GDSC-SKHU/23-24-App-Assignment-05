// TodoList 작성할 때 필요한 변수 선언한 클래스
class Todo {
  int? id;
  String? title;
  String? content;
  String? due_to;

  Todo({
    this.id,
    this.title,
    this.content,
    this.due_to,
  });
  // Map을 객체로 만들어 줌
  Todo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    content = map['content'];
    due_to = map['due_to'];
  }
  // 객체를 Map으로 만들어 줌
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'due_to': due_to,
    };
  }
}
