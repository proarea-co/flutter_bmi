import 'package:flutter/material.dart';

class SelectableRow<T> extends StatelessWidget {
  final List<T> data;
  final bool Function(T) checkSelected;
  final void Function(T) setSelected;
  final String Function(T) getName;

  SelectableRow(
    this.data, {
    @required this.checkSelected,
    @required this.setSelected,
    @required this.getName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: data.map<Widget>(
        (T item) {
          bool isSelected = checkSelected(item);

          double boxSize = isSelected ? 72 : 64;
          Color boxColor = isSelected ? Colors.blue : Colors.grey;
          VoidCallback onTap = isSelected ? null : () => setSelected(item);

          return Container(
            height: 88,
            width: 88,
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: boxSize,
                width: boxSize,
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                margin: EdgeInsets.all(8),
                child: Text(
                  getName(item),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
