class GrupoJson {
  int idRegistro = 0;
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

    GrupoJson.fromJson(Map<String, dynamic> json){
      idRegistro = int.parse(json['id_registro']);
      curso = json['curso'];
      cct = json['cct'];
      unidad = json['unidad'];
      clave = json['clave'];
      mod = json['mod'];
      inicio = json['inicio'];
      termino = json['termino'];
      area = json['area'];
      espe = json['espe'];
      tcapacitacion = json['tcapacitacion'];
      depen = json['depen'];
      tipoCurso = json['tipoCurso'];
    }
  
}
