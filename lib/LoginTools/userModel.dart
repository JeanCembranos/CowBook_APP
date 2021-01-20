import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  DateTime accountCreated;
  String worker;
  String groupId;
  String notifToken;

  UserModel({
    this.uid,
    this.email,
    this.accountCreated,
    this.worker,
    this.groupId,
    this.notifToken,
  });

  UserModel.fromDocumentSnapshot({DocumentSnapshot doc}) {
    uid = doc.documentID;
    email = doc.data['email'];
    accountCreated = doc.data['accountCreated'].toDate();
    worker = doc.data['worker'];
    groupId = doc.data['groupId'];
    notifToken = doc.data['notifToken'];
  }
}