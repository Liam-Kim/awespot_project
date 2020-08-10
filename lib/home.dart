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
  final FirebaseUser user;

  HomePage({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(user: user);
}

class _HomePageState extends State<HomePage> {
  final FirebaseUser user;

  _HomePageState({Key key, @required this.user});

  int _currentIndex = 0;

  DateTime backbuttonpressedTime;

  var tabs;

  @override
  void initState() {
    // TODO: implement initState

    tabs = [
      MapHome(),
      MapSearchPage(),
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
        //update_detail.dart의 DatePicker에 필요해서 적용
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
            child: Scaffold(
                body: Stack(children: <Widget>[
              tabs[_currentIndex],
              Positioned(
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      child: BottomNavigationBar(
                        currentIndex: _currentIndex,
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
                        backgroundColor: Colors.black,
                        selectedItemColor: Colors.white,
                        unselectedItemColor: Colors.white,
                        type: BottomNavigationBarType.fixed,
                        items: [
                          BottomNavigationBarItem(
                            icon: Icon(Icons.home),
                            title: Text(""),
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.add),
                            title: Text(""),
                          ),
                          BottomNavigationBarItem(
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
                  ))
            ])),
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
