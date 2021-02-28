import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfarm_app/LoginTools/userModel.dart';

import 'RegModel.dart';
class DBReg {
  Firestore _firestore = Firestore.instance;


  /*Create Car database*/
  Future<String> createGroup(RegModel registro, String data, String currentUser,String code) async {
    String retVal = "error";
    try {
      await _firestore.collection("DBReg").add({
        'medicamento': registro.medicamento,
        'fechaIni': registro.InitialDate,
        'fechaFin': registro.FinalDate,
        'observaciones': registro.observaciones,
        'codigo': data,
        'currentUser': currentUser,
        'RegID': code,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  /*Create Car documents*/
  getData() async{
    return await Firestore.instance.collection('DBReg').getDocuments();
  }
  /*Update Car element*/
  updateReg(selectedDoc, newValues){
    Firestore.instance.collection('DBReg').document(selectedDoc).updateData(newValues).catchError((e){
      print(e);
    });
  }
  /*Delete car element */
  deleteReg(docId){
    Firestore.instance.collection('DBReg').document(docId).delete().catchError((e){
      print(e);
    });
  }
}