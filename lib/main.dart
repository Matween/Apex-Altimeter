import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:apex_altimeter/constants.dart';
import 'package:apex_altimeter/frontpage.dart';
import 'package:apex_altimeter/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyHomePage());
}

var backgrounds = [
  'lib/assets/background1.jpeg',
  'lib/assets/background2.jpeg',
  'lib/assets/background3.jpeg',
  'lib/assets/background5.webp'
];

var rng = new Random();
String backgroundPic = backgrounds[rng.nextInt(4)];

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  bool dark = false;
  String units = 'metric';

  void refreshUnits(String unitsC) {
    setState(() {
      units = unitsC;
    });
  }

  void refreshTheme(bool darkTheme) {
    setState(() {
      dark = darkTheme;
    });
  }

  Future<bool> getTheme({bool isInBuilder = false}) async {
    return Constants.prefs.then((SharedPreferences preferences) {
      var dt = preferences.getBool('theme') != null
          ? preferences.getBool('theme')
          : true;
      if (!isInBuilder) {
        setState(() {
          dark = dt;
        });
      }
      return dt;
    });
  }

  Future<String> getUnits({bool isInBuilder = false}) async {
    return Constants.prefs.then((SharedPreferences prefrences) {
      var un = prefrences.getString('units') != null
          ? prefrences.get('units')
          : 'metric';
      if (!isInBuilder) {
        setState(() {
          units = un;
        });
      }
      return un;
    });
  }

  int _selectedIndex = 0;

  void onTapOpened(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getTheme();
    getUnits();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _tabs = [
      FrontPage(
        title: 'Apex Altimeter',
        backgroundPic: backgroundPic,
        darkTheme: dark,
        units: units,
      ),
      SettingsPage(
        title: 'Apex Altimeter Settings',
        units: units,
        darkTheme: dark,
        notifyParentTheme: refreshTheme,
        notifyParentUnits: refreshUnits,
      )
    ];

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
        title: 'Apex Altimeter',
        color: Color.fromRGBO(0, 147, 118, 1),
        debugShowCheckedModeBanner: false,
        theme: dark ? Constants.darkTheme : Constants.lightTheme,
        home: Scaffold(
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                SliverAppBar(
                  stretch: true,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
                  onStretchTrigger: () {
                    // Function callback for stretch
                    return Future.value();
                  },
                  pinned: true,
                  expandedHeight: Constants.size.height * 0.5,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: <StretchMode>[
                      StretchMode.zoomBackground,
                    ],
                    centerTitle: true,
                    title: const Text('Apex Altimeter'),
                    background: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(backgroundPic), fit: BoxFit.cover),
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))
                      ),
                    )
                  ),
                ),
                SliverFillRemaining(child: FutureBuilder<List>(
                  future: Future.wait([
                    getTheme(isInBuilder: true),
                    getUnits(isInBuilder: true)
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return _tabs[_selectedIndex];
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),)

              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: onTapOpened,
              currentIndex: _selectedIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.route),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.cog),
                  label: '',
                )
              ],
            )
        )
    );
  }
}
