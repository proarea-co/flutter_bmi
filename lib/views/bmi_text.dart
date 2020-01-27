import 'package:flutter/material.dart';

class BmiText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsets padding;

  const BmiText(this.text, {this.fontSize, this.padding, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Text(
        '$text',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
      ),
    );
  }
}
