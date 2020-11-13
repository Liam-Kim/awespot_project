import 'package:awespot_project/model/map_key.dart';
import 'package:awespot_project/model/post_model.dart';
import 'package:awespot_project/repo/transformer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import 'dart:io';

class PostRepository with Transformers {
  
  Future<Map<String, dynamic>> createNewPost(
      String postKey, Map<String, dynamic> postData) async {
    final DocumentReference postRef =
        Firestore.instance.collection(COLLECTION_POSTS).document(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();
    final DocumentReference userRef = Firestore.instance
        .collection(COLLECTION_USERS)
        .document(postData[KEY_USERKEY]);

    return Firestore.instance.runTransaction((Transaction tx) async {
      if (!postSnapshot.exists) {
        await tx.set(postRef, postData);
        await tx.update(userRef, {
          KEY_MYPOSTS: FieldValue.arrayUnion([postKey])
        });
      }
    });
  }

  Future<void> updatePostImageUrl({String postImg, String postKey}) async {
    final DocumentReference postRef =
        Firestore.instance.collection(COLLECTION_POSTS).document(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();

    if (!postSnapshot.exists) {
      postRef.updateData({KEY_POSTIMG: postImg});
    }
  }

  Stream<void> getPostsFromSpecificUser(String userKey) {
    return Firestore.instance
        .collection(COLLECTION_POSTS)
        .where(KEY_USERKEY, isEqualTo: userKey)
        .snapshots()
        .transform(toPosts);
  }

  Stream<List<PostModel>> fetchPostsFromAllFollowers(List<dynamic> followers) {
    final CollectionReference collectionReference =
        Firestore.instance.collection(COLLECTION_POSTS);

    List<Stream<List<PostModel>>> streams = [];

    for (final follower in followers) {
      streams.add(collectionReference
          .where(KEY_USERKEY, isEqualTo: follower)
          .snapshots()
          .transform(toPosts));
    }

    return CombineLatestStream.list<List<PostModel>>(streams)
        .transform(combineListOfPosts)
        .transform(latestToTop);
  }
}

PostRepository postRepository = PostRepository();


