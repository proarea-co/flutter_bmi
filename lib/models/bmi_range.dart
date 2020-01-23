import 'package:flutter/material.dart';

class BmiRange {
  static const constList = <BmiRange>[
    BmiRange.onlyUpper(Colors.blue, 14.5),
    BmiRange(Colors.lightBlue, 14.5, 18.5),
    ideal,
    BmiRange(Colors.amber, 25, 29.9),
    BmiRange.onlyLower(Colors.redAccent, 29.9),
  ];

  static const ideal = BmiRange(Colors.lightGreenAccent, 18.5, 25);

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
