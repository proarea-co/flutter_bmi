import 'dart:async';
import 'dart:convert';

import 'package:flutter_bmi/models/bmi_range.dart';
import 'package:flutter_bmi/models/bmi_result.dart';
import 'package:flutter_bmi/models/gender.dart';
import 'package:flutter_bmi/utils/states.dart';
import 'package:http/http.dart' as http;

class BmiCalculationBloc {
  BmiCalculationBloc();

  Future<AsyncState<BmiResult>> calculateBmi(Gender gender, int age, double heightCm, double weightKg) async {
    try {
      double heightM = heightCm * 0.01;
      double bmi = weightKg / (heightM * heightM);
      double weightCorrection;
      if (!BmiRange.ideal.isValueInRange(bmi)) {
        double idealBmi = BmiRange.ideal.upperBound - bmi > 0 ? BmiRange.ideal.lowerBound : BmiRange.ideal.upperBound;
        weightCorrection = heightM * heightM * idealBmi - heightM * heightM * bmi;
      }

      final apiRequest = json.encode(<String, dynamic>{
        'age': age,
        'gender': gender.name.toLowerCase(),
      });
      final apiResponse = await http.post(
        'https://us-central1-bmiflutter.cloudfunctions.net/bmi/ideal',
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: apiRequest,
      );
      final apiResponseBody = apiResponse.body;
      double averageBmi = double.parse(apiResponseBody);

      final result = BmiResult(
        weightCorrection: weightCorrection,
        bmiCalculated: bmi,
        bmiAverage: averageBmi,
      );
      return SuccessState(result);
    } catch (e) {
      return FailureState(e);
    }
  }
}
