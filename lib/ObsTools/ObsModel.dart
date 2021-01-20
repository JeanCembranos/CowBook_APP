import 'package:firebase_auth/firebase_auth.dart';

class ObsModel {
  String actividad;
  String Descripcion;
  String nivelI;
  DateTime fechaControl;
  DateTime fechaControlProx;
  String tipo;

  ObsModel(this.actividad, this.Descripcion, this.nivelI, this.fechaControl,
      this.fechaControlProx, this.tipo);
}