import 'package:flutter/material.dart';

class QuickWeightWidget extends StatelessWidget {
  final double weightKg;
  final bool usesImperialUnits;
  final VoidCallback onTap;

  const QuickWeightWidget({
    super.key,
    required this.weightKg,
    required this.usesImperialUnits,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayWeight = usesImperialUnits
        ? (weightKg * 2.20462).toStringAsFixed(1)
        : weightKg.toStringAsFixed(1);
    final unit = usesImperialUnits ? "lbs" : "kg";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.monitor_weight_outlined,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Text("Weight",
                  style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              Text(
                "$displayWeight $unit",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.edit_outlined,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
