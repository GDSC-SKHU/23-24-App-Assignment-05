class Todo {
  int? id;
  String? name;
  String? age;
  String? major;

  Todo({
    required this.name,
    required this.major,
    required this.age,
  });
  Todo.fromMap(Map<String, dynamic> map){
    id = map["id"];
    name = map["name"];
    major = map["major"];
    age = map["age"];
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name" : name,
      "major" : major,
      "age": age,
    };
  }
}
