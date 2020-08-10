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
  Unjoined
}

SharedPreferences prefs;

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  GoogleSignIn googleSignIn = GoogleSignIn();

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get user => _user;

  set setStatus(Status changedStatus) {
    _status = changedStatus;
    print("set status 들어왔니");
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    prefs = await SharedPreferences.getInstance();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    try {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      _status = Status.Authenticating;
      notifyListeners();
      _user = (await _auth.signInWithCredential(credential)).user;

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
      Firestore.instance
          .collection('User')
          .document(firebaseUser.uid)
          .get()
          .then((value) {
        value.exists
            ? _status = Status.Authenticated
            : _status = Status.Unjoined;
        notifyListeners();
      });
      //_user = firebaseUser;
    }
  }
}
