// lib/widgets/todo_stats.dart
import 'package:compile_todo_app/providesrs/todo_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class TodoStats extends ConsumerWidget {
  const TodoStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Key concept: Watching computed provider
    final stats = ref.watch(todoStatsProvider);
    
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: 'Total',
            value: stats.total,
            color: Colors.blue,
          ),
          _StatItem(
            label: 'Active',
            value: stats.active,
            color: Colors.orange,
          ),
          _StatItem(
            label: 'Completed',
            value: stats.completed,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
