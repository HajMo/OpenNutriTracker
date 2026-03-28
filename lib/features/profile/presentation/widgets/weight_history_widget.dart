import 'package:flutter/material.dart';
import 'package:opennutritracker/core/data/data_source/weight_history_data_source.dart';
import 'package:opennutritracker/core/utils/locator.dart';

class WeightHistoryWidget extends StatefulWidget {
  final bool usesImperialUnits;

  const WeightHistoryWidget({super.key, required this.usesImperialUnits});

  @override
  State<WeightHistoryWidget> createState() => _WeightHistoryWidgetState();
}

class _WeightHistoryWidgetState extends State<WeightHistoryWidget> {
  List<WeightEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() {
    final dataSource = locator<WeightHistoryDataSource>();
    setState(() {
      _entries = dataSource.getAllEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_entries.length < 2) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.show_chart,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text("Weight History",
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _entries.isEmpty
                    ? "No weight entries yet. Update your weight to start tracking."
                    : "Add more weight entries to see your progress chart.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.show_chart,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text("Weight History",
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Text(
                  _formatWeight(_entries.last.weightKg),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: CustomPaint(
                size: Size.infinite,
                painter: _WeightChartPainter(
                  entries: _entries,
                  lineColor: Theme.of(context).colorScheme.primary,
                  gridColor: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.2),
                  textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  usesImperial: widget.usesImperialUnits,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildSummaryRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context) {
    final first = _entries.first.weightKg;
    final last = _entries.last.weightKg;
    final diff = last - first;
    final isLoss = diff < 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Start: ${_formatWeight(first)}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Row(
          children: [
            Icon(
              isLoss ? Icons.trending_down : Icons.trending_up,
              size: 16,
              color: isLoss
                  ? Colors.green
                  : Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 4),
            Text(
              "${isLoss ? '' : '+'}${_formatWeight(diff)}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isLoss
                        ? Colors.green
                        : Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatWeight(double kg) {
    if (widget.usesImperialUnits) {
      return "${(kg * 2.20462).toStringAsFixed(1)} lbs";
    }
    return "${kg.toStringAsFixed(1)} kg";
  }
}

class _WeightChartPainter extends CustomPainter {
  final List<WeightEntry> entries;
  final Color lineColor;
  final Color gridColor;
  final Color textColor;
  final bool usesImperial;

  _WeightChartPainter({
    required this.entries,
    required this.lineColor,
    required this.gridColor,
    required this.textColor,
    required this.usesImperial,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.length < 2) return;

    final weights = entries.map((e) => e.weightKg).toList();
    final minW = weights.reduce((a, b) => a < b ? a : b) - 1;
    final maxW = weights.reduce((a, b) => a > b ? a : b) + 1;
    final rangeW = maxW - minW;

    final leftPadding = 40.0;
    final bottomPadding = 20.0;
    final chartWidth = size.width - leftPadding;
    final chartHeight = size.height - bottomPadding;

    // Grid lines
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;
    final textStyle = TextStyle(color: textColor, fontSize: 10);

    for (int i = 0; i <= 4; i++) {
      final y = chartHeight - (chartHeight * i / 4);
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width, y),
        gridPaint,
      );
      final w = minW + (rangeW * i / 4);
      final label = usesImperial
          ? "${(w * 2.20462).toStringAsFixed(0)}"
          : "${w.toStringAsFixed(0)}";
      final tp = TextPainter(
        text: TextSpan(text: label, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    // Line chart
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [lineColor.withValues(alpha: 0.3), lineColor.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(leftPadding, 0, chartWidth, chartHeight));

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < entries.length; i++) {
      final x = leftPadding + (chartWidth * i / (entries.length - 1));
      final y = chartHeight - (chartHeight * (entries[i].weightKg - minW) / rangeW);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, chartHeight);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(
        leftPadding + chartWidth, chartHeight);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    // Dots
    final dotPaint = Paint()..color = lineColor;
    for (int i = 0; i < entries.length; i++) {
      final x = leftPadding + (chartWidth * i / (entries.length - 1));
      final y = chartHeight - (chartHeight * (entries[i].weightKg - minW) / rangeW);
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
