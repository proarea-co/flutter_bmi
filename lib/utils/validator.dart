import 'package:flutter/material.dart';

class Validator {
  final List<_Field> fields;

  Validator() : fields = [];

  Validator add<T, E>({
    @required T data,
    @required E Function(T) onValidate,
    Function(T) onValid,
    Function(E) onInvalid,
  }) {
    fields.add(_Field<T, E>(
      data: data,
      onValidate: onValidate,
      onValid: onValid,
      onInvalid: onInvalid,
    ));
    return this;
  }

  bool validate() {
    bool isValid = true;
    for (_Field field in fields) {
      isValid &= field._validate();
    }
    return isValid;
  }
}

class _Field<T, E> {
  final T data;
  final E Function(T) onValidate;
  final void Function(T) onValid;
  final void Function(E) onInvalid;

  _Field({
    @required this.data,
    @required this.onValidate,
    @required this.onValid,
    @required this.onInvalid,
  });

  bool _validate() {
    E error = onValidate(data);
    bool isValid = error == null;

    if (isValid && onValid != null) {
      onValid(data);
    }
    if (!isValid && onInvalid != null) {
      onInvalid(error);
    }

    return isValid;
  }
}
