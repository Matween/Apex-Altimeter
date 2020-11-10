import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

class XMLHelpers {
  static Future<Map> readXMLFile() async {
    try {
      var file = await localFile;

      // Read the file
      String contents = await file.readAsString();
      final document = XmlDocument.parse(contents);
      var map = {
        'units': document.findElements('settings').first.findElements('units').first.innerText,
        'darktheme': document.findElements('settings').first.findElements('darktheme').first.innerText.toLowerCase() == '1'
      };
      return map;
    } catch (e) {
      // If encountering an error, return empty string
      return {};
    }
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get localFile async {
    final path = await _localPath;
    return File(path + '/apexdata.xml');
  }
}