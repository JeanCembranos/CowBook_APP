import 'package:cloud_firestore/cloud_firestore.dart';

class dbQR {
  Firestore _firestore = Firestore.instance;
  /*Create Publicity carousel images data documents*/

  Future<String> createGroupQR(String codigo,String currentUser) async {
    String retVal = "error";
    try {
      await _firestore.collection("CreatedQR").add({
        'codigo': codigo,
        'currentUser': currentUser
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }


  getData() async{
    //Test if cloud firestore works
    //return await Firestore.instance.collection('Publicity').getDocuments();
    return await Firestore.instance.collection('CreatedQR').getDocuments();
  }
}