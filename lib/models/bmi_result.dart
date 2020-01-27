import 'package:flutter/material.dart';

class BmiResult {
  /// <code>positive</code> - if need gaining weight,
  ///  <code>negative</code> - if need losing weight,
  ///  <code>null</code> - if normal weight
  final double weightCorrection;
  final double bmiCalculated;
  final double bmiAverage;

  const BmiResult({
    @required this.weightCorrection,
    @required this.bmiCalculated,
    @required this.bmiAverage,
  });
}
