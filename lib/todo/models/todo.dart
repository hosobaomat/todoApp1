import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
enum TaskCategory {
  @HiveField(0)
  study,
  @HiveField(1)
  work,
  @HiveField(2)
  family,
  @HiveField(3)
  health,
  @HiveField(4)
  shopping,
  @HiveField(5)
  other,
}

@HiveType(typeId: 1)
class Todo extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  TaskCategory category;

  @HiveField(4)
  DateTime startTime;

  @HiveField(5)
  DateTime endTime;

  @HiveField(6)
  String username;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.category,
    required this.startTime,
    required this.endTime,
    required this.username,
  });

  Todo copyWith({
    int? id,
    String? title,
    bool? isCompleted,
    TaskCategory? category,
    DateTime? startTime,
    DateTime? endTime,
    String? username,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      username: username ?? this.username,
    );
  }
}
