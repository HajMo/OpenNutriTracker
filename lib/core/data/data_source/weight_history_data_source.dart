import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';

class WeightEntry {
  final DateTime date;
  final double weightKg;

  WeightEntry({required this.date, required this.weightKg});

  Map<String, dynamic> toMap() => {
        'date': date.toIso8601String(),
        'weightKg': weightKg,
      };

  factory WeightEntry.fromMap(Map<dynamic, dynamic> map) => WeightEntry(
        date: DateTime.parse(map['date'] as String),
        weightKg: (map['weightKg'] as num).toDouble(),
      );
}

class WeightHistoryDataSource {
  static const boxName = 'WeightHistoryBox';
  final log = Logger('WeightHistoryDataSource');
  final Box<dynamic> _box;

  WeightHistoryDataSource(this._box);

  Future<void> addEntry(WeightEntry entry) async {
    log.fine('Adding weight entry: ${entry.weightKg} kg on ${entry.date}');
    final key = entry.date.toIso8601String().substring(0, 10);
    await _box.put(key, entry.toMap());
  }

  List<WeightEntry> getAllEntries() {
    final entries = <WeightEntry>[];
    for (final value in _box.values) {
      try {
        entries.add(WeightEntry.fromMap(value as Map<dynamic, dynamic>));
      } catch (_) {}
    }
    entries.sort((a, b) => a.date.compareTo(b.date));
    return entries;
  }

  List<WeightEntry> getEntriesInRange(DateTime start, DateTime end) {
    return getAllEntries()
        .where((e) =>
            (e.date.isAfter(start) || e.date.isAtSameMomentAs(start)) &&
            (e.date.isBefore(end) || e.date.isAtSameMomentAs(end)))
        .toList();
  }

  WeightEntry? getLatestEntry() {
    final entries = getAllEntries();
    return entries.isEmpty ? null : entries.last;
  }
}
