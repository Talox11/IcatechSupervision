import 'dart:convert';

List<Alumno> allAlumnos(String str) {
  final jsonData = json.decode(str);
  return List<Alumno>.from(jsonData.map((x) => Alumno.fromJson(x)));
}

class Alumno {
  bool status;
  String message;
  List<Data> data;

  Alumno({
    required this.status,
    required this.message,
    required this.data,
  });

  factory Alumno.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<Data> dataList = list.map((i) => Data.fromJson(i)).toList();

    return Alumno(
      status: parsedJson['status'],
      message: parsedJson['message'],
      data: dataList,
    );
  }
}

class Data {
  final int id;
  final String nombre;
  final String apellido_paterno;
  final String apellido_materno;
  final String correo;
  final String telefono;
  final String curp;
  final String sexo;
  final String fecha_nacimiento;
  final String domicilio;
  final String colonia;
  final String estado;

  Data({
    required this.id,
    required this.nombre,
    required this.apellido_paterno,
    required this.apellido_materno,
    required this.correo,
    required this.telefono,
    required this.curp,
    required this.sexo,
    required this.fecha_nacimiento,
    required this.domicilio,
    required this.colonia,
    required this.estado,


  });

  factory Data.fromJson(Map<String, dynamic> parsedJson) {
    return Data(
      id: parsedJson['id'],
      nombre: parsedJson['nombre'],
      apellido_paterno: parsedJson['apellido_paterno'],
      apellido_materno: parsedJson['apellido_materno'],
      correo: parsedJson['correo'],
      telefono: parsedJson['telefono'],
      curp: parsedJson['curp'],
      sexo: parsedJson['sexo'],
      fecha_nacimiento: parsedJson['fecha_nacimiento'],
      domicilio: parsedJson['domicilio'],
      colonia: parsedJson['colonia'],
      estado: parsedJson['estado'],
    );
  }
}
