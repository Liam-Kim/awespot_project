import 'package:awespot_project/model/map_key.dart';
import 'package:awespot_project/repo/transformer.dart';
import 'package:flutter/foundation.dart';
import 'package:awespot_project/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awespot_project/model/map_key.dart';
import 'package:awespot_project/repo/transformer.dart';

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

  Stream<List<UserModel>> getAllUsersWithoutMe() {
    return Firestore.instance
        .collection(COLLECTION_USERS)
        .snapshots()
        .transform(toUsersExceptMe);
  }

  Future<void> getData() {
    return Firestore.instance
        .collection('users')
        .document('uid')
        .get()
        .then((doc) => null);
  }

  Future<void> followUser({String myUserKey, String otherUserKey}) async {
    final DocumentReference myUserRef =
        Firestore.instance.collection(COLLECTION_USERS).document(myUserKey);
    final DocumentSnapshot mySnapshot = await myUserRef.get();
    final DocumentReference otherUserRef =
        Firestore.instance.collection(COLLECTION_USERS).document(otherUserKey);
    final DocumentSnapshot otherSnapshot = await otherUserRef.get();

    Firestore.instance.runTransaction((tx) async{
      if(mySnapshot.exists && otherSnapshot.exists){
        tx.update(myUserRef, {KEY_FOLLOWINGS:FieldValue.arrayUnion([otherUserKey])});
        int currentFollowers = otherSnapshot.data[KEY_FOLLOWERS];
        tx.update(otherUserRef, {KEY_FOLLOWERS:currentFollowers+1});
      }
    });
  }

  Future<void> unfollowUser({String myUserKey, String otherUserKey}) async {
    final DocumentReference myUserRef =
        Firestore.instance.collection(COLLECTION_USERS).document(myUserKey);
    final DocumentSnapshot mySnapshot = await myUserRef.get();
    final DocumentReference otherUserRef =
        Firestore.instance.collection(COLLECTION_USERS).document(otherUserKey);
    final DocumentSnapshot otherSnapshot = await otherUserRef.get();

    Firestore.instance.runTransaction((tx) async{
      if(mySnapshot.exists && otherSnapshot.exists){
        tx.update(myUserRef, {KEY_FOLLOWINGS:FieldValue.arrayRemove([otherUserKey])});
        int currentFollowers = otherSnapshot.data[KEY_FOLLOWERS];
        tx.update(otherUserRef, {KEY_FOLLOWERS:currentFollowers-1});
      }
    });
  }


}

UserRepository userRepository = UserRepository();
