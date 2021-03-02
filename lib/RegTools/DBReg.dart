import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfarm_app/LoginTools/userModel.dart';

import 'RegModel.dart';
class DBReg {
  Firestore _firestore = Firestore.instance;


  /*Create Car database*/
  Future<String> createGroup(RegModel registro, String data, String currentUser,String code) async {
    String retVal = "error";
    try {
      await _firestore.collection("DBReg").document(currentUser).collection(data).add({
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
  getData(String currentUser,String data) async{
    return await Firestore.instance.collection('DBReg').document(currentUser).collection(data).getDocuments();
  }
  /*Update Car element*/
  updateReg(selectedDoc,String currentUser,String data, newValues){
    Firestore.instance.collection('DBReg').document(currentUser).collection(data).document(selectedDoc).updateData(newValues).catchError((e){
      print(e);
    });
  }
  /*Delete car element */
  deleteReg(docId, String currentUser,String data){
    Firestore.instance.collection('DBReg').document(currentUser).collection(data).document(docId).delete().catchError((e){
      print(e);
    });
  }
}