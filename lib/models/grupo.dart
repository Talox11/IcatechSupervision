import 'package:supervision_icatech/models/alumno.dart';

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

  addAlumos(response) {
    for (var item in response) {
      Alumno alu = Alumno(
        item['id'].toString(),
        item['id_curso'].toString(),
        item['nombre'],
        item['apellido_paterno'] ?? '',
        item['apellido_materno'],
        item['correo'] ?? 'no cuenta con email',
        item['telefono'] ?? 'no cuenta con telefono',
        item['curp'],
        item['sexo'],
        item['fecha_nacimiento'],
        item['domicilio'],
        item['colonia'],
        item['municipio'] ?? 'sin especificar',
        item['estado'],
        item['estado_civil'] ?? 'sin especificar',
        item['matricula'],
      );
      alumnos.add(alu);
    }
  }

  addAlumos2(response) {
    for (var item in response) {
      Alumno alu = Alumno(
        item['id_registro'].toString(),
        item['id_curso'].toString(),
        item['nombre'],
        item['apellido_paterno'],
        item['apellido_materno'],
        item['correo'] ?? 'no cuenta con email',
        item['telefono'] ?? 'no cuenta con telefono',
        item['curp'],
        item['sexo'],
        item['fecha_nacimiento'],
        item['domicilio'],
        item['colonia'],
        item['municipio'],
        item['estado'],
        item['estado_civil'],
        item['matricula'],
      );

      alu.entidadNacimiento = item['entidad_nacimiento'];
      alu.observaciones = item['observaciones'];
      alu.calle = item['calle'];
      alu.seccionVota = item['seccion_vota'];
      alu.numExt = item['numExt'];
      alu.numInt = item['numInt'];
      alu.respSatisfaccion = item['resp_satisfaccion'];
      alu.comSatisfaccion = item['com_satisfaccion'];

      alumnos.add(alu);
    }
  }

  setListAlumnos(listAlumnos) {
    alumnos = listAlumnos;
    print(alumnos);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'curso': curso,
      'cct': cct,
      'unidad': unidad,
      'clave': clave,
      'mod': mod,
      'inicio': inicio,
      'termino': termino,
      'area': area,
      'espe': espe,
      'tcapacitacion': tcapacitacion,
      'depen': depen,
      'tipo_curso': tipoCurso,
      'isEditing': isEditing,
      'isQueue': isQueue,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'curso': curso,
      'cct': cct,
      'unidad': unidad,
      'clave': clave,
      'mod': mod,
      'inicio': inicio,
      'termino': termino,
      'area': area,
      'espe': espe,
      'tcapacitacion': tcapacitacion,
      'depen': depen,
      'tipo_curso': tipoCurso,
      'isEditing': isEditing,
      'isQueue': isQueue,
      'alumnos': alumnos,
    };
  }
}
