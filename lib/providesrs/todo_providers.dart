// lib/providers/todo_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';

// 1. StateNotifierProvider for complex state (todo list)
class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier() : super([]);

  void addTodo(String title) {
    if (title.trim().isEmpty) return;
    
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );
    
    // Key concept: Create new state, don't modify existing
    state = [...state, newTodo];
  }

  void toggleTodo(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          todo.copyWith(isCompleted: !todo.isCompleted)
        else
          todo,
    ];
  }

  void deleteTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }

  void clearCompleted() {
    state = state.where((todo) => !todo.isCompleted).toList();
  }
}

final todoListProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>((ref) {
  return TodoListNotifier();
});

// 2. StateProvider for simple state (filter)
enum TodoFilter { all, active, completed }

final todoFilterProvider = StateProvider<TodoFilter>((ref) => TodoFilter.all);

// 3. Provider for computed values (filtered todos)
final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoListProvider);
  final filter = ref.watch(todoFilterProvider);

  switch (filter) {
    case TodoFilter.all:
      return todos;
    case TodoFilter.active:
      return todos.where((todo) => !todo.isCompleted).toList();
    case TodoFilter.completed:
      return todos.where((todo) => todo.isCompleted).toList();
  }
});

// 4. Provider for statistics (computed values)
final todoStatsProvider = Provider<TodoStats>((ref) {
  final todos = ref.watch(todoListProvider);
  
  final total = todos.length;
  final completed = todos.where((todo) => todo.isCompleted).length;
  final active = total - completed;
  
  return TodoStats(
    total: total,
    completed: completed,
    active: active,
  );
});

class TodoStats {
  final int total;
  final int completed;
  final int active;

  TodoStats({
    required this.total,
    required this.completed,
    required this.active,
  });
}
