import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfarm_app/HistMedicoTools/RegistroMedicoModel.dart';
import 'package:myfarm_app/LoginTools/userModel.dart';
import 'package:myfarm_app/ObsTools/ObsModel.dart';

import 'CowModel.dart';

class dbID {
  Firestore _firestore = Firestore.instance;

  /*Create User database*/

  /*Create Car database*/
  Future<String> createGroup(CowModel cow, String data, String currentUser) async {
    String retVal = "error";
    try {
      await _firestore.collection("dbID").add({
        'nombre': cow.nombre,
        'raza': cow.raza,
        'peso': cow.peso,
        'fechaNac': cow.fechaNac,
        'currentUser': currentUser,
        'codigo': data,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }
  /*Create Car documents*/
  getData() async{
    return await Firestore.instance.collection('dbID').getDocuments();
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