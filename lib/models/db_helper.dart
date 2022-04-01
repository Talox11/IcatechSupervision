import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<List> dowloadDB(grupos, alumnosIns, alumnosPre) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'syvic_offline.db');
  await deleteDatabase(path);

  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS tbl_grupo_offline (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          id_registro INTEGER,
          curso TEXT,
          cct TEXT,
          unidad TEXT,
          clave TEXT,
          mod TEXT,
          inicio DATE,
          termino DATE,
          area TEXT,
          espe TEXT,
          tcapacitacion TEXT,
          depen TEXT,
          tipo_curso TEXT,
          createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )''');

    await db.execute('''CREATE TABLE IF NOT EXISTS tbl_inscripcion_offline(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          id_registro INTEGER,
          matricula TEXT,
          nombre TEXT,
          curp TEXT,
          id_curso TEXT,
          createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )''');

    await db.execute('''CREATE TABLE IF NOT EXISTS alumnos_pre_offline(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          id_registro INTEGER,
          nombre TEXT,
          apellido_paterno TEXT,
          apellido_materno TEXT,
          correo TEXT,
          telefono TEXT,
          curp TEXT,
          sexo TEXT,
          fecha_nacimiento TEXT,
          domicilio TEXT,
          colonia TEXT,
          municipio TEXT,
          estado TEXT,
          estado_civil TEXT,
          matricula TEXT,
          createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )''');

    await db.execute('''CREATE TABLE IF NOT EXISTS tbl_grupo_temp(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          id_registro INTEGER,
          curso TEXT,
          cct TEXT,
          unidad TEXT,
          clave TEXT,
          mod TEXT,
          inicio DATE,
          termino DATE,
          area TEXT,
          espe TEXT,
          tcapacitacion TEXT,
          depen TEXT,
          tipo_curso TEXT,
          createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )''');

    await db.execute('''CREATE TABLE IF NOT EXISTS tbl_inscripcion_temp(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          id_registro INTEGER,
          matricula TEXT,
          nombre TEXT,
          curp TEXT,
          id_curso TEXT,
          createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )''');

    await db.execute('''CREATE TABLE IF NOT EXISTS alumnos_pre_temp(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          id_registro INTEGER,
          id_curso INTEGER,
          nombre TEXT,
          apellido_paterno TEXT,
          apellido_materno TEXT,
          correo TEXT,
          telefono TEXT,
          curp TEXT,
          sexo TEXT,
          fecha_nacimiento TEXT,
          domicilio TEXT,
          colonia TEXT,
          municipio TEXT,
          estado TEXT,
          estado_civil TEXT,
          matricula TEXT,
          entidad_nacimiento TEXT,
          observaciones TEXT,
          calle TEXT,
          seccion_vota TEXT,
          numExt TEXT,
          numInt TEXT,
          resp_satisfaccion TEXT,
          com_satisfaccion TEXT,
          createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )''');
  });

  await database.transaction((txn) async {
    for (var item in grupos) {
      await txn.rawInsert(
          'INSERT INTO tbl_grupo_offline(id_registro, curso, cct, unidad, clave, mod, inicio, termino, area, espe, tcapacitacion, depen, tipo_curso) '
          'VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)',
          [
            item['id'],
            item['curso'],
            item['cct'],
            item['unidad'],
            item['clave'],
            item['mod'],
            item['inicio'],
            item['termino'],
            item['area'],
            item['espe'],
            item['tcapacitacion'],
            item['depen'],
            item['tipo_curso']
          ]);
    }
    print('inserted grupos  rows: ${grupos.length}');

    for (var item in alumnosIns) {
      await txn.rawInsert(
          'INSERT INTO tbl_inscripcion_offline(id_registro, matricula, nombre, curp, id_curso ) '
          'VALUES(?, ?, ?, ?, ?)',
          [
            item['id'],
            item['matricula'],
            item['alumno'],
            item['curp'],
            item['id_curso']
          ]);
    }
    print('inserted alumnos rows: ${alumnosIns.length}');

    for (var item in alumnosPre) {
      await txn.rawInsert(
          'INSERT INTO alumnos_pre_offline(id_registro, nombre, apellido_paterno, apellido_materno, correo, telefono, curp, sexo, fecha_nacimiento, domicilio, colonia, municipio, estado, estado_civil, matricula) '
          'VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
          [
            item['id'],
            item['nombre'],
            item['apellido_paterno'],
            item['apellido_materno'],
            item['correo'],
            item['telefono'],
            item['curp'],
            item['sexo'],
            item['fecha_nacimiento'],
            item['domicilio'],
            item['colonia'],
            item['municipio'],
            item['estado'],
            item['estado_civil'],
            item['matricula']
          ]);
    }
    print('inserted alumnos pre rows: ${alumnosPre.length}');
  });

  return [
    {'done'}
  ];
}


Future helperCreateTables() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'syvic_offline.db');

  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {

    await db.execute('''CREATE TABLE IF NOT EXISTS tbl_grupo_temp(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          id_registro INTEGER,
          curso TEXT,
          cct TEXT,
          unidad TEXT,
          clave TEXT,
          mod TEXT,
          inicio DATE,
          termino DATE,
          area TEXT,
          espe TEXT,
          tcapacitacion TEXT,
          depen TEXT,
          tipo_curso TEXT,
          is_editing INTEGER,
          is_queue INTEGER
          createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )''');

    await db.execute('''CREATE TABLE IF NOT EXISTS tbl_inscripcion_temp(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          id_registro INTEGER,
          matricula TEXT,
          nombre TEXT,
          curp TEXT,
          id_curso TEXT,
          createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )''');

    await db.execute('''CREATE TABLE IF NOT EXISTS alumnos_pre_temp(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          id_registro INTEGER,
          id_curso INTEGER,
          nombre TEXT,
          apellido_paterno TEXT,
          apellido_materno TEXT,
          correo TEXT,
          telefono TEXT,
          curp TEXT,
          sexo TEXT,
          fecha_nacimiento TEXT,
          domicilio TEXT,
          colonia TEXT,
          municipio TEXT,
          estado TEXT,
          estado_civil TEXT,
          matricula TEXT,
          entidad_nacimiento TEXT,
          observaciones TEXT,
          calle TEXT,
          seccion_vota TEXT,
          numExt TEXT,
          numInt TEXT,
          resp_satisfaccion TEXT,
          com_satisfaccion TEXT,
          createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )''');

    await db.execute('''CREATE TABLE IF NOT EXISTS tbl_queue_grupos(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          id_grupo INTEGER
        )''');
    (await db.query('sqlite_master', columns: ['type', 'name'])).forEach((row) {
      print(row.values);
    });
  });
}
