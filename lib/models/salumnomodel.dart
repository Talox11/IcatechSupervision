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
  Alumno(this.nombre, this.curp, this.matricula, this.id, this.apellidoPaterno, this.apellidoMaterno, this.correo,
      this.telefono, this.sexo, this.fechaNacimiento, this.domicilio, this.colonia, this.estado);

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
