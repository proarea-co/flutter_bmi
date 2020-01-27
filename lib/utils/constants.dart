import 'package:flutter/material.dart';
import 'package:flutter_bmi/models/bmi_range.dart';

class Constants {
  Constants._();

  static const defaultBmiRanges = <BmiRange>[
    BmiRange.onlyUpper(Colors.blue, 14.5),
    BmiRange(Colors.lightBlue, 14.5, 18.5),
    idealBmiRange,
    BmiRange(Colors.amber, 25, 29.9),
    BmiRange.onlyLower(Colors.redAccent, 29.9),
  ];

  static const idealBmiRange = BmiRange(Colors.lightGreenAccent, 18.5, 25);
}
