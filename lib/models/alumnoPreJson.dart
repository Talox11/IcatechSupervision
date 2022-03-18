// ignore_for_file: file_names

class AlumnoPreJson {
  int idRegistro;
  String nombre;
  String curp;
  String matricula;
  String apellidoPaterno;
  String apellidoMaterno;
  String correo;
  String telefono;
  String sexo;
  String fechaNacimiento;
  String domicilio;
  String calle;
  String numExt;
  String numInt;
  String estado;
  String entidadNacimiento;
  String seccionVota;

  AlumnoPreJson(
    this.idRegistro,
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
    this.calle,
    this.numExt,
    this.numInt,
    this.estado,
    this.entidadNacimiento,
    this.seccionVota,
  );

  Map toJson() => {
        'id_registro': idRegistro,
        'nombre': nombre,
        'curp': curp,
        'matricula': matricula,
        'apellido_paterno': apellidoPaterno,
        'apellido_materno': apellidoMaterno,
        'correo': correo,
        'telefono': telefono,
        'sexo': sexo,
        'fecha_nacimiento': fechaNacimiento,
        'domicilio': domicilio,
        'calle': calle,
        'numExt': numExt,
        'numInt': numInt,
        'estado': estado,
        'entidad_nacimiento': entidadNacimiento,
        'seccion_vota': seccionVota,
      };
}
