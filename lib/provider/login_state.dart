import 'package:awespot_project/model/map_key.dart';
import 'package:awespot_project/provider/user_state.dart';
import 'package:awespot_project/repo/user_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  // Unjoined
}

SharedPreferences prefs;

class LoginState with ChangeNotifier {
 
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  GoogleSignIn googleSignIn = GoogleSignIn();


  LoginState.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get user => _user;

  set setStatus(Status changedStatus) {
    _status = changedStatus;
    notifyListeners();
  }

  // Future<bool> signIn(String email, String password) async {
  //   try {
  //     _status = Status.Authenticating;
  //     notifyListeners();
  //     await _auth.signInWithEmailAndPassword(email: email, password: password);
  //     return true;
  //   } catch (e) {
  //     _status = Status.Unauthenticated;
  //     notifyListeners();
  //     return false;
  //   }
  // }

  Future<bool> signInWithGoogle() async {
    _status = Status.Authenticating;
    prefs = await SharedPreferences.getInstance();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    try {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      
      _user = (await _auth.signInWithCredential(credential)).user;
      notifyListeners();

      return true;
    } catch (err) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    await _auth.signOut();
    await googleSignIn.signOut();
    _status = Status.Unauthenticated;
    prefs = null;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
      notifyListeners();
    } else {
      _user = firebaseUser;
      await Firestore.instance
          .collection(COLLECTION_USERS)
          .document(firebaseUser.uid)
          .get()
          .then((value) {
        value.exists
            ? _status = Status.Authenticated
            : _createAccount(firebaseUser);
        notifyListeners();
      });
      //_user = firebaseUser;
    }
  }

  Future<void> _createAccount(FirebaseUser firebaseUser) async {
    await userRepository.createUser(
        userKey: firebaseUser.uid, email: firebaseUser.email);
    _status = Status.Authenticated;
    notifyListeners();
  }
}
