import 'dart:async';

import 'package:flutter_bmi/models/bmi_range.dart';
import 'package:flutter_bmi/models/bmi_result.dart';
import 'package:flutter_bmi/models/gender.dart';
import 'package:flutter_bmi/utils/states.dart';

class BmiCalculationBloc {
  BmiCalculationBloc();

  Future<AsyncState<BmiResult>> calculateBmi(Gender gender, int age, double heightCm, double weightKg) async {
    try {
      double heightM = heightCm * 0.01;
      double bmi = weightKg / (heightM * heightM);
      double weightCorrection;
      if (!BmiRange.ideal.isValueInRange(bmi)) {
        double sign = (BmiRange.ideal.upperBound - bmi).sign;
        double idealBmi = sign > 0 ? BmiRange.ideal.lowerBound : BmiRange.ideal.upperBound;
        weightCorrection = sign * (heightM * heightM * idealBmi - heightM * heightM * bmi);
      }

      final result = BmiResult(
        weightCorrection: weightCorrection,
        bmiCalculated: bmi,
        bmiAverage: 1.0, //TODO
      );
      return SuccessState(result);
    } catch (e) {
      return FailureState(e);
    }
  }
}
