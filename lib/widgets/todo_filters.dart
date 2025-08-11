import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:compile_todo_app/providesrs/todo_providers.dart';

class TodoFilters extends ConsumerWidget {
  const TodoFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(todoFilterProvider);
    final stats = ref.watch(todoStatsProvider);

    // Ensure progress is between 0 and 1
    double progress = (stats.total > 0) ? stats.completed / stats.total : 0.0;
    progress = progress.clamp(0.0, 1.0);

    double safeRatio(int part, int total) => total > 0 ? part / total : 0;

    Widget buildStatBar(String label, int count, Color color, double percent) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: percent,
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(count.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: color, fontSize: 14)),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // ---- Stats Bars Row ----
          Row(
            children: [
              buildStatBar("Status", stats.total, Colors.blue, 1),
              const SizedBox(width: 16),
              buildStatBar("Priority", stats.active, Colors.orange,
                  safeRatio(stats.active, stats.total)),
              const SizedBox(width: 16),
              buildStatBar("Category", stats.completed, Colors.green,
                  safeRatio(stats.completed, stats.total)),
              if (stats.completed > 0)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    ref.read(todoListProvider.notifier).clearCompleted();
                  },
                  child: const Text(
                    'Clear',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // ---- Progress Bar with Percentage ----
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${(progress * 100).toStringAsFixed(0)}% completed',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),

              // Animate the progress bar when the progress value changes
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: progress),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                builder: (context, value, _) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 12,
                      backgroundColor: Colors.grey.shade300,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.green.shade400),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ---- Filters Row ----
          Row(
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
        ],
      ),
    );
  }
}

// ----- Filter Chip Widget -----
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
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
