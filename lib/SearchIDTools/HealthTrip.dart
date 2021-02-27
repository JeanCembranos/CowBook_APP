import 'package:cloud_firestore/cloud_firestore.dart';

class HealthTrip {
  String medicamento,currentUser,codigo,observaciones;
  DateTime fechaIni,fechaFin;


  HealthTrip(
      this.medicamento,
      this.fechaIni,
      this.fechaFin,
      this.currentUser,
      this.observaciones,
      this.codigo
      );

  // formatting for upload to Firbase when creating the trip


  // creating a Trip object from a firebase snapshot
  HealthTrip.fromSnapshot(DocumentSnapshot snapshot) :
        medicamento = snapshot['medicamento'],
        fechaIni=snapshot['fechaIni'].toDate(),
        fechaFin=snapshot['fechaFin'].toDate(),
        currentUser=snapshot['currentUser'],
        codigo = snapshot['codigo'],
        observaciones=snapshot['observaciones'];
}
