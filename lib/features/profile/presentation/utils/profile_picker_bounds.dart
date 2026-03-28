import 'dart:math';

const _heightRangeCm = 100.0;
const _heightRangeFt = 10.0;
const _weightRangeKg = 50.0;
const _weightRangeLbs = 100.0;
const _minHeight = 1.0;
const _minWeight = 1.0;

double minSelectableHeight(double userHeight, bool usesImperialUnits) {
  final range = usesImperialUnits ? _heightRangeFt : _heightRangeCm;
  return max(_minHeight, userHeight - range);
}

double maxSelectableHeight(double userHeight, bool usesImperialUnits) {
  final range = usesImperialUnits ? _heightRangeFt : _heightRangeCm;
  return userHeight + range;
}

double clampHeightSelection(double selectedHeight, double minHeight) {
  return max(minHeight, selectedHeight);
}

double minSelectableWeight(double userWeight, bool usesImperialUnits) {
  final range = usesImperialUnits ? _weightRangeLbs : _weightRangeKg;
  return max(_minWeight, userWeight - range);
}

double maxSelectableWeight(double userWeight, bool usesImperialUnits) {
  final range = usesImperialUnits ? _weightRangeLbs : _weightRangeKg;
  return userWeight + range;
}

double clampWeightSelection(double selectedWeight, double minWeight) {
  return max(minWeight, selectedWeight);
}
