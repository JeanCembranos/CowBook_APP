import 'package:cloud_firestore/cloud_firestore.dart';

import 'RegLecheModel.dart';
import 'RegModel.dart';
class DBProduLeche {
  Firestore _firestore = Firestore.instance;


  /*Create Car database*/
  Future<String> createGroup(RegLecheModel registro, String data, String currentUser,String code) async {
    String retVal = "error";
    try {
      await _firestore.collection("DBProduLeche").document(currentUser).collection(data).add({
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
  getData(String currentUser,String data) async{
    return await Firestore.instance.collection('DBProduLeche').document(currentUser).collection(data).getDocuments();
  }
  /*Update Car element*/
  updateRegLeche(selectedDoc,String currentUser,String data, newValues){
    Firestore.instance.collection('DBProduLeche').document(currentUser).collection(data).document(selectedDoc).updateData(newValues).catchError((e){
      print(e);
    });
  }
  /*Delete car element */
  deleteReg(docId,String currentUser,String data){
    Firestore.instance.collection('DBProduLeche').document(currentUser).collection(data).document(docId).delete().catchError((e){
      print(e);
    });
  }
}