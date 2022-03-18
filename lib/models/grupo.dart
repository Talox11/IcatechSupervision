class Grupo {
  String id = '';
  String curso = '';
  String cct = '';
  String unidad = '';
  String clave = '';
  String inicio = '';
  String termino = '';
  List alumnos = [];
  Grupo(this.id, this.curso, this.cct, this.unidad, this.clave, this.inicio,
      this.termino);

  setAlumnos(alumnos) {
    this.alumnos = alumnos;
  }

  // Map toJson() => {
  //     'id_registro':id,
  //     'curso':curso,
  //     'cct':cct,
  //     'unidad':unidad,
  //     'clave':clave,
  //     'mod':mod,
  //     'inicio':inicio,
  //     'termino':termino,
  //     'area':area,
  //     'espe':espe,
  //     'tcapacitacion':tcapacitacion,
  //     'depen':depen,
  //     'tipoCurso':tipoCurso,
  //   };
}
