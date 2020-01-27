import 'package:flutter/material.dart';

const _fullBoxSize = 88.0;
const _unselectedBoxSize = 64.0;
const _selectedBoxSize = 72.0;

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

          double boxSize = isSelected ? _selectedBoxSize : _unselectedBoxSize;
          Color boxColor = isSelected ? Colors.blue : Colors.grey;
          VoidCallback onTap = isSelected ? null : () => setSelected(item);

          return Container(
            height: _fullBoxSize,
            width: _fullBoxSize,
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
