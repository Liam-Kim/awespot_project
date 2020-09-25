import 'package:awespot_project/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awespot_project/provider/user_state.dart';
import 'package:awespot_project/provider/login_state.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserModelState providerUser = Provider.of<UserModelState>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(providerUser.userModel.username,
              style: TextStyle(color: Colors.white)),
              Text(providerUser.userModel.username,
              style: TextStyle(color: Colors.white)),
          RaisedButton(
            child: Text("SIGN OUT", style: TextStyle(color: Colors.white)),
            onPressed: () =>
                Provider.of<LoginState>(context, listen: false).signOut(),
          )
        ],
      ),
    );
  }
}
