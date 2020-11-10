import 'dart:async';
import 'dart:ui';

import 'package:apex_altimeter/info.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FrontPage extends StatefulWidget {
  FrontPage(
      {Key key,
      this.title,
      this.backgroundPic,
      this.darkTheme,
      this.units,
      this.address,
      this.position})
      : super(key: key);

  final String title;
  final String backgroundPic;
  final bool darkTheme;
  final String units;
  final String address;
  final Position position;

  @override
  _FrontPageState createState() => _FrontPageState(
      backgroundPic: backgroundPic,
      darkTheme: darkTheme,
      units: units);
}

class _FrontPageState extends State<FrontPage> {
  bool darkTheme;
  String units;
  String backgroundPic;

  bool _serviceEnabled = false;
  LocationPermission _permissionGranted;
  Position position;
  String address;
  StreamSubscription<Position> positionSubscription;

  _FrontPageState(
      {this.backgroundPic,
      this.darkTheme,
      this.units});

  @override
  void initState() {
    super.initState();
    _getLocationData();
  }

  @override
  void dispose() {
    super.dispose();
    positionSubscription.cancel();
  }

  _getDMSFromLatLong(double lat, double lon) {
    var latResult, lonResult;

    latResult = (lat >= 0) ? 'N' : 'S';
    lonResult = (lon >= 0) ? 'E' : 'W';

    String dmsLat = _getDMS(lat) + ' ' + latResult;
    String dmsLon = _getDMS(lon) + ' ' + lonResult;

    return dmsLat + '\n' + dmsLon;
  }

  _getDMS(double val) {
    var valDeg, valMin, valSec, result;

    valDeg = val.floor();

    result = valDeg.abs().toString() + 'º ';

    valMin = ((val - valDeg) * 60).floor();

    result += valMin.toString() + "' ";

    valSec = ((val - valDeg - valMin / 60) * 3600 * 1000).round() / 1000;

    result += valSec.floor().toString() + '" ';

    return result;
  }

  _getFtOrMetersUnits(double val) {
    return units == 'metric'
        ? val.toStringAsFixed(2) + ' m'
        : (val * 3.28084).toStringAsFixed(2) + ' ft';
  }

  _getKmOrMilesUnits(double val) {
    return units == 'metric'
        ? (val * 3.6).toStringAsFixed(2) + ' km/h'
        : (val * 2.236936).toStringAsFixed(2) + ' mph';
  }

  Future<Null> _checkPermissionServices() async {
    _serviceEnabled = await isLocationServiceEnabled();
    if (!_serviceEnabled) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Location Services'),
              content: Text('Please enable location services.'),
            );
          });
    }
    _permissionGranted = await checkPermission();
    if (_permissionGranted == LocationPermission.denied) {
      _permissionGranted = await requestPermission();
      if (_permissionGranted == LocationPermission.denied ||
          _permissionGranted == LocationPermission.deniedForever) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Location Permissions'),
                content: Text('Please allow location services for this app.'),
              );
            });
      }
    }
  }

  Future<void> _getLocationData() async {
    _checkPermissionServices();
    positionSubscription =
        getPositionStream(desiredAccuracy: LocationAccuracy.bestForNavigation)
            .listen((Position pos) {
          setState(() {
            position = pos;
          });

          _getAddress();
        });
  }

  Future<void> _getAddress() async {
    final coordinates = Coordinates(position.latitude, position.longitude);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    setState(() {
      address = '${first.adminArea}\n${first.countryName}';
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _getLocationData,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: size.width * 0.95,
                      height: size.height * 0.50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(63),
                              bottomRight: Radius.circular(63)),
                          image: DecorationImage(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.cover,
                              image: AssetImage(backgroundPic))),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Info(
                      text: _getFtOrMetersUnits(
                          position == null ? 0 : position.altitude),
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
                      text: _getKmOrMilesUnits(
                          position == null ? 0 : position.speed),
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
                      text: position != null
                          ? _getDMSFromLatLong(
                              position.latitude, position.longitude)
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
                      text: address ?? 'Not available...',
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
