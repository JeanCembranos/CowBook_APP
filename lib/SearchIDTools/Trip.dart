import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String title,raza,currentUser,code;
  DateTime startDate;


  Trip(
      this.title,
      this.startDate,
      this.currentUser,
      this.raza,
      this.code
      );

  // formatting for upload to Firbase when creating the trip


  // creating a Trip object from a firebase snapshot
  Trip.fromSnapshot(DocumentSnapshot snapshot) :
        title = snapshot['name'],
        raza=snapshot['raza'],
        currentUser=snapshot['currentUser'],
        code=snapshot['code'],
        startDate = snapshot['birthDate'].toDate();
}

