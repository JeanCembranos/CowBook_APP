
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfarm_app/LoginTools/userModel.dart';

class DBStream {
  Firestore _firestore = Firestore.instance;

  Stream<UserModel> getCurrentUser(String uid) {
    return _firestore
        .collection('users')
        .document(uid)
        .snapshots()
        .map((docSnapshot) => UserModel.fromDocumentSnapshot(doc: docSnapshot));
  }
}
