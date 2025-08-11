import 'dart:async';

import 'package:compile_todo_app/providesrs/todo_providers.dart' hide TodoStats;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/todo_stats.dart' show TodoStats;
import '../widgets/todo_item.dart' hide Todo;
import '../widgets/todo_filters.dart';

class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchQueryProvider.notifier).state = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredTodos = ref.watch(filteredTodosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Todo Showcase'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search TextField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search todos',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: _onSearchChanged,
              ),
            ),

            const TodoStats(),
            const TodoFilters(),

            // Add todo section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter a new todo...',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) => _addTodo(value),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _addTodo(_controller.text),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),

            // Use Expanded ONLY here to fill the rest of the screen with the list
            Expanded(
              child: filteredTodos.isEmpty
                  ? Center(
                      child: Text(
                        'No todos yet!\nAdd one above to get started.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredTodos.length,
                      itemBuilder: (context, index) {
                        final todo = filteredTodos[index];
                        return TodoItem(todo: todo);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _addTodo(String title) {
    if (title.trim().isNotEmpty) {
      ref.read(todoListProvider.notifier).addTodo(title);
      _controller.clear();
    }
  }
}
