import 'package:awespot_project/feed.dart';
import 'package:awespot_project/spot.dart';
import 'package:awespot_project/user_repository.dart';

import 'upload_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'map_home.dart';
import 'user_info.dart';
import 'upload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:awespot_project/widget/change_hexcolor.dart';

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
      SpotPage(),
      MapHome(),
      UploadPage(),
      FeedPage(),
      UserInfoPage(),
    ];
    super.initState();
  } 

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
        //  const Locale('en', 'US'),
          const Locale('ko', 'KR'),
        ],
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
            child: new Scaffold(
              body: tabs[_currentIndex],
              backgroundColor: Colors.black26,
              bottomNavigationBar: BottomNavigationBar(
                elevation: 40.0,
                currentIndex: _currentIndex,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: HexColor("#212121"),
                selectedItemColor: HexColor("#ECAE00"),
                unselectedItemColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.star_border),
                    title: Text(""),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.public),
                    title: Text(""),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add_box),
                    title: Text(""),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.message),
                    title: Text(""),
                  ),BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    title: Text(""),
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
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

