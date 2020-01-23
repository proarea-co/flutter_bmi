import 'package:flutter/material.dart';
import 'package:flutter_bmi/models/bmi_range.dart';

class BmiIndicator extends StatelessWidget {
  static const _radius = Radius.circular(24);
  static const _indicatorHeight = 16.0;
  static const _indicatorDotKoef = 3.0;

  final List<BmiRange> bmiRanges;
  final double value;

  const BmiIndicator({
    this.bmiRanges = BmiRange.constList,
    this.value = 30.4,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final indicatorWidth = constraints.maxWidth * 2 / 3;
          final indicatorItemWidth = indicatorWidth / bmiRanges.length;

          return Stack(
            fit: StackFit.loose,
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              _buildShadow(indicatorWidth),
              _buildBmiRangeStrip(indicatorItemWidth),
              _buildMarker(indicatorItemWidth),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShadow(double indicatorWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: _indicatorHeight,
          width: indicatorWidth,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(_radius),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 2),
                blurRadius: 5,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBmiRangeStrip(double indicatorItemWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        bmiRanges.length,
        (int index) => _buildBmiRangeStripItem(indicatorItemWidth, index),
      ),
    );
  }

  Widget _buildBmiRangeStripItem(double indicatorItemWidth, int index) {
    final range = bmiRanges[index];
    BorderRadius borderRadius;
    if (index == 0) {
      borderRadius = BorderRadius.only(topLeft: _radius, bottomLeft: _radius);
    } else if (index == bmiRanges.length - 1) {
      borderRadius = BorderRadius.only(topRight: _radius, bottomRight: _radius);
    } else {
      borderRadius = null;
    }

    return Container(
      height: _indicatorHeight,
      width: indicatorItemWidth,
      decoration: BoxDecoration(
        color: range.color,
        borderRadius: borderRadius,
      ),
    );
  }

  Widget _buildMarker(double indicatorItemWidth) {
    final rangeIndex = bmiRanges.indexWhere((BmiRange range) => range.isValueInRange(value));
    final range = bmiRanges[rangeIndex];

    var rangePercent;
    if (range.lowerBound == null) {
      rangePercent = 0.75;
    } else if (range.upperBound == null) {
      rangePercent = 0.25;
    } else {
      rangePercent = (value - range.lowerBound) / (range.upperBound - range.lowerBound);
    }

    final currentRangeOffsetMultiplier = 2 * rangeIndex - bmiRanges.length;
    final currentRangeInnerOffset = indicatorItemWidth * rangePercent * 2;
    final rangeOffset = currentRangeOffsetMultiplier * indicatorItemWidth + currentRangeInnerOffset;

    final padding = rangeOffset > 0 ? EdgeInsets.only(left: rangeOffset) : EdgeInsets.only(right: rangeOffset.abs());

    return Container(
      padding: padding,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: range.color,
              borderRadius: BorderRadius.all(_radius),
            ),
            child: Text(
              '${value == value.floor() ? value.toInt() : value.toDouble().toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(_indicatorDotKoef).add(EdgeInsets.only(top: _indicatorDotKoef * 4)),
            height: _indicatorHeight - _indicatorDotKoef * 2,
            width: _indicatorHeight - _indicatorDotKoef * 2,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          )
        ],
      ),
    );
  }
}
