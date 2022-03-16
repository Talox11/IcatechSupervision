import 'package:flutter_banking_app/models/alumnomodel.dart';

class Grupo {
  String id = '';
  String curso = '';
  String cct = '';
  String unidad = '';
  String clave = '';
  String inicio = '';
  String termino = '';
  List alumnos = [];
  Grupo(this.id, this.curso, this.cct, this.unidad, this.clave, this.inicio,
      this.termino);

  setAlumnos(alumnos) {
    this.alumnos = alumnos;
  }
}
