import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bmi/models/field_data.dart';
import 'package:flutter_bmi/models/gender.dart';
import 'package:flutter_bmi/models/unit_system.dart';
import 'package:flutter_bmi/utils/validator.dart';
import 'package:flutter_bmi/views/bmi_text.dart';
import 'package:flutter_bmi/views/no_glow_scroll_behavior.dart';
import 'package:flutter_bmi/views/selectable_row.dart';

import 'result_page.dart';

enum _Field { Age, HeightMain, HeightInch, Weight }

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Map<_Field, FieldData> _fields = Map.fromIterable(_Field.values, key: (e) => e, value: (v) => FieldData());

  var _currentGender = Gender.male;
  var _currentUnitSystem = UnitSystem.metric;

  void _onCalculate() async {
    final validator = Validator()
        .add<String, String>(
          data: _fields[_Field.Age].controller.text,
          onValidate: _validateAge(18, 100),
          onValid: (String age) => _fields[_Field.Age].errorText = null,
          onInvalid: (String error) => _fields[_Field.Age].errorText = error,
        )
        .add<String, String>(
          data: _fields[_Field.Weight].controller.text,
          onValidate: _validateWeight(50, 250),
          onValid: (String age) => _fields[_Field.Weight].errorText = null,
          onInvalid: (String error) => _fields[_Field.Weight].errorText = error,
        )
        .add<String, String>(
          data: _fields[_Field.HeightMain].controller.text,
          onValidate: _validateHeight(150, 230),
          onValid: (String age) => _fields[_Field.HeightMain].errorText = null,
          onInvalid: (String error) => _fields[_Field.HeightMain].errorText = error,
        );
    bool isInputValid = validator.validate();
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {});
    if (isInputValid) {
      Navigator.of(context).push(CupertinoPageRoute(
        builder: (_) => ResultPage(_currentGender, enteredAge, enteredHeightCm, enteredWeightKg),
      ));
    }
  }

  int get enteredAge => int.tryParse(_fields[_Field.Age].controller.text);

  String Function(String) _validateAge(int min, int max) {
    return (String text) {
      try {
        int parsedInt = enteredAge;
        if (parsedInt != null && parsedInt >= min && parsedInt <= max) {
          return null;
        }
      } catch (e) {}
      return '$min - $max years';
    };
  }

  double get enteredWeightKg {
    double parsed = double.tryParse(_fields[_Field.Weight].controller.text);
    if (_currentUnitSystem == UnitSystem.imperial && parsed != null) {
      parsed = parsed * _currentUnitSystem.weightUnitMultiplier;
    }
    return parsed;
  }

  String Function(String) _validateWeight(double minKg, double maxKg) {
    return (String _) {
      try {
        double parsed = enteredWeightKg;

        if (parsed != null && parsed >= minKg && parsed <= maxKg) {
          return null;
        }
      } catch (e) {}
      double multiplier = _currentUnitSystem.weightUnitMultiplier;
      String min = (_currentUnitSystem == UnitSystem.imperial ? minKg * multiplier : minKg).floor().toString();
      String max = (_currentUnitSystem == UnitSystem.imperial ? maxKg * multiplier : maxKg).floor().toString();
      return '$min - $max  ${_currentUnitSystem.weightUnitName}';
    };
  }

  double get enteredHeightCm {
    double parsed = double.tryParse(_fields[_Field.HeightMain].controller.text);
    if (_currentUnitSystem == UnitSystem.imperial && parsed != null) {
      parsed = parsed * 30.48;
      double parsedInches = double.tryParse(_fields[_Field.HeightInch].controller.text) ?? 0;
      parsed += parsedInches * _currentUnitSystem.lengthUnitMultiplier;
    }
    return parsed;
  }

  String Function(String) _validateHeight(double minCm, double maxCm) {
    return (String _) {
      bool isImperial = _currentUnitSystem == UnitSystem.imperial;
      try {
        double parsed = enteredHeightCm;

        if (parsed != null && parsed >= minCm && parsed <= maxCm) {
          return null;
        }
      } catch (e) {}
      String min = (isImperial ? minCm * _currentUnitSystem.lengthUnitMultiplier / 12 : minCm).floor().toString();
      String max = (isImperial ? maxCm * _currentUnitSystem.lengthUnitMultiplier / 12 : maxCm).floor().toString();
      return '$min - $max ${isImperial ? 'ft' : _currentUnitSystem.lengthUnitName}';
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 24),
              BmiText('Select Your Gender'),
              _buildGenders(),
              SizedBox(height: 24),
              BmiText('Specify Your Age'),
              _buildTextField(
                _fields[_Field.Age],
                labelText: 'full years',
                validator: _validateAge(18, 100),
                nextFocusNode: _fields[_Field.HeightMain].focusNode,
              ),
              SizedBox(height: 24),
              BmiText('Unit Type'),
              _buildUnitSystems(),
              SizedBox(height: 24),
              BmiText('Specify Your Height ${_currentUnitSystem == UnitSystem.metric ? '(cm)' : '(ft/inch)'}'),
              _buildTextField(
                _fields[_Field.HeightMain],
                labelText: _currentUnitSystem == UnitSystem.metric ? 'cm' : 'ft',
                nextFocusNode: _currentUnitSystem == UnitSystem.metric
                    ? _fields[_Field.Weight].focusNode
                    : _fields[_Field.HeightInch].focusNode,
              ),
              if (_currentUnitSystem == UnitSystem.imperial)
                _buildTextField(
                  _fields[_Field.HeightInch],
                  labelText: 'inch',
                  nextFocusNode: _fields[_Field.Weight].focusNode,
                ),
              SizedBox(height: 24),
              BmiText('Specify Your Weight (${_currentUnitSystem.weightUnitName})'),
              _buildTextField(
                _fields[_Field.Weight],
                labelText: _currentUnitSystem.weightUnitName,
                validator: _validateWeight(50, 250),
                onDone: _onCalculate,
              ),
              SizedBox(height: 24),
              _buildButton(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenders() {
    return SelectableRow(
      <Gender>[Gender.male, Gender.female],
      checkSelected: (gender) => _currentGender == gender,
      setSelected: (gender) => setState(() {
        _currentGender = gender;
      }),
      getName: (gender) => gender.name,
    );
  }

  Widget _buildUnitSystems() {
    return SelectableRow(
      <UnitSystem>[UnitSystem.metric, UnitSystem.imperial],
      checkSelected: (unitSystem) => _currentUnitSystem == unitSystem,
      setSelected: (unitSystem) => setState(() {
        _currentUnitSystem = unitSystem;
      }),
      getName: (unitSystem) => unitSystem.name,
    );
  }

  Widget _buildTextField(
    FieldData fieldData, {
    String labelText,
    FocusNode nextFocusNode,
    FormFieldValidator<String> validator,
    VoidCallback onDone,
  }) {
    VoidCallback onSubmit = () {};
    TextInputAction action = TextInputAction.done;
    if (nextFocusNode != null) {
      action = TextInputAction.next;
      onSubmit = () => FocusScope.of(context).requestFocus(nextFocusNode);
    } else if (onDone != null) {
      action = TextInputAction.done;
      onSubmit = () {
        FocusScope.of(context).requestFocus(FocusNode());
        onDone();
      };
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth / 4, vertical: 8),
          child: TextFormField(
            controller: fieldData.controller,
            keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            focusNode: fieldData.focusNode,
            decoration: InputDecoration(
              hintText: labelText ?? '',
              errorText: fieldData.errorText,
            ),
            validator: validator,
            textInputAction: action,
            onEditingComplete: () => onSubmit(),
          ),
        );
      },
    );
  }

  Widget _buildButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onCalculate,
          borderRadius: BorderRadius.circular(24),
          splashColor: Colors.lightGreenAccent,
          hoverColor: Colors.lightGreenAccent,
          highlightColor: Colors.lightGreenAccent.withOpacity(0.5),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: Text(
              'Calculate BMI',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
