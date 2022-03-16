class Alumno {
  String nombre = '';
  String curp = '';
  String matricula = '';

  String id;
  String apellidoPaterno = '';
  String apellidoMaterno = '';
  String correo = '';
  String telefono = '';
  String sexo = '';
  String fechaNacimiento = '';
  String domicilio = '';
  String colonia = '';
  String estado = '';

  // Alumno({required this.nombre, required this.curp, required this.matricula});
  Alumno(nombre, curp, matricula, this.id, apellidoPaterno, apellidoMaterno, correo,
      telefono, sexo, fechaNacimiento, domicilio, colonia, estado) {
    this.nombre = nombre;
    this.curp = curp;
    this.matricula = matricula;
    this.apellidoPaterno = apellidoPaterno;
    this.apellidoMaterno = apellidoMaterno;
    this.correo = correo;
    this.telefono = telefono;
    this.sexo = sexo;
    this.fechaNacimiento = fechaNacimiento;
    this.domicilio = domicilio;
    this.colonia = colonia;
    this.estado = estado;
  }

  setAlumnoDetail(id, apellidoPaterno, apellidoMaterno, correo, telefono, sexo,
      fechaNacimiento, domicilio, colonia, estado) {
    this.id = id;
    this.apellidoPaterno = apellidoPaterno;
    this.apellidoMaterno = apellidoMaterno;
    this.correo = correo;
    this.telefono = telefono;
    this.sexo = sexo;
    this.fechaNacimiento = fechaNacimiento;
    this.domicilio = domicilio;
    this.colonia = colonia;
    this.estado = estado;
  }
}
