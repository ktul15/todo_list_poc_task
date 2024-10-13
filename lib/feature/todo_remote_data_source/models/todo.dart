class Todo {
  String? text;
  DateTime? date;
  String? priority;
  bool? isCompleted;

  Todo({this.text, this.date, this.priority, this.isCompleted});

  Todo.fromJson(Map<String, dynamic> json) {
    text = json['title'];
    date = DateTime.tryParse(json['date'] ?? "");
    priority = json['priority'];
    isCompleted = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.text;
    data['date'] = this.date.toString();
    data['priority'] = this.priority;
    data['isCompleted'] = this.isCompleted;
    return data;
  }
}
