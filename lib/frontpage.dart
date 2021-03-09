import 'dart:ui';

import 'package:apex_altimeter/altimeter.dart';
import 'package:apex_altimeter/info.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'constants.dart';

class FrontPage extends StatefulWidget {
  FrontPage({
    Key key,
    this.title,
    this.backgroundPic,
    this.darkTheme,
    this.units,
    this.address,
  }) : super(key: key);

  final String title;
  final String backgroundPic;
  final bool darkTheme;
  final String units;
  final String address;

  @override
  _FrontPageState createState() => _FrontPageState(
        backgroundPic: backgroundPic,
        darkTheme: darkTheme,
        units: units
      );
}

class _FrontPageState extends State<FrontPage> {
  bool darkTheme;
  String backgroundPic;
  String units;
  final alert = AlertDialog(
    title: Text('Permission denied!'),
    content: Text('Please enable location and internet permission.'),
  );

  _FrontPageState({
    this.backgroundPic,
    this.darkTheme,
    this.units
  });

  Future<void> _getPositionData() async{
    Altimeter.getLocationData().listen((position) => {
      setState(() {
        Altimeter.position = position;
      }),
      Altimeter.getAddress(position).then((address) => {
        setState(() {
          Altimeter.address = address;
        })
      })
    });
  }

  @override
  void initState() {
    super.initState();
    Altimeter.isPermissionGranted().then((permission) => {
          if (!permission) {
              showDialog(
                  context: context, builder: (BuildContext context) => alert)
            }
        });
    _getPositionData();

  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants.size = size;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _getPositionData,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Info(
                      text: Altimeter.getFtOrMetersUnits(
                          Altimeter.position == null
                              ? 0
                              : Altimeter.position.altitude, units),
                      image: FontAwesomeIcons.flag,
                      font: 15,
                      width: size.width * 0.3,
                      height: size.height * 0.17,
                      color: darkTheme ? Colors.black87 : Colors.white,
                      fontColor: darkTheme
                          ? Color.fromRGBO(0, 212, 170, 1)
                          : Colors.black38,
                    ),
                    Info(
                      text: Altimeter.getKmOrMilesUnits(
                          Altimeter.position == null
                              ? 0
                              : Altimeter.position.speed, units),
                      image: FontAwesomeIcons.tachometerAlt,
                      font: 15,
                      width: size.width * 0.3,
                      height: size.height * 0.17,
                      color: darkTheme ? Colors.black87 : Colors.white,
                      fontColor: darkTheme
                          ? Color.fromRGBO(0, 212, 170, 1)
                          : Colors.black38,
                    ),
                    Info(
                      text: Altimeter.position != null
                          ? Altimeter.getDMSFromLatLong(
                              Altimeter.position.latitude,
                              Altimeter.position.longitude)
                          : 'Not available...',
                      image: FontAwesomeIcons.compass,
                      font: 15,
                      width: size.width * 0.3,
                      height: size.height * 0.17,
                      color: darkTheme ? Colors.black87 : Colors.white,
                      fontColor: darkTheme
                          ? Color.fromRGBO(0, 212, 170, 1)
                          : Colors.black38,
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Info(
                      text: Altimeter.address ?? 'Not available...',
                      image: FontAwesomeIcons.map,
                      font: 22,
                      width: size.width * 0.95,
                      height: size.height * 0.18,
                      color: darkTheme ? Colors.black87 : Colors.white,
                      fontColor: darkTheme
                          ? Color.fromRGBO(0, 212, 170, 1)
                          : Colors.black38,
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
