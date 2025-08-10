// lib/models/todo.dart
class Todo {
  final String id;
  final String title;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  // This is the key method for immutable updates
  Todo copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Todo && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
