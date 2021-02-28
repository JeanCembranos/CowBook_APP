import 'package:cloud_firestore/cloud_firestore.dart';

class SearchDelMod {
  DateTime fechaReg;
  String RegID, codigo, currentUser;
  double cant;



  SearchDelMod(
     this.fechaReg,this.currentUser,this.RegID,this.codigo,this.cant
      );

  // formatting for upload to Firbase when creating the trip


  // creating a Trip object from a firebase snapshot
  SearchDelMod.fromSnapshot(DocumentSnapshot snapshot) :
       fechaReg=snapshot['fechaReg'].toDate(),
  RegID=snapshot['RegID'],
  codigo=snapshot['codigo'],
  currentUser=snapshot['currentUser'],
  cant=double.parse(snapshot['cantProd']);
}

