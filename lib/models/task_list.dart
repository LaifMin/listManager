import 'task_item.dart';

enum Priority { a, b, c }

class TaskList {
  String id;
  String name;
  Priority priority;
  String date;
  String? deadline;
  bool isActive;
  List<TaskItem> tasks;

  TaskList({
    required this.id,
    required this.name,
    this.priority = Priority.a,
    required this.date,
    this.deadline,
    this.isActive = true,
    List<TaskItem>? tasks,
  }) : tasks = tasks ?? [];

  int get completedCount => tasks.where((t) => t.isCompleted).length;
  int get totalCount => tasks.length;
  double get efficiency =>
      totalCount == 0 ? 0.0 : (completedCount / totalCount) * 100;

  String get priorityLabel {
    switch (priority) {
      case Priority.a:
        return 'A';
      case Priority.b:
        return 'B';
      case Priority.c:
        return 'C';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'priority': priority.index,
      'date': date,
      'deadline': deadline,
      'isActive': isActive,
      'tasks': tasks.map((t) => t.toJson()).toList(),
    };
  }

  factory TaskList.fromJson(Map<String, dynamic> json) {
    return TaskList(
      id: json['id'] as String,
      name: json['name'] as String,
      priority: Priority.values[json['priority'] as int? ?? 0],
      date: json['date'] as String,
      deadline: json['deadline'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((t) => TaskItem.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
