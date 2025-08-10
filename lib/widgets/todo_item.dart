// lib/widgets/todo_item.dart
import 'package:compile_todo_app/providesrs/todo_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';


class TodoItem extends ConsumerWidget {
  final Todo todo;

  const TodoItem({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (value) {
            // Key concept: ref.read() for actions
            ref.read(todoListProvider.notifier).toggleTodo(todo.id);
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted 
                ? TextDecoration.lineThrough 
                : TextDecoration.none,
            color: todo.isCompleted 
                ? Colors.grey 
                : null,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            ref.read(todoListProvider.notifier).deleteTodo(todo.id);
          },
        ),
      ),
    );
  }
}
