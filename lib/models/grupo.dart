import 'package:flutter_banking_app/models/alumno.dart';

class Grupo {
  String id = '';
  String curso = '';
  String cct = '';
  String unidad = '';
  String clave = '';
  String mod = '';
  String inicio = '';
  String termino = '';
  String area = '';
  String espe = '';
  String tcapacitacion = '';
  String depen = '';
  String tipoCurso = '';
  int isEditing = 0;
  int isQueue = 0;
  List<Alumno> alumnos = [];
  Grupo(
      this.id,
      this.curso,
      this.cct,
      this.unidad,
      this.clave,
      this.mod,
      this.inicio,
      this.termino,
      this.area,
      this.espe,
      this.tcapacitacion,
      this.depen,
      this.tipoCurso);

  setAlumnos(response) {
    for (var item in response) {
      Alumno alu = Alumno(
        item['id'],
        item['id_curso'],
        item['nombre'],
        item['curp'],
        item['matricula'],
        item['apellido_paterno'],
        item['apellido_materno'],
        item['correo'] ?? 'no cuenta con email',
        item['telefono'] ?? 'no cuenta con telefono',
        item['sexo'],
        item['fecha_nacimiento'],
        item['domicilio'],
        item['estado'],
        item['estado_civil'],
      );
      alumnos.add(alu);
    }
  }

 
}
