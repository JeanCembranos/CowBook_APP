import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfarm_app/IDTools/dbID.dart';
import 'package:myfarm_app/LoginTools/ActiveRoot.dart';
import 'package:myfarm_app/LoginTools/authModel.dart';
import 'package:myfarm_app/LoginTools/userModel.dart';
import 'file:///C:/Users/JEAN/Desktop/ControlGanaderoAPP/myfarm_app/lib/RegTools/DBReg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseMessaging _fcm = FirebaseMessaging();

  Stream<AuthModel> get user {
    return _auth.onAuthStateChanged.map(
          (FirebaseUser firebaseUser) => (firebaseUser != null)
          ? AuthModel.fromFirebaseUser(user: firebaseUser)
          : null,
    );
  }

  Future<String> signOut() async {
    String retVal = "error";

    try {
      await _auth.signOut();
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> signUpUser(
      String email, String password, String worker) async {
    String retVal = "error";
    try {
      AuthResult _authResult = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      UserModel _user = UserModel(
        uid: _authResult.user.uid,
        email: _authResult.user.email,
        worker: worker.trim(),
        accountCreated: DateTime.now(),
        notifToken: await _fcm.getToken(),
      );
      String _returnString = await dbID().createUser(_user);
      if (_returnString == "success") {
        retVal = "success";
      }
    } on PlatformException catch (e) {
      retVal = e.message;
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> loginUserWithEmail(String email, String password) async {
    String retVal = "success";

    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
    } on PlatformException catch (e) {
      retVal = e.message;
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> loginUserWithGoogle() async {

    String retVal = "error";
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    /*try  {
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
      AuthResult _authResult = await _auth.signInWithCredential(credential);
      if (_authResult.additionalUserInfo.isNewUser) {
        UserModel _user = UserModel(
          uid: _authResult.user.uid,
          email: _authResult.user.email,
          worker: _authResult.user.displayName,
          accountCreated: DateTime.now(),
          notifToken: await _fcm.getToken(),
        );
        String _returnString = await DBRecords().createUser(_user);
        if (_returnString == "success") {
          retVal = "success";
        }
      }
      retVal = "success";
    } on PlatformException catch (e) {
      retVal = e.message;
    } catch (e) {
      print(e);
    }*/

  }
  Future deleteCurrentUser(String userUid,String userEmail, String password) async {

    try {
      FirebaseUser user = await _auth.currentUser();
      AuthCredential credentials =
      EmailAuthProvider.getCredential(email: userEmail, password: password);
      print(user);
      AuthResult result = await user.reauthenticateWithCredential(credentials);
      await DatabaseService(uid: userUid).deleteCurrentUser(); // called from database class
      await result.user.delete();
      DatabaseService(uid: userUid).deleteCurrentMoney();
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
  Firestore.instance.collection('users');

  Future deleteCurrentUser() {
    return userCollection.document(uid).delete();
  }
  Future deleteCurrentMoney() {
    Stream<QuerySnapshot> snapshots = Firestore.instance.collection('money').where('currentUser',isEqualTo: uid).snapshots();
    return snapshots.forEach((snapshot) =>
        snapshot.documents.forEach((document) => document.reference.delete()));

  }
}