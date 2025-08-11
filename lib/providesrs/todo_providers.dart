import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';

// Todo List StateNotifier
class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier() : super([]);

  void addTodo(String title) {
    if (title.trim().isEmpty) return;

    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );

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

// Filter enum
enum TodoFilter { all, active, completed }

// Filter state provider
final todoFilterProvider = StateProvider<TodoFilter>((ref) => TodoFilter.all);

// Search query provider (for debounced search text)
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filtered todos computed provider (uses filter & search query)
final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoListProvider);
  final filter = ref.watch(todoFilterProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  // Filter todos by status
  List<Todo> filtered;
  switch (filter) {
    case TodoFilter.all:
      filtered = todos;
      break;
    case TodoFilter.active:
      filtered = todos.where((todo) => !todo.isCompleted).toList();
      break;
    case TodoFilter.completed:
      filtered = todos.where((todo) => todo.isCompleted).toList();
      break;
  }

  // Further filter by search query (title contains query)
  if (searchQuery.isNotEmpty) {
    filtered = filtered.where((todo) => todo.title.toLowerCase().contains(searchQuery)).toList();
  }

  return filtered;
});

// Stats provider
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
