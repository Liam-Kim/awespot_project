import 'package:awespot_project/model/map_key.dart';
import 'package:awespot_project/repo/transformer.dart';
import 'package:flutter/foundation.dart';
import 'package:awespot_project/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awespot_project/model/map_key.dart';
import 'package:awespot_project/repo/transformer.dart';

class UserModelState extends ChangeNotifier {
  UserModel _userModel;
  UserModel get userModel => _userModel;

  set userModel(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }

  // MyUserDataStatus _myUserDataStatus = MyUserDataStatus.progress;
  // MyUserDataStatus get status => _myUserDataStatus;

  // void setUserData(UserModel user) {
  //   _myUserData = user;
  //   _myUserDataStatus = MyUserDataStatus.exist;
  //   notifyListeners();
  // }

  // void setNewStatus(MyUserDataStatus status) {
  //   _myUserDataStatus = status;
  //   notifyListeners();
  // }

  // void clearUser() {
  //   _myUserData = null;
  //   _myUserDataStatus = MyUserDataStatus.none;
  //   notifyListeners();
  // }

  // bool amIFollowingThisUser(String userKey) {
  //   return _myUserData.followings.contains(userKey);
  // }
}

// enum MyUserDataStatus { progress, none, exist }

class UserRepository with Transformers {
  Future<void> createUser({String userKey, String email}) async {
    final DocumentReference userRef =
        Firestore.instance.collection(COLLECTION_USERS).document(userKey);

    DocumentSnapshot snapshot = await userRef.get();
    if (!snapshot.exists) {
      userRef.setData(UserModel.geMapForCreateUser(email));
    }
  }

  Stream<UserModel> getUserModelStream(String userKey) {
    return Firestore.instance
        .collection(COLLECTION_USERS)
        .document(userKey)
        .snapshots()
        .transform(toUser);
  }

  Future<void> getData() {
    return Firestore.instance
        .collection('users')
        .document('uid')
        .get()
        .then((doc) => null);
  }
}

UserRepository userRepository = UserRepository();
