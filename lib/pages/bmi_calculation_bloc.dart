import 'dart:async';
import 'dart:convert';

import 'package:flutter_bmi/models/bmi_result.dart';
import 'package:flutter_bmi/models/gender.dart';
import 'package:flutter_bmi/utils/constants.dart';
import 'package:flutter_bmi/utils/states.dart';
import 'package:http/http.dart' as http;

const _cmToMMultiplier = 0.01;
const _averageBmiUrl = 'https://us-central1-bmiflutter.cloudfunctions.net/bmi/ideal';

class BmiCalculationBloc {
  BmiCalculationBloc();

  Future<AsyncState<BmiResult>> calculateBmi(Gender gender, int age, double heightCm, double weightKg) async {
    try {
      double bmi = await _getBmi(heightCm, weightKg);
      double weightCorrection = await _getBmiWeightCorrection(bmi, heightCm);
      double averageBmi = await _getAverageBmi(gender, age);

      return SuccessState(
        BmiResult(
          weightCorrection: weightCorrection,
          bmiCalculated: bmi,
          bmiAverage: averageBmi,
        ),
      );
    } catch (e) {
      return FailureState(e);
    }
  }

  Future<double> _getBmi(double heightCm, double weightKg) async {
    double heightM = heightCm * _cmToMMultiplier;
    return weightKg / (heightM * heightM);
  }

  Future<double> _getBmiWeightCorrection(double currentBmi, double heightCm) async {
    final idealBmiRange = Constants.idealBmiRange;
    double heightM = heightCm * _cmToMMultiplier;

    if (!idealBmiRange.isValueInRange(currentBmi)) {
      bool isOverweight = idealBmiRange.upperBound - currentBmi > 0;
      double idealBmi = isOverweight ? idealBmiRange.upperBound : idealBmiRange.lowerBound;
      return heightM * heightM * idealBmi - heightM * heightM * currentBmi;
    }
    return null;
  }

  Future<double> _getAverageBmi(Gender gender, int age) async {
    final apiRequest = json.encode(<String, dynamic>{
      'age': age,
      'gender': gender.name.toLowerCase(),
    });
    final apiResponse = await http.post(
      _averageBmiUrl,
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: apiRequest,
    );
    final apiResponseBody = apiResponse.body;
    return double.parse(apiResponseBody);
  }
}
