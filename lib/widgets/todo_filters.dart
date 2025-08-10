// lib/widgets/todo_filters.dart
import 'package:compile_todo_app/providesrs/todo_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class TodoFilters extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(todoFilterProvider);
    final stats = ref.watch(todoStatsProvider);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _FilterChip(
                  label: 'All (${stats.total})',
                  isSelected: currentFilter == TodoFilter.all,
                  onTap: () => ref.read(todoFilterProvider.notifier).state = TodoFilter.all,
                ),
                _FilterChip(
                  label: 'Active (${stats.active})',
                  isSelected: currentFilter == TodoFilter.active,
                  onTap: () => ref.read(todoFilterProvider.notifier).state = TodoFilter.active,
                ),
                _FilterChip(
                  label: 'Completed (${stats.completed})',
                  isSelected: currentFilter == TodoFilter.completed,
                  onTap: () => ref.read(todoFilterProvider.notifier).state = TodoFilter.completed,
                ),
              ],
            ),
          ),
          if (stats.completed > 0)
            TextButton(
              onPressed: () {
                ref.read(todoListProvider.notifier).clearCompleted();
              },
              child: Text('Clear Completed'),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).primaryColor 
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
