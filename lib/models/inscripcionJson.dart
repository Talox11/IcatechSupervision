class InscripcionJson {
  int idRegistro;
  String matricula;
  String alumno;
  String curp;

  InscripcionJson(
      this.idRegistro,
      this.matricula,
      this.alumno,
      this.curp,
      ); 
      
    Map toJson() => {
      'id_registro':idRegistro,
      'matricula':matricula,
      'alumno':alumno,
      'curp':curp,
    };
  
}
