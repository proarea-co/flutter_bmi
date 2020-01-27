import 'dart:ui';

class BmiRange {
  final Color color;
  final double lowerBound;
  final double upperBound;

  const BmiRange(
    this.color,
    this.lowerBound,
    this.upperBound,
  ) : assert((lowerBound == null && upperBound != null) ||
            (upperBound == null && lowerBound != null) ||
            lowerBound < upperBound);

  const BmiRange.onlyUpper(Color color, double upperBound) : this(color, null, upperBound);

  const BmiRange.onlyLower(Color color, double lowerBound) : this(color, lowerBound, null);

  bool isValueInRange(double value) {
    if ((lowerBound == null && value < upperBound) || (upperBound == null && lowerBound <= value)) {
      return true;
    } else if (lowerBound != null && upperBound != null) {
      return lowerBound <= value && value < upperBound;
    } else {
      return false;
    }
  }
}
