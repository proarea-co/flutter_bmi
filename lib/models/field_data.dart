import 'package:flutter/material.dart';

class FieldData {
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();

  String errorText;

  FieldData();

  FieldData.withError(this.errorText);
}
