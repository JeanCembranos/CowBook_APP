import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfarm_app/HistMedicoTools/RegistroMedicoModel.dart';
import 'package:myfarm_app/LoginTools/userModel.dart';
import 'package:myfarm_app/ObsTools/ObsModel.dart';

class DBRecords {
  Firestore _firestore = Firestore.instance;

  /*Create User database*/
  Future<String> createUser(UserModel user) async {
    String retVal = "error";

    try {
      await _firestore.collection("users").document(user.uid).setData({
        'worker': user.worker.trim(),
        'email': user.email.trim(),
        'accountCreated': DateTime.now(),
        'notifToken': user.notifToken,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }
  /*Get user from database*/
  Future<UserModel> getUser(String uid) async {
    UserModel retVal;

    try {
      DocumentSnapshot _docSnapshot =
      await _firestore.collection("users").document().get();
      retVal = UserModel.fromDocumentSnapshot(doc: _docSnapshot);
    } catch (e) {
      print(e);
    }

    return retVal;
  }
  /*Create Car database*/
  Future<String> createGroup(RegMedModel registro, String data, String currentUser) async {
    String retVal = "error";
    try {
      await _firestore.collection("records").add({
        'actividad': registro.actividad,
        'descripcion': registro.Descripcion,
        'fechaApli': registro.fechaAplicacion,
        'fechaApliProx': registro.fechaAplicacionProx,
        'tipo': registro.tipo,
        'codigo': data,
        'currentUser': currentUser,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> createGroupI(ObsModel obsRegistro, String data, String currentUser) async {
    String retVal = "error";
    try {
      await _firestore.collection("records").add({
        'actividad': obsRegistro.actividad,
        'descripcion': obsRegistro.Descripcion,
        'nivelI': obsRegistro.nivelI,
        'fechaControl': obsRegistro.fechaControl,
        'fechaControlProx': obsRegistro.fechaControlProx,
        'tipo': obsRegistro.tipo,
        'codigo': data,
        'currentUser': currentUser,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }
  /*Create Car documents*/
  getData() async{
    return await Firestore.instance.collection('records').getDocuments();
  }
  /*Update Car element*/
  updateCars(selectedDoc, newValues){
    Firestore.instance.collection('records').document(selectedDoc).updateData(newValues).catchError((e){
      print(e);
    });
  }
  /*Delete car element */
  deleteCar(docId){
    Firestore.instance.collection('records').document(docId).delete().catchError((e){
      print(e);
    });
  }
}