import 'package:cloud_firestore/cloud_firestore.dart';

class IDModel {
 String nombre,raza;
 DateTime fechaNac;

 IDModel(this.nombre, this.raza, this.fechaNac);
}