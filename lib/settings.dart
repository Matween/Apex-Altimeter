import 'dart:ui';

import 'package:apex_altimeter/constants.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title, this.units, this.darkTheme, this.notifyParentUnits, this.notifyParentTheme}) : super(key: key);

  final String title;
  final String units;
  final bool darkTheme;
  final Function notifyParentUnits;
  final Function notifyParentTheme;

  @override
  _SettingsPageState createState() => _SettingsPageState(radioValueUnits: units, darkTheme: darkTheme, notifyParentUnits: notifyParentUnits, notifyParentTheme: notifyParentTheme);
}

class _SettingsPageState extends State<SettingsPage> {
  _SettingsPageState({this.radioValueUnits, this.darkTheme, this.notifyParentUnits, this.notifyParentTheme});

  Function notifyParentUnits;
  Function notifyParentTheme;
  String radioValueUnits;
  bool darkTheme = false;

  void _handleRadioValueUnitsChange(String units) {
    setState(() {
      radioValueUnits = units;
    });
    widget.notifyParentUnits(units);
    Constants.saveUnits(units);
  }

  void _handleSwitchThemeChange(bool theme) {
    setState(() {
      darkTheme = theme;
    });
    widget.notifyParentTheme(theme);
    Constants.saveTheme(theme);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(10),),
                Text('Units', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(value: 'metric', groupValue: radioValueUnits, onChanged: _handleRadioValueUnitsChange),
                  Text('Metric'),
                  Radio(value: 'imperial', groupValue: radioValueUnits, onChanged: _handleRadioValueUnitsChange),
                  Text('Imperial'),
                ],
                ),
                Divider(height: 5.0, color: Colors.black38,),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Dark Theme'),
                    Padding(padding: EdgeInsets.only(left: 50),),
                    Switch(value: darkTheme, onChanged: _handleSwitchThemeChange)
                  ],
                ),
                Divider(height: 5.0, color: Colors.black38,),
              ],
            ),
          ),
        );
  }
}
