import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_repository.dart';

class UserInfoPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
   // final UserRepository providerUser = Provider.of<UserRepository>(context);
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          //  Text(providerUser.user.email),
            RaisedButton(
              child: Text("SIGN OUT",style: TextStyle(color: Colors.white)),
             // onPressed: () => Provider.of<UserRepository>(context, listen: false).signOut(),
            )
          ],
        ),
      );
  }
}