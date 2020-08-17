import 'package:awespot_project/user_repository.dart';

import 'upload_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'map_home.dart';
import 'user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  DateTime backbuttonpressedTime;

  var tabs;

  @override
  void initState() {
    // TODO: implement initState

    tabs = [
      MapHome(),
      UserInfoPage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('ko', 'KO'),
        ],
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
            child: new Scaffold(
              body: tabs[_currentIndex],
              backgroundColor: Colors.black26,
              floatingActionButton: Container(
                width: 80,
                height: 80,
                child: new FloatingActionButton(
                  elevation: 50.0,
                  backgroundColor: HexColor("#ECAE00"),
                  tooltip: 'Increment',
                  child: new Icon(Icons.add, size: 40),
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => UploadPage()));
                  },
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                elevation: 40.0,
                currentIndex: _currentIndex,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: HexColor("#212121"),
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Padding(
                        padding: EdgeInsets.only(right: 30),
                        child: Icon(Icons.search)),
                    title: Text(""),
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Icon(Icons.person)),
                    title: Text(""),
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            ),
            onWillPop: onWillPop));
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 2);
    if (backButton) {
      backbuttonpressedTime = currentTime;
      return false;
    }
    return true;
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
