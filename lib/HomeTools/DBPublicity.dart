import 'package:cloud_firestore/cloud_firestore.dart';

class DBPublicity {
  Firestore _firestore = Firestore.instance;
  /*Create Publicity carousel images data documents*/
  getData() async{
    //Test if cloud firestore works
    //return await Firestore.instance.collection('Publicity').getDocuments();
    return await Firestore.instance.collection('Publicity').document('Carousel').collection('images').getDocuments();
  }
}