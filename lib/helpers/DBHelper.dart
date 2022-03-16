import 'package:flutter/foundation.dart';
import 'package:flutter_banking_app/models/grupoJson.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute('''CREATE TABLE IF NOT EXISTS tbl_grupo_offline(
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
      )

      CREATE TABLE IF NOT EXISTS tbl_inscripcion_offline(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        id_registro INTEGER,
        matricula TEXT,
        alumno TEXT,
        curp TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )

      CREATE TABLE IF NOT EXISTS alumnos_pre_offline(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        id_registro INTEGER,
        nombre TEXT,
        curp TEXT,
        matricula TEXT,
        apellido_paterno TEXT,
        apellido_materno TEXT,
        correo TEXT,
        telefono TEXT,
        sexo TEXT,
        fecha_nacimiento TEXT,
        domiclio TEXT,
        calle TEXT,
        numExt INT,
        numInt INT
        estado TEXT,
        entidad_nacimiento TEXT,
        seccion_vota INT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP

        
      )
      ''');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'syvic_offline.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> insertGrupo(GrupoJson grupoJson) async {
    final db = await SQLHelper.db();

    final data = grupoJson.toJson() as Map<String, dynamic>;
    final resultQuery = await db.insert('tbl_grupo_offline', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return resultQuery;
  }

  
}
