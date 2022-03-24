class Alumno {
  String id = '';
  String idCurso = '';
  String nombre = '';
  String curp = '';
  String matricula = '';
  String apellidoPaterno = '';
  String apellidoMaterno = '';
  String correo = '';
  String telefono = '';
  String sexo = '';
  String fechaNacimiento = '';
  String domicilio = '';
  String estado = '';
  String estadoCivil = '';

  String? entidadNacimiento;
  String? seccionVota;
  String? calle;
  String? numExt;
  String? numInt;
  String? observaciones;

  Alumno(
    this.id,
    this.idCurso,
    this.nombre,
    this.curp,
    this.matricula,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.correo,
    this.telefono,
    this.sexo,
    this.fechaNacimiento,
    this.domicilio,
    this.estado,
    this.estadoCivil,
  );

  addNewInfo(
      entidadNacimiento, seccionVota, calle, numExt, numInt, observaciones) {
    this.entidadNacimiento = entidadNacimiento;
    this.seccionVota = seccionVota;
    this.calle = calle;
    this.numExt = numExt;
    this.numInt = numInt;
    this.observaciones = observaciones;
  }
}
