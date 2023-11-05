class Todo {
  int? id;
  String? title;
  String? description;

  Todo({
    this.id,
    this.title,
    this.description, DateTime? dueDate,
  });

  Todo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}
