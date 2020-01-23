import 'package:flutter/material.dart';
import 'package:flutter_bmi/models/gender.dart';
import 'package:flutter_bmi/models/unit_system.dart';
import 'package:flutter_bmi/views/no_glow_scroll_behavior.dart';
import 'package:flutter_bmi/views/selectable_row.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _currentGender = Gender.male;
  var _currentUnitSystem = UnitSystem.metric;

  var _ageController = TextEditingController();
  var _ageFocusNode = FocusNode();
  var _heightController = TextEditingController();
  var _heightFocusNode = FocusNode();
  var _weightController = TextEditingController();
  var _weightFocusNode = FocusNode();

  void _onCalculate() async {
    // TODO
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
              _buildText('Select Your Gender'),
              _buildGenders(),
              SizedBox(height: 24),
              _buildText('Specify Your Age'),
              _buildTextField(
                controller: _ageController,
                focusNode: _ageFocusNode,
                nextFocusNode: _heightFocusNode,
              ),
              SizedBox(height: 24),
              _buildText('Unit Type'),
              _buildUnitSystems(),
              SizedBox(height: 24),
              _buildText('Specify Your Height (${_currentUnitSystem.lengthUnitName})'),
              _buildTextField(
                controller: _heightController,
                focusNode: _heightFocusNode,
                nextFocusNode: _weightFocusNode,
              ),
              SizedBox(height: 24),
              _buildText('Specify Your Weight (${_currentUnitSystem.weightUnitName})'),
              _buildTextField(
                controller: _weightController,
                focusNode: _weightFocusNode,
                onDone: () {
                  print('Done');
                },
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

  Widget _buildText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Text(
        '$text',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildGenders() {
    return SelectableRow(
      <Gender>[Gender.male, Gender.female],
      checkSelected: (gender) => _currentGender == gender,
      setSelected: (gender) => setState(() => _currentGender = gender),
      getName: (gender) => gender.name,
    );
  }

  Widget _buildUnitSystems() {
    return SelectableRow(
      <UnitSystem>[UnitSystem.metric, UnitSystem.imperial],
      checkSelected: (unitSystem) => _currentUnitSystem == unitSystem,
      setSelected: (unitSystem) => setState(() => _currentUnitSystem = unitSystem),
      getName: (unitSystem) => unitSystem.name,
    );
  }

  Widget _buildTextField({
    @required TextEditingController controller,
    @required FocusNode focusNode,
    FocusNode nextFocusNode,
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
            controller: _heightController,
            keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            focusNode: focusNode,
            textInputAction: action,
            onFieldSubmitted: (_) => onSubmit(),
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
