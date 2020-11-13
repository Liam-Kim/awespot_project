import 'package:awespot_project/model/user_model.dart';
import 'package:awespot_project/repo/user_repository.dart';
import 'package:awespot_project/provider/user_state.dart';
import 'package:awespot_project/spot.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:awespot_project/home.dart';
import 'provider/login_state.dart';
import 'login.dart';

SharedPreferences prefs;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: MainPage());
  }
}

class MainPage extends StatelessWidget {
  Widget _currentWidget;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginState>(
          create: (_) => LoginState.instance(),
        ),
        ChangeNotifierProvider<UserModelState>(
          create: (_) => UserModelState(),
        )
      ],
      child: Consumer(
        builder: (BuildContext context, LoginState loginState, Widget child) {
          switch (loginState.status) {
            case Status.Uninitialized:
              _currentWidget = LoginPage();
              break;
            case Status.Unauthenticated:
              _currentWidget = LoginPage();
              break;
            case Status.Authenticating:
              _currentWidget = Splash();
              break;
            case Status.Authenticated:
            _initLogin(loginState, context);
              _currentWidget = HomePage();
              break;
          }
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _currentWidget,
          );
        },
      ),
    );

    //ChangeNotifierProvider(
    //   create: (_) => LoginState.instance(),
    //   child: Consumer(
    //     builder: (context, LoginState user, _) {
    //       switch (user.status) {
    //         case Status.Uninitialized:
    //           return LoginPage();
    //         case Status.Unauthenticated:
    //           return LoginPage();
    //         case Status.Authenticating:

    //         case Status.Authenticated:
    //           return HomePage();
    //       }
    //     },
    //   ),
    // );
  }

  void _initLogin(LoginState loginState, BuildContext context) {
    userRepository.getUserModelStream(loginState.user.uid).listen((userModel) {
      Provider.of<UserModelState>(context, listen: false).userModel = userModel;
    });
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text("Splash Screen"),
      ),
    );
  }
}
