import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banking_app/models/alumno.dart';
import 'package:flutter_banking_app/models/grupo.dart';
import 'package:flutter_banking_app/repo/repository.dart';
import 'package:flutter_banking_app/utils/layouts.dart';
import 'package:flutter_banking_app/utils/styles.dart';

import 'package:flutter_banking_app/widgets/buttons.dart';
import 'package:flutter_banking_app/widgets/my_app_bar.dart';
import 'package:flutter_banking_app/widgets/separator.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:postgres/postgres.dart';
//local db
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'info_alumno.dart';

class InfoGrupo extends StatefulWidget {
  final String clave;
  const InfoGrupo({Key? key, required this.clave}) : super(key: key);

  @override
  State<InfoGrupo> createState() => _InfoGrupoState();
}

Future<Grupo> _getInfoGrupo(clave) async {
  List _listAlumnos = [];
  final response = await http.post(
    Uri.parse('http://10.0.2.2:5000/curso/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'clave': clave}),
  );

  if (response.statusCode == 201) {
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    _listAlumnos = await _getAlumnos(jsonData[0]['id']);
    Grupo grupo = Grupo(
        jsonData[0]['id'],
        jsonData[0]['curso'],
        jsonData[0]['cct'],
        jsonData[0]['unidad'],
        jsonData[0]['clave'],
        jsonData[0]['mod'],
        jsonData[0]['inicio'],
        jsonData[0]['termino'],
        jsonData[0]['area'],
        jsonData[0]['espe'],
        jsonData[0]['tcapacitacion'],
        jsonData[0]['depen'],
        jsonData[0]['tipo_curso']);
    grupo.isEditing = 0;
    grupo.isQueue = 0;

    grupo.setAlumnos(_listAlumnos);
    saveTemporaly(grupo);
    return grupo;
  } else {
    throw Exception('Failed to create album.');
  }
}

class _InfoGrupoState extends State<InfoGrupo> {
  // connectivity var

  Future<Grupo>? _futureGrupo;

  @override
  void initState() {
    try {
      bool connectivityExist = false;
      checkInternetConnection().then((onValue) {
        connectivityExist = onValue;
        if (connectivityExist) {
          _futureGrupo = _getInfoGrupo(widget.clave);
        } else {
          _futureGrupo = getInfoGrupoFromLocalDB(widget.clave);
        }
      });
    } catch (e) {
      print(e);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = Layouts.getSize(context);
    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      appBar: myAppBar(
          title: 'Informacion general del grupo',
          implyLeading: true,
          context: context),
      body: FutureBuilder(
          future: _futureGrupo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                padding: const EdgeInsets.all(15),
                children: _showInfo(snapshot.data, size, context, widget.clave),
              );
            } else if (snapshot.hasError) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Ocurrio un error \n'
                      ' Al parecer no cuentas con una conexion a internet!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Styles.icatechPurpleColor.withOpacity(0.7),
                          fontSize: 30)),
                  const Gap(10),
                  Text(
                      'Intenta descargar la base de datos para entrar en modo offline',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Styles.icatechPurpleColor.withOpacity(0.7),
                          fontSize: 18,
                          fontWeight: FontWeight.bold))
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

List<Widget> _showInfo(dataResponse, size, context, clave) {
  List<Widget> widgetInfoGeneral = [];
  Grupo infoGrupo = dataResponse;

  widgetInfoGeneral.add(
    Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Repository.headerColor2(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(infoGrupo.curso,
                          maxLines: 1,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 21,
                              color: Colors.white)))),
            ],
          ),
          const Gap(24),
          customColumn(title: 'grupo', subtitle: infoGrupo.cct),
          const Gap(15)
        ],
      ),
    ),
  );

  widgetInfoGeneral.add(
      separatorText(context: context, text: 'Alumnos inscritos a este grupo'));
  // print(infoGrupo.alumnos);

  List<Alumno> alumnos = infoGrupo.alumnos;
  for (Alumno alumno in alumnos) {
    // print(item);
    widgetInfoGeneral.add(
      InkWell(
        onTap: () {
          Alumno fAlumno;

          getTemporalyAlumnos(alumno.id).then((rAlumno) {
            fAlumno = rAlumno;
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      InfoAlumno(alumno: rAlumno, clave: clave),
                ));
          });
        },
        child: FittedBox(
          child: SizedBox(
            height: size.height * 0.23,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.05,
                  padding: const EdgeInsets.fromLTRB(16, 10, 0, 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(15)),
                    color: Styles.icatechGoldColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                Container(
                  width: size.width * 0.95,
                  padding: const EdgeInsets.fromLTRB(20, 10, 0, 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(15)),
                    color: Styles.icatechPurpleColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 10),
                      ),
                      Text(alumno.nombre,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: Colors.white)),
                      const Gap(20),
                      Text('CURP',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 15)),
                      const Gap(5),
                      Text(alumno.curp,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 19)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

    widgetInfoGeneral.add(const Gap(30));
  }

  widgetInfoGeneral.add(elevatedButton(
    color: Repository.selectedItemColor(context),
    context: context,
    callback: () {
      checkInternetConnection().then((onValue) async {
        if (onValue) {
          uploadGrupo(infoGrupo, context);
        } else {
          showNoInternetConn(context);
          addQueue(infoGrupo);
          print('guardar en cola');
        }
      });
    },
    text: 'Finalizar',
  ));

  return widgetInfoGeneral;
}

showNoInternetConn(BuildContext context) {
  // set up the buttons

  Widget continueButton = TextButton(
    child: const Text('Aceptar'),
    onPressed: () async {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text('Error'),
    content: const Text(
        'No cuentas con una conexion a internet, se reanudará la subida cuando te conectes de nuevo'),
    actions: [
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

Widget customColumn({required String title, required String subtitle}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title.toUpperCase(),
          style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.5))),
      const Gap(2),
      Text(subtitle,
          style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8))),
    ],
  );
}

Future<List> _getAlumnos(clave) async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2:5000/curso/$clave'));

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    // print(jsonData);
    // print(jsonData['rows']);
    return jsonData;
  } else {
    throw Exception('Falló la conexión');
  }
}

checkInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    print('no connection to internet');
    return false;
  }
}

Future<Grupo> getInfoGrupoFromLocalDB(clave) async {
  late List _listAlumnos = [];
  String dbTable = 'tbl_grupo_offline';

  try {
    var databasesPath = await getDatabasesPath();

    String path = join(databasesPath, 'syvic_offline.db');
    Database database = await openDatabase(path,
        version: 1, onCreate: (Database db, int version) async {});

    List dataGrupo =
        await database.query(dbTable, where: 'clave = ?', whereArgs: [clave]);

    _listAlumnos =
        await _getAlumnosFromLocalDB(dataGrupo[0]['id_registro'], database);
        print(_listAlumnos);
    Grupo grupo = Grupo(
        dataGrupo[0]['id_registro'].toString(),
        dataGrupo[0]['curso'],
        dataGrupo[0]['cct'],
        dataGrupo[0]['unidad'],
        dataGrupo[0]['clave'],
        dataGrupo[0]['mod'],
        dataGrupo[0]['inicio'],
        dataGrupo[0]['termino'],
        dataGrupo[0]['area'],
        dataGrupo[0]['espec'],
        dataGrupo[0]['tcapacitacion'],
        dataGrupo[0]['depen'],
        dataGrupo[0]['tipo_curso']);

    grupo.setAlumnos(_listAlumnos);
    return grupo;
  } catch (e) {
    throw e;
  }
}

Future<List> _getAlumnosFromLocalDB(idCurso, database) async {
  String dbTable = 'tbl_inscripcion_offline';
  List dataAlumnos = await database
      .query(dbTable, where: 'id_curso = ?', whereArgs: [idCurso]);

  return dataAlumnos;
}

Future saveTemporaly(grupo) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'syvic_offline.db');

  Database database = await openDatabase(path,
      version: 1, onCreate: (Database db, int version) async {});

  await database.transaction((txn) async {
    ifTempRecordExist(database, 'tbl_grupo_temp', 'id_registro', grupo.id)
        .then((exist) {
      if (!exist) {
        print('new grupo record');
        List<Alumno> alumnos = grupo.alumnos;

        txn.rawInsert(
            'INSERT INTO tbl_grupo_temp(id_registro, curso, cct, unidad, clave, mod, inicio, termino, area, espe, tcapacitacion, depen, tipo_curso,is_editing) '
            'VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
            [
              grupo.id,
              grupo.curso,
              grupo.cct,
              grupo.unidad,
              grupo.clave,
              grupo.mod,
              grupo.inicio,
              grupo.termino,
              grupo.area,
              grupo.espe,
              grupo.tcapacitacion,
              grupo.depen,
              grupo.tipoCurso,
              1, //is editing
            ]);
        for (var a in alumnos) {
          txn.rawInsert(
              'INSERT INTO alumnos_pre_temp(id_registro, id_curso, nombre, apellido_paterno, apellido_materno, correo, telefono, curp, sexo, '
              'fecha_nacimiento, domicilio, colonia, municipio, estado, estado_civil, matricula, seccion_vota, numExt, numInt, resp_satisfaccion, com_satisfaccion) '
              ' VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
              [
                a.id,
                a.idCurso,
                a.nombre,
                a.apellidoPaterno,
                a.apellidoMaterno,
                a.correo,
                a.telefono,
                a.curp,
                a.sexo,
                a.fechaNacimiento,
                a.domicilio,
                '', //colonia
                '', //municipio
                a.estado,
                a.estadoCivil,
                a.matricula,
                '', //seccionVota
                '', //numExt
                '', //numInt
                ',,,,,,,,,,,,', //resp_satisfaccion
                ',,,,,,,,,,,,', //com_satisfaccion
              ]);
        }
      } else {
        print('record exits');
      }
    });
  });
}

Future<bool> ifTempRecordExist(database, dbTable, colum, idRegistro) async {
  List row = await database
      .query(dbTable, where: '$colum = ?', whereArgs: [idRegistro]);
  if (row.isEmpty) {
    return false;
  } else {
    return true;
  }
}

Future<Alumno> getTemporalyAlumnos(idRegistro) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'syvic_offline.db');

  Database database = await openDatabase(path,
      version: 1, onCreate: (Database db, int version) async {});

  List row = await database.query('alumnos_pre_temp',
      where: 'id_registro = ?', whereArgs: [idRegistro]);

  Alumno alumno = Alumno(
      row[0]['id_registro'].toString(),
      row[0]['id_curso'].toString(),
      row[0]['nombre'],
      row[0]['curp'],
      row[0]['matricula'],
      row[0]['apellido_paterno'],
      row[0]['apellido_materno'],
      row[0]['correo'],
      row[0]['telefono'],
      row[0]['sexo'],
      row[0]['fecha_nacimiento'],
      row[0]['domicilio'],
      row[0]['estado'],
      row[0]['estado_civil']);

  alumno.addNewInfo(
      row[0]['estado'],
      row[0]['seccion_vota'],
      row[0]['municipio'],
      row[0]['numExt'],
      row[0]['numInt'],
      row[0]['observaciones'],
      row[0]['resp_satisfaccion'],
      row[0]['com_satisfaccion']);

  return alumno;
}

Future addQueue(grupo) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'syvic_offline.db');

  Database database = await openDatabase(path,
      version: 1, onCreate: (Database db, int version) async {});

  await database.transaction((txn) async {
    var result =
        txn.rawInsert('UPDATE tbl_grupo_temp SET is_editing = 0, is_queue = 1 '
            'WHERE id_registro = ${grupo.id}');
  });
}

showErrorMsg(BuildContext context, msg) {
  // set up the buttons

  Widget continueButton = TextButton(
    child: const Text('Aceptar'),
    onPressed: () async {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text('Error'),
    content: const Text(
        'No cuentas con una conexion a internet, y no existe registros guardados localmente'),
    actions: [
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

Future uploadGrupo(grupo, context) async {
  // inspect(grupo);
  var connection = PostgreSQLConnection('10.0.2.2', 5432, 'server_movil',
      username: 'postgres', password: '8552');
  await connection.open();

  List<List<dynamic>> results =
      await connection.query('Select * from public.prueba');
  var row;
  await connection.transaction((ctx) async {
    row = await ctx.query(
        'INSERT INTO grupo_auditado (curso,cct, unidad, clave, mod, espe, tcapacitacion, depen, tipo_curso ) '
        'VALUES (@curso:text, @cct:text, @unidad:text, @clave:text, @mod:text, @espe:text, @tcapacitacion:text, @depen:text, @tipo_curso:text) RETURNING id as id_inserted ',
        substitutionValues: {
          'curso': grupo.curso,
          'cct': grupo.cct,
          'unidad': grupo.unidad,
          'clave': grupo.clave,
          'mod': grupo.mod,
          'area': grupo.area ?? 'N/A',
          'espe': grupo.espe,
          'tcapacitacion': grupo.tcapacitacion,
          'depen': grupo.depen,
          'tipo_curso': grupo.tipoCurso,
        });
    return row;
    // );
  }).then((insertedId) async {
    await connection.transaction((ctx) async {
      List alumnos = await getAlumnos(grupo.id);

      for (final alumno in alumnos) {
        var result = await ctx.query(
            'INSERT INTO alumno_auditado (id_curso, nombre, curp, matricula, apellido_paterno, apellido_materno, correo, telefono, sexo, fecha_nacimiento, domicilio, estado, estado_civil, entidad_nacimiento, seccion_vota, calle, num_ext, num_int, observaciones, resp_satisfaccion, com_satisfaccion) '
            'VALUES (@id_curso:text, @nombre:text, @curp:text, @matricula:text, @apellido_paterno:text, @apellido_materno:text, @correo:text, @telefono:text, @sexo:text, @fecha_nacimiento:text, @domicilio:text, @estado:text, @estado_civil:text, @entidad_nacimiento:text, @seccion_vota:text, @calle:text, @num_ext:text, @num_int:text, @observaciones:text, @resp_satisfaccion:text, @com_satisfaccion:text) RETURNING id as id_inserted',
            substitutionValues: {
              'id_curso': insertedId.last[0].toString(),
              'nombre': alumno['nombre'],
              'curp': alumno['curp'],
              'matricula': alumno['matricula'],
              'apellido_paterno': alumno['apellido_paterno'],
              'apellido_materno': alumno['apellido_materno'],
              'correo': alumno['correo'],
              'telefono': alumno['telefono'],
              'sexo': alumno['sexo'],
              'fecha_nacimiento': alumno['fecha_nacimiento'],
              'domicilio': alumno['domicilio'],
              'estado': alumno['estado'],
              'estado_civil': alumno['estado_civil'],
              'entidad_nacimiento': alumno['entidad_nacimiento'], 
              'seccion_vota': alumno['seccion_vota'],
              'calle': alumno['calle'], //calle
              'num_ext': alumno['numExt'],
              'num_int': alumno['numInt'],
              'observaciones': alumno['observaciones'],  //observaciones
              'resp_satisfaccion': alumno['resp_satisfaccion'],
              'com_satisfaccion': alumno['com_satisfaccion'],
            });
      }
    });
    await removeGrupoQueue(grupo);
  });

  connection.close();
  Navigator.pop(context);
}

Future removeGrupoQueue(grupo) async {
  var idRegistro = grupo['id_registro'];
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'syvic_offline.db');

  Database database = await openDatabase(path,
      version: 1, onCreate: (Database db, int version) async {});

  await database.transaction((txn) async {
    var result = txn.rawDelete(
        'DELETE FROM tbl_grupo_temp WHERE id_registro = ${idRegistro}');
  });

  database.close();
}


getAlumnos(id_curso) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'syvic_offline.db');
  // await deleteDatabase(path);

  Database database = await openDatabase(path,
      version: 1, onCreate: (Database db, int version) async {});
  List alumnos_temp = await database
      .rawQuery('SELECT * FROM alumnos_pre_temp where id_curso = $id_curso');

  return alumnos_temp;
}
