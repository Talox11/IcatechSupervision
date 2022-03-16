class GrupoJson {
  int idRegistro;
  String curso;
  String cct;
  String unidad;
  String clave;
  String mod;
  String inicio;
  String termino;
  String area;
  String espe;
  String tcapacitacion;
  String depen;
  String tipoCurso;

  GrupoJson(
      this.idRegistro,
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
      
    Map toJson() => {
      'id_registro':idRegistro,
      'curso':curso,
      'cct':cct,
      'unidad':unidad,
      'clave':clave,
      'mod':mod,
      'inicio':inicio,
      'termino':termino,
      'area':area,
      'espe':espe,
      'tcapacitacion':tcapacitacion,
      'depen':depen,
      'tipoCurso':tipoCurso,
    };
  
}
