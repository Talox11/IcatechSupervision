import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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

import '../enviroment/enviroment.dart';
import '../widgets/bottom_nav.dart';
import 'home.dart';
import 'info_alumno.dart';

class InfoGrupo extends StatefulWidget {
  final String clave;
  const InfoGrupo({Key? key, required this.clave}) : super(key: key);

  @override
  State<InfoGrupo> createState() => _InfoGrupoState();
}

class _InfoGrupoState extends State<InfoGrupo> {
  // connectivity var

  Future<Grupo>? _futureGrupo;
  Future<Grupo> _getInfoGrupo(clave) async {
    List _listAlumnos = [];

    final response = await http.post(
      Uri.parse(Environment.apiUrl + '/curso'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'clave': clave}),
    );

    if (response.statusCode == 201) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      _listAlumnos = await _getAlumnos(jsonData[0]['id']);
      print('Alumnos info=>' + _listAlumnos[0].toString());

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

      grupo.addAlumos(_listAlumnos);
      saveTemporaly(grupo);

      return grupo;
    } else {
      // statusCode = response.statusCode.toString();
      throw Exception(
          'Failed to create album.: ' + response.statusCode.toString());
    }
  }

  @override
  void initState() {
    try {
      tempRecordExist('tbl_grupo_temp', 'clave', widget.clave)
          .then((exist) async {
        if (exist) {
          print('registro almacenado localmente');
          //si existe localmente obtiene datos
          _futureGrupo = getGrupoFromLocalDB(widget.clave);
        } else {
          // si no existe, hace peticion al servidor
          print('registro nuevo');
          checkInternetConn().then((connectivityExist) {
            if (connectivityExist) {
              _futureGrupo = _getInfoGrupo(widget.clave);
            } else {
              _futureGrupo = null;
            }
          });
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
            print(snapshot.connectionState);
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Ocurrio un error \n'
                        ' Revisa tu conexion a internet!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Styles.icatechPurpleColor.withOpacity(0.7),
                            fontSize: 30)),
                    const Gap(10),
                  ],
                );
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );

              default:
                if (snapshot.hasError) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Ocurrio un error con el servidor \n'
                                  ' Intenta de nuevo mas tarde' +
                              Environment.fileName +
                              '',
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
                              fontWeight: FontWeight.bold)),
                      const Gap(30),
                      Text(
                          'file' +
                              Environment.fileName +
                              '   api=> ' +
                              Environment.apiUrl,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Styles.icatechPurpleColor.withOpacity(0.7),
                              fontSize: 18,
                              fontWeight: FontWeight.bold))
                    ],
                  );
                } else {
                  return ListView(
                    padding: const EdgeInsets.all(15),
                    children:
                        _showInfo(snapshot.data, size, context, widget.clave),
                  );
                }
            }
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
  inspect(alumnos);
  for (Alumno alumno in alumnos) {
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
      checkInternetConn().then((connectivityExist) async {
        if (connectivityExist) {
          uploadGrupo(infoGrupo, context);
          showUploadDone(context);
        } else {
          showNoInternetConn(context);
          addQueue(infoGrupo, context);
          print('guardar en cola');
        }
      });
    },
    text: 'Finalizar',
  ));

  return widgetInfoGeneral;
}

Future<List> _getAlumnos(clave) async {
  final response =
      await http.get(Uri.parse(Environment.apiUrl + '/curso/$clave'));

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    return jsonData;
  } else {
    throw Exception('Falló la conexión');
  }
}

Future<bool> tempRecordExist(dbTable, colum, idRegistro) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'syvic_offline.db');

  Database database = await openDatabase(path,
      version: 1, onCreate: (Database db, int version) async {});
  List row = await database
      .query(dbTable, where: '$colum = ?', whereArgs: [idRegistro]);
  if (row.isEmpty) {
    database.close();
    return false;
  } else {
    database.close();
    return true;
  }
}

Future saveTemporaly(grupo) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'syvic_offline.db');

  Database database = await openDatabase(path,
      version: 1, onCreate: (Database db, int version) async {});

  await database.transaction((txn) async {
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
          'fecha_nacimiento, domicilio, colonia, municipio, estado, estado_civil, matricula, observaciones, calle, seccion_vota, numExt, numInt, resp_satisfaccion, com_satisfaccion) '
          ' VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
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
            a.colonia,
            a.municipio,
            a.estado,
            a.estadoCivil,
            a.matricula,
            '', //observaciones
            '', //calle
            '', //seccionVota
            '', //numExt
            '', //numInt
            ',,,,,,,,,,,,', //resp_satisfaccion
            ',,,,,,,,,,,,', //com_satisfaccion
          ]);
    }
  });
}

Future<Grupo> getGrupoFromLocalDB(clave) async {
  print('getting from local');
  late List _listAlumnos = [];
  String dbTable = 'tbl_grupo_temp';

  try {
    var databasesPath = await getDatabasesPath();

    String path = join(databasesPath, 'syvic_offline.db');
    Database database = await openDatabase(path,
        version: 1, onCreate: (Database db, int version) async {});

    List dataGrupo =
        await database.query(dbTable, where: 'clave = ?', whereArgs: [clave]);

    List _listAlumnos =
        await _getAlumnosFromLocalDB(dataGrupo[0]['id_registro'], database);

    // inspect(_listAlumnos[0]);
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
      dataGrupo[0]['espe'],
      dataGrupo[0]['tcapacitacion'],
      dataGrupo[0]['depen'],
      dataGrupo[0]['tipo_curso'],
    );
    // grupo.isEditing = int.parse(dataGrupo[0]['is_editing']);
    // grupo.isQueue = int.parse(dataGrupo[0]['is_queue']);

    await grupo.addAlumos2(_listAlumnos);
    inspect(grupo);
    return grupo;
  } catch (e) {
    rethrow;
  }
}

Future<List> _getAlumnosFromLocalDB(idCurso, database) async {
  String dbTable = 'alumnos_pre_temp ';
  List dataAlumnos = await database
      .query(dbTable, where: 'id_curso = ?', whereArgs: [idCurso]);

  return dataAlumnos;
}

Future<Alumno> getTemporalyAlumnos(idRegistro) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'syvic_offline.db');

  Database database = await openDatabase(path,
      version: 1, onCreate: (Database db, int version) async {});

  List row = await database.query('alumnos_pre_temp',
      where: 'id_registro = ?', whereArgs: [idRegistro]);
  // print(idRegistro+'  497row__'+row.toString());
  Alumno alumno = Alumno(
    row[0]['id_registro'].toString(),
    row[0]['id_curso'].toString(),
    row[0]['nombre'],
    row[0]['apellido_paterno'],
    row[0]['apellido_materno'],
    row[0]['correo'],
    row[0]['telefono'],
    row[0]['curp'],
    row[0]['sexo'],
    row[0]['fecha_nacimiento'],
    row[0]['domicilio'],
    row[0]['colonia'],
    row[0]['municipio'],
    row[0]['estado'],
    row[0]['estado_civil'],
    row[0]['matricula'],
  );

  alumno.addNewInfo(
      row[0]['estado'],
      row[0]['observaciones'],
      row[0]['calle'],
      row[0]['seccion_vota'],
      row[0]['numExt'],
      row[0]['numInt'],
      row[0]['resp_satisfaccion'],
      row[0]['com_satisfaccion']);

  database.close();
  return alumno;
}

Future uploadGrupo(grupo, context) async {
  String grupoAux = jsonEncode(grupo);
  String listAlumn = await getAlumnos(grupo['id_registro']);

  final response = await http.post(
    Uri.parse(Environment.apiUrl + '/grupo/insert'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'grupo': grupoAux, 'alumnos': listAlumn}),
  );

  if (response.statusCode == 201) {
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    print(jsonData);
    await removeGrupoQueue(grupo);
    Navigator.pop(context);
  } else {
    throw Exception('Failed to upload.');
  }
}

Future addQueue(grupo, context) async {
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

showUploadDone(BuildContext context) {
  // set up the buttons

  Widget continueButton = TextButton(
    child: const Text('Aceptar'),
    onPressed: () async {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNav(),
          ));
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text('Exito'),
    content: const Text('Se guardo el registro'),
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

showNoInternetConn(BuildContext context) {
  // set up the buttons

  Widget continueButton = TextButton(
    child: const Text('Aceptar'),
    onPressed: () async {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNav(),
          ));
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



checkInternetConn() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    print(result);
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      return true;
    }
  } on SocketException catch (_) {
    print('not connected');
    return false;
  }
}
