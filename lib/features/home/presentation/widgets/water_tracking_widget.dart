import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class WaterTrackingWidget extends StatelessWidget {
  final double waterIntakeMl;
  final double waterGoalMl;
  final VoidCallback onAddGlass;
  final VoidCallback onAddCustom;

  const WaterTrackingWidget({
    super.key,
    required this.waterIntakeMl,
    required this.waterGoalMl,
    required this.onAddGlass,
    required this.onAddCustom,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        waterGoalMl > 0 ? (waterIntakeMl / waterGoalMl).clamp(0.0, 1.0) : 0.0;
    final remaining = (waterGoalMl - waterIntakeMl).clamp(0, double.infinity);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.water_drop,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  "Water",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  "${waterIntakeMl.toInt()} / ${waterGoalMl.toInt()} ml",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearPercentIndicator(
              lineHeight: 12,
              percent: progress,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              progressColor: Theme.of(context).colorScheme.primary,
              barRadius: const Radius.circular(6),
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),
            if (remaining > 0)
              Text(
                "${remaining.toInt()} ml remaining",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              )
            else
              Text(
                "Goal reached!",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: onAddGlass,
                    icon: const Icon(Icons.local_drink, size: 18),
                    label: const Text("+250 ml"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onAddCustom,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text("Custom"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
