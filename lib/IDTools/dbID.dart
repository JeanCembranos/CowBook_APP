import 'package:cloud_firestore/cloud_firestore.dart';

import 'IDModel.dart';

class dbID {
  Firestore _firestore = Firestore.instance;
  DateTime fechaFinTer,fechainiDeste,fechaFinDeste,fechaIniNovi,fechaFinNovi,fechaIniAdulta;
  /*Create Publicity carousel images data documents*/

  Future<String> createID(String codigo,String currentUser,IDModel id,String image_url) async {
    calcFechas(id.fechaNac);
    String retVal = "error";
    try {
      await _firestore.collection("CowIDs").add({
        'code': codigo,
        'currentUser': currentUser,
        'name': id.nombre,
        'raza': id.raza,
        'birthDate': id.fechaNac,
        'fechaIniDeste' : fechainiDeste,
        'fechaIniNovi' : fechaIniNovi,
        'fechaIniAdulta' : fechaIniAdulta,
        'imageUrl': image_url,
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
    return await Firestore.instance.collection('CowIDs').getDocuments();
  }
  updateID(selectedDoc, newValues){
    Firestore.instance.collection('CowIDs').document(selectedDoc).updateData(newValues).catchError((e){
      print(e);
    });
  }
  deleteID(docId){
    Firestore.instance.collection('CowIDs').document(docId).delete().catchError((e){
      print(e);
    });
  }
  calcFechas(DateTime inicio){
    fechaFinTer=new DateTime(inicio.year,inicio.month+4,inicio.day);
    fechainiDeste=new DateTime(inicio.year,inicio.month+4,inicio.day);
    fechaFinDeste=new DateTime(inicio.year,inicio.month+6,inicio.day);
    fechaIniNovi=new DateTime(inicio.year,inicio.month+6,inicio.day);
    fechaFinNovi=new DateTime(inicio.year,inicio.month+12,inicio.day);
    fechaIniAdulta=new DateTime(inicio.year,inicio.month+12,inicio.day);

  }
}