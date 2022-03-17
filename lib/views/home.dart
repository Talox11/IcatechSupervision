import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_banking_app/json/transactions.dart';
import 'package:flutter_banking_app/repo/repository.dart';
import 'package:flutter_banking_app/utils/iconly/iconly_bold.dart';
import 'package:flutter_banking_app/utils/layouts.dart';
import 'package:flutter_banking_app/utils/size_config.dart';
import 'package:flutter_banking_app/utils/styles.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // join()

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final size = Layouts.getSize(context);
    return Material(
      color: Repository.bgColor(context),
      elevation: 0,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: size.height * .25,
            color: Repository.headerColor(context),
          ), //header
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            children: [
              Gap(getProportionateScreenHeight(100)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hola verificador',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16)),
                      const Gap(3),
                      const Text('Bienvenido de vuelta',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        IconlyBold.Notification,
                        color: Styles.accentColor,
                      ),
                    ),
                  )
                ],
              ),
              const Gap(25),
              const Gap(15),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Repository.accentColor(context),
                ),
                child: Row(
                    //iconos tab
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          // call this method
                          showDownloadDBDialog(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF026EF4).withOpacity(0.15),
                          ),
                          child: const Icon(IconlyBold.Download,
                              color: Color(0xFF026EF4)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // call this method
                          showSyncDialog(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFB6A4B).withOpacity(0.15),
                          ),
                          child: const Icon(IconlyBold.Upload,
                              color: Color(0xFFFB6A4B)),
                        ),
                      )
                    ]),
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pendientes por subir',
                      style: TextStyle(
                          color: Repository.textColor(context),
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (c, i) {
                    final trs = transactions[i];
                    return ListTile(
                      isThreeLine: true,
                      minLeadingWidth: 10,
                      minVerticalPadding: 20,
                      contentPadding: const EdgeInsets.all(0),
                      leading: Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Repository.accentColor(context),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                color: Colors.white.withOpacity(0.1),
                                blurRadius: 2,
                                spreadRadius: 1,
                              )
                            ],
                            image: i == 0
                                ? null
                                : DecorationImage(
                                    image: AssetImage(trs['avatar']),
                                    fit: BoxFit.cover,
                                  ),
                            shape: BoxShape.circle,
                          ),
                          child: i == 0
                              ? Icon(trs['icon'],
                                  color: const Color(0xFFFF736C), size: 20)
                              : const SizedBox()),
                      title: Text(trs['name'],
                          style: TextStyle(
                              color: Repository.textColor(context),
                              fontWeight: FontWeight.w500)),
                      subtitle: Text(trs['date'],
                          style: TextStyle(
                              color: Repository.subTextColor(context))),
                      trailing: Text(trs['amount'],
                          style: const TextStyle(
                              fontSize: 17, color: Colors.white)),
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

showDownloadDBDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text('Cancelar'),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: const Text('Continuar'),
    onPressed: () {
      downloadDB();
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text('Atencion'),
    content: const Text(
        'Descargar la base de datos te permitirá usar la aplicación sin conexión a internet,'
        ' pero consumirá parte de tu almacenamiento interno, ¿deseas continuar?'),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showSyncDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text('Cancelar'),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: const Text('Continuar'),
    onPressed: () {
      print('descargar');
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text('Atencion'),
    content: const Text(
        'Se sincronizarán tus registros con el servidor, se recomienda usar una conexión Wi-Fi ¿deseas continuar?'),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<List> downloadDB() async {
  late List _listGrupos = [];
  late List _listAlumnosInscritos = [];
  late List _listAlumnosPre = [];
  // saveDB(jsonData);
  _listGrupos = await _getGrupos();
  _listAlumnosInscritos = await _getAlumnosInscritos();
  _listAlumnosPre = await _getAlumnosPre();

  saveDB(_listGrupos, _listAlumnosInscritos, _listAlumnosPre);
  return [
    {'done'}
  ];
}

Future<List> _getGrupos() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:5000/list/grupo'));

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    return jsonDecode(body);
  } else {
    throw Exception('Failed to create album.');
  }
}

Future<List> _getAlumnosInscritos() async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2:5000/list/alumnosInscritos'));

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    return jsonDecode(body);
  } else {
    throw Exception('Falló la conexión');
  }
}

Future<List> _getAlumnosPre() async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2:5000/list/alumnosPre'));

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    return jsonDecode(body);
  } else {
    throw Exception('Falló la conexión');
  }
}

void saveDB(grupos, alumnosIns, alumnosPre) async {
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
          alumno TEXT,
          curp TEXT,
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
          domiclio TEXT,
          colonia TEXT,
          municipio TEXT,
          estado TEXT,
          estado_civil TEXT,
          matricula TEXT,
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
    print('inserted grupos');

    for (var item in alumnosIns) {
      await txn.rawInsert(
          'INSERT INTO tbl_inscripcion_offline(id_registro, matricula, alumno, curp ) '
          'VALUES(?, ?, ?, ?)',
          [item['id'], item['matricula'], item['alumno'], item['curp']]);
    }
    print('inserted alunnos ins');

    for (var item in alumnosPre) {
      await txn.rawInsert(
          'INSERT INTO alumnos_pre_offline(id_registro, nombre, apellido_paterno, apellido_materno, correo, telefono, curp, sexo, fecha_nacimiento, domiclio, colonia, municipio, estado, estado_civil, matricula) '
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
    print('inserted alumnos pre');
  });
}
