import 'package:firebase_auth/firebase_auth.dart';

class RegMedModel {
  String actividad;
  String Descripcion;
  DateTime fechaAplicacion;
  DateTime fechaAplicacionProx;
  String tipo;

  RegMedModel(this.actividad, this.Descripcion, this.fechaAplicacion,
      this.fechaAplicacionProx, this.tipo);
}