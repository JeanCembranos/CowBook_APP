import 'package:cloud_firestore/cloud_firestore.dart';

class CowModel {
  String nombre,raza,peso;
  DateTime fechaNac;

  CowModel(this.nombre, this.raza, this.peso, this.fechaNac);
}