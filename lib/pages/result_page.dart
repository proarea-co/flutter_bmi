import 'package:flutter/material.dart';
import 'package:flutter_bmi/models/bmi_range.dart';
import 'package:flutter_bmi/models/bmi_result.dart';
import 'package:flutter_bmi/models/gender.dart';
import 'package:flutter_bmi/pages/bmi_calculation_bloc.dart';
import 'package:flutter_bmi/utils/states.dart';
import 'package:flutter_bmi/views/bmi_indicator.dart';
import 'package:flutter_bmi/views/bmi_text.dart';

class ResultPage extends StatefulWidget {
  final Gender gender;
  final int age;
  final double heightCm;
  final double weightKg;

  const ResultPage(this.gender, this.age, this.heightCm, this.weightKg);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  BmiCalculationBloc _bloc = BmiCalculationBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Your Results'),
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<AsyncState<BmiResult>>(
        future: _bloc.calculateBmi(widget.gender, widget.age, widget.heightCm, widget.weightKg),
        builder: (BuildContext context, AsyncSnapshot<AsyncState<BmiResult>> snapshot) {
          AsyncState<BmiResult> data = snapshot.data;

          if (data is AsyncState<BmiResult>) {
            if (data is SuccessState<BmiResult>) {
              return _buildBmiResult(context, data.data);
            }
            if (data is FailureState<BmiResult>) {
              return Center(
                child: Text('${data.failure}'),
              );
            }
            if (data is LoadingState<BmiResult>) {
              return _buildLoading();
            }
          }
          return _buildLoading();
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildBmiResult(BuildContext context, BmiResult bmiResult) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 48),
              BmiText(
                'Your BMI Index',
                fontSize: 28,
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: MediaQuery.of(context).size.width / 4.5,
                ),
              ),
              BmiIndicator(value: bmiResult.bmiCalculated, bmiRanges: BmiRange.constList),
              SizedBox(height: 24),
              BmiText(
                'Ideal BMI Index For Men Of Your Age',
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: MediaQuery.of(context).size.width / 4.5,
                ),
              ),
              BmiIndicator(value: bmiResult.bmiAverage, bmiRanges: BmiRange.constList),
              SizedBox(height: 24),
              _buildIndexState(bmiResult),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIndexState(BmiResult bmiResult) {
    return Builder(
      builder: (BuildContext context) {
        final weightCorrection = bmiResult.weightCorrection;

        if (weightCorrection != null && weightCorrection != 0) {
          final absoluteWeight = weightCorrection.abs();
          return Column(
            children: <Widget>[
              BmiText(
                'It\'s Possible To Achieve The Ideal BMI Index By ${weightCorrection < 0 ? 'Losing' : 'Gaining'}',
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: MediaQuery.of(context).size.width / 8),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  '${absoluteWeight == absoluteWeight.floor() ? absoluteWeight.toInt() : absoluteWeight.toDouble().toStringAsFixed(2)} kg',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        } else {
          return BmiText(
            'Your have an optimal amount of body fat!',
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: MediaQuery.of(context).size.width / 8),
          );
        }
      },
    );
  }
}
