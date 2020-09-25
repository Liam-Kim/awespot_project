import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/login_state.dart';

class FeedPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
   // final UserRepository providerUser = Provider.of<UserRepository>(context);
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          //  Text(providerUser.user.email),
            RaisedButton(
              child: Text("Feed",style: TextStyle(color: Colors.white)),
             // onPressed: () => Provider.of<UserRepository>(context, listen: false).signOut(),
            )
          ],
        ),
      );
  }
}