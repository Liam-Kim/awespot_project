import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awespot_project/model/user_model.dart';

class Transformers {
  final toUser = StreamTransformer<DocumentSnapshot, UserModel>.fromHandlers(
      handleData: (snapshot, sink) async {
    sink.add(UserModel.fromSnapshot(snapshot));
  });
}
