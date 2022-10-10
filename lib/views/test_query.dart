import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:supervision_icatech/enviroment/enviroment.dart';
import 'package:supervision_icatech/repo/repository.dart';
import 'package:supervision_icatech/utils/layouts.dart';

import 'package:supervision_icatech/widgets/my_app_bar.dart';
import 'package:gap/gap.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:http/http.dart' as http;

class TestQuery extends StatefulWidget {
  const TestQuery({Key? key}) : super(key: key);

  @override
  _TestQueryState createState() => _TestQueryState();
}

class _TestQueryState extends State<TestQuery> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    super.initState();
    // _getInfoGrupo();

    // testQuery();
  }

  @override
  Widget build(BuildContext context) {
    final size = Layouts.getSize(context);
    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      appBar: myAppBar(
          title: 'TEST QUERY',
          connStatus: 'conectado',
          connStatusColor: Color.fromARGB(255, 231, 240, 105),
          implyLeading: false,
          context: context,
          hasAction: true),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: <Widget>[
          const Gap(20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: Repository.accentColor2(context),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Repository.accentColor(context))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    testQuery();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    width: size.width * 0.44,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Repository.headerColor(context)),
                    child: const Text('Print table',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    testQuery2();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    width: size.width * 0.44,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.transparent),
                    child: Text('Delete Table ',
                        style: TextStyle(
                            color: Repository.titleColor(context),
                            fontSize: 17,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void testQuery() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'syvic_offline.db');

// open the database

  Database database = await openDatabase(path,
      version: 1, onCreate: (Database db, int version) async {});

  List<Map> list = await database.rawQuery('SELECT * FROM tbl_grupo_temp');
  print(list);
}

void testQuery2() async {
  // print('query test');
  // final response = await http.get(Uri.parse(Environment.apiUrl + '/prueba'));
  // if (response.statusCode == 200) {
  //   String body = utf8.decode(response.bodyBytes);
  //   print(body);
  //   return jsonDecode(body);
  // } else {
  //   throw Exception('Failed to create album.');
  // }
  dropAndCreate();
}

void dropAndCreate() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'syvic_offline.db');
  await deleteDatabase(path);
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
          last_auditoria DATE,
          active INTEGER,
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
          active INTEGER,
          createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )''');

    (await db.query('sqlite_master', columns: ['type', 'name'])).forEach((row) {
      print(row.values);
    });
  });
  printlocaldb();
}

printlocaldb() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'syvic_offline.db');
  // await deleteDatabase(path);

  Database database = await openDatabase(path,
      version: 1, onCreate: (Database db, int version) async {});

  (await database.query('sqlite_master', columns: ['type', 'name']))
      .forEach((row) {
    print(row.values);
  });
  List<Map> grupos_temp =
      await database.rawQuery('SELECT COUNT(*) FROM tbl_grupo_temp');
  List<Map> inscripcion_temp =
      await database.rawQuery('SELECT COUNT(*) FROM tbl_inscripcion_temp');
  List<Map> alumnos_temp =
      await database.rawQuery('SELECT COUNT(*) FROM alumnos_pre_temp ');

  print('============== grupos_temp');
  for (var item in grupos_temp) {
    print(item);
  }
  print('============== inscripcion_temp');
  for (var item in inscripcion_temp) {
    print(item);
  }
  print('============== alumnos_temp');
  for (var item in alumnos_temp) {
    print(item);
  }
}
