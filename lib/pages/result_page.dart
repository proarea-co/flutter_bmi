import 'package:flutter/material.dart';
import 'package:flutter_bmi/models/bmi_range.dart';
import 'package:flutter_bmi/views/bmi_indicator.dart';
import 'package:flutter_bmi/views/bmi_text.dart';

class ResultPage extends StatelessWidget {
  final double weightCorrection;

  const ResultPage({Key key, this.weightCorrection = 10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Your Results'),
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 48),
                BmiText(
                  'Your BMI Index',
                  fontSize: 28,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: MediaQuery.of(context).size.width / 4.5),
                ),
                BmiIndicator(value: 30.4, bmiRanges: BmiRange.constList),
                SizedBox(height: 24),
                BmiText(
                  'Ideal BMI Index For Men Of Your Age',
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: MediaQuery.of(context).size.width / 4.5),
                ),
                BmiIndicator(value: 20.2, bmiRanges: BmiRange.constList),
                SizedBox(height: 24),
                _buildIndexState(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndexState() {
    return Builder(
      builder: (BuildContext context) {
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
                  '${absoluteWeight == absoluteWeight.floor() ? absoluteWeight.toInt() : absoluteWeight.toDouble()} kg',
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
