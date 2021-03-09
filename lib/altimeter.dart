import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class Altimeter {
  static final Altimeter _singleton = Altimeter._internal();

  factory Altimeter() {
    return _singleton;
  }

  Altimeter._internal();

  static bool _serviceEnabled = false;
  static LocationPermission _permissionGranted;
  static Position position;
  static String address;

  static getDMSFromLatLong(double lat, double lon) {
    var latResult, lonResult;

    latResult = (lat >= 0) ? 'N' : 'S';
    lonResult = (lon >= 0) ? 'E' : 'W';

    String dmsLat = getDMS(lat) + ' ' + latResult;
    String dmsLon = getDMS(lon) + ' ' + lonResult;

    return dmsLat + '\n' + dmsLon;
  }

  static getDMS(double val) {
    var valDeg, valMin, valSec, result;

    valDeg = val.floor();

    result = valDeg.toString() + 'º ';

    valMin = ((val - valDeg) * 60).floor();

    result += valMin.toString() + "' ";

    valSec = ((val - valDeg - valMin / 60) * 3600 * 1000).round() / 1000;

    result += valSec.floor().toString() + '" ';

    return result;
  }

  static getFtOrMetersUnits(double val, String units) {
    return units == 'metric'
        ? val.toStringAsFixed(2) + ' m'
        : (val * 3.28084).toStringAsFixed(2) + ' ft';
  }

  static getKmOrMilesUnits(double val, String units) {
    return units == 'metric'
        ? (val * 3.6).toStringAsFixed(2) + ' km/h'
        : (val * 2.236936).toStringAsFixed(2) + ' mph';
  }

  static Future<bool> isPermissionGranted() async {
    _serviceEnabled = await isLocationServiceEnabled();
    if (!_serviceEnabled) return false;

    _permissionGranted = await checkPermission();
    if (_permissionGranted == LocationPermission.denied) {
      _permissionGranted = await requestPermission();
      if (_permissionGranted == LocationPermission.denied ||
          _permissionGranted == LocationPermission.deniedForever) {
        return false;
      }
      return false;
    }

    return true;
  }

  static Stream<Position> getLocationData() {
    return getPositionStream(desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  static Future<String> getAddress(Position position) async {
    final coordinates = Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    return '${first.adminArea}\n${first.countryName}';
  }
}
