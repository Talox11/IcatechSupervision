class Alumno {
  String id = ''; //id_registro
  String idCurso = '';
  String nombre = '';
  String apellidoPaterno = '';
  String apellidoMaterno = '';
  String correo = '';
  String telefono = '';
  String curp = '';
  String sexo = '';
  String fechaNacimiento = '';
  String domicilio = '';
  String colonia = '';
  String municipio = '';
  String estado = '';
  String estadoCivil = '';
  String matricula = '';

  String? entidadNacimiento;
  String? observaciones;
  String? calle;
  String? seccionVota;
  String? numExt;
  String? numInt;
  String? respSatisfaccion;
  String? comSatisfaccion;

  Alumno(
    this.id,
    this.idCurso,
    this.nombre,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.correo,
    this.telefono,
    this.curp,
    this.sexo,
    this.fechaNacimiento,
    this.domicilio,
    this.colonia,
    this.municipio,
    this.estado,
    this.estadoCivil,
    this.matricula,
  );

  addNewInfo(entidadNacimiento, seccionVota, calle, numExt, numInt,
      observaciones, respSatisfaccion, comSatisfaccion) {
    this.entidadNacimiento = entidadNacimiento;
    this.observaciones = observaciones;
    this.calle = calle;
    this.seccionVota = seccionVota;
    this.numExt = numExt;
    this.numInt = numInt;
    this.respSatisfaccion = respSatisfaccion;
    this.comSatisfaccion = comSatisfaccion;
  }
}
