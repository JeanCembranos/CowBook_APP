import 'package:cloud_firestore/cloud_firestore.dart';

import 'RegLecheModel.dart';
import 'RegModel.dart';
class DBProduLeche {
  Firestore _firestore = Firestore.instance;


  /*Create Car database*/
  Future<String> createGroup(RegLecheModel registro, String data, String currentUser,String code) async {
    String retVal = "error";
    try {
      await _firestore.collection("DBProduLeche").add({
        'fechaReg': registro.fechaReg,
        'cantProd': registro.cant,
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
    return await Firestore.instance.collection('DBProduLeche').getDocuments();
  }
  /*Update Car element*/
  updateRegLeche(selectedDoc, newValues){
    Firestore.instance.collection('DBProduLeche').document(selectedDoc).updateData(newValues).catchError((e){
      print(e);
    });
  }
  /*Delete car element */
  deleteReg(docId){
    Firestore.instance.collection('DBProduLeche').document(docId).delete().catchError((e){
      print(e);
    });
  }
}