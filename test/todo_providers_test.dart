// test/todo_providers_test.dart
import 'package:compile_todo_app/providesrs/todo_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
  group('TodoListNotifier', () {
    late ProviderContainer container;
    late TodoListNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(todoListProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('should start with empty list', () {
      final todos = container.read(todoListProvider);
      expect(todos, isEmpty);
    });

    test('should add todo', () {
      notifier.addTodo('Test todo');
      
      final todos = container.read(todoListProvider);
      expect(todos, hasLength(1));
      expect(todos.first.title, 'Test todo');
      expect(todos.first.isCompleted, false);
    });

    test('should toggle todo', () {
      notifier.addTodo('Test todo');
      final todos = container.read(todoListProvider);
      final todoId = todos.first.id;
      
      notifier.toggleTodo(todoId);
      
      final updatedTodos = container.read(todoListProvider);
      expect(updatedTodos.first.isCompleted, true);
    });

    test('should delete todo', () {
      notifier.addTodo('Test todo');
      final todos = container.read(todoListProvider);
      final todoId = todos.first.id;
      
      notifier.deleteTodo(todoId);
      
      final updatedTodos = container.read(todoListProvider);
      expect(updatedTodos, isEmpty);
    });
  });

  group('Computed Providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should calculate stats correctly', () {
      final notifier = container.read(todoListProvider.notifier);
      
      notifier.addTodo('Todo 1');
      notifier.addTodo('Todo 2');
      notifier.addTodo('Todo 3');
      
      final todos = container.read(todoListProvider);
      notifier.toggleTodo(todos.first.id); // Complete one
      
      final stats = container.read(todoStatsProvider);
      expect(stats.total, 3);
      expect(stats.completed, 1);
      expect(stats.active, 2);
    });

    test('should filter todos correctly', () {
      final notifier = container.read(todoListProvider.notifier);
      
      notifier.addTodo('Active todo');
      notifier.addTodo('Completed todo');
      
      final todos = container.read(todoListProvider);
      notifier.toggleTodo(todos.last.id); // Complete last one
      
      // Test active filter
      container.read(todoFilterProvider.notifier).state = TodoFilter.active;
      final activeTodos = container.read(filteredTodosProvider);
      expect(activeTodos, hasLength(1));
      expect(activeTodos.first.title, 'Active todo');
      
      // Test completed filter
      container.read(todoFilterProvider.notifier).state = TodoFilter.completed;
      final completedTodos = container.read(filteredTodosProvider);
      expect(completedTodos, hasLength(1));
      expect(completedTodos.first.title, 'Completed todo');
    });
  });
}
