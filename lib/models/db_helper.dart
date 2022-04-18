import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
