String formatProfileWeight(double weight) {
  final roundedToOneDecimal = double.parse(weight.toStringAsFixed(1));
  if (roundedToOneDecimal == roundedToOneDecimal.roundToDouble()) {
    return roundedToOneDecimal.toStringAsFixed(0);
  }
  return roundedToOneDecimal.toStringAsFixed(1);
}
