import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/login_state.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginState>(context);
    return Scaffold(
        body: user.status == Status.Authenticating
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.lightBlue,
                  child: MaterialButton(
                    onPressed: () async {
                      user.signInWithGoogle();
                    },
                    child: Text(
                      "Google Sign In",
                      style: style.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
