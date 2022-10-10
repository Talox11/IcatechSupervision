import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supervision_icatech/alerts/loader.dart';
import 'package:supervision_icatech/http/http_handle.dart';
import 'package:supervision_icatech/models/alumno.dart';
import 'package:supervision_icatech/models/db_helper.dart';
import 'package:supervision_icatech/models/grupo.dart';

import 'package:supervision_icatech/repo/repository.dart';
import 'package:supervision_icatech/utils/iconly/iconly_bold.dart';
import 'package:supervision_icatech/utils/layouts.dart';
import 'package:supervision_icatech/utils/size_config.dart';
import 'package:supervision_icatech/utils/styles.dart';
import 'package:supervision_icatech/views/login.dart';

import 'package:supervision_icatech/widgets/loadingIndicator.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:postgres/postgres.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../enviroment/Enviroment.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SharedPreferences sharedPreferences;
  String email_sivic = '';
  int id_sivic = 0;
  Future<List>? _futureGrupo;
  bool visible = true;

  @override
  void initState() {
    createTables();
    checkSesion();
    // getCursosPorSupervisar();
    _futureGrupo = getQueueUpload();

    super.initState();
  }

  loadProgress() {
    if (visible == true) {
      setState(() {
        visible = false;
      });
    } else {
      setState(() {
        visible = true;
      });
    }
  }

  Future<List> getQueueUpload() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'syvic_offline.db');

    Database database = await openDatabase(path,
        version: 1, onCreate: (Database db, int version) async {});

    List row = await database
        .rawQuery('SELECT * FROM tbl_grupo_temp where is_queue = 1');
    // for (var item in row){
    //   print(item);
    // }
    return Future.value(row);
  }

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
            color: Styles.icatechPurpleColor,
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
                        Text('Hola '+ sharedPreferences.getString('name')!,
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
                  ],
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  //onTap: _controller.hideMenu,
                  onTap: () {
                    Loader().showCargando(context);
                    HttpHandle()
                        .updateToken(id_sivic.toString())
                        .then((valueRes) {
                      Navigator.of(context).pop();
                      if (valueRes == 'success') {
                        sharedPreferences.clear();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) => LoginPage()),
                            (route) => false);
                      }
                    });
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.logout,
                          size: 15,
                          color: Colors.white,
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: const Text(
                              'Cerrar sesión',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          onTap: () async {
                            //update
                            checkInternetConn().then((connected) async {
                              if (connected) {
                                await showSyncDialog(context, this);
                                setState(() {
                                  _futureGrupo = getQueueUpload();
                                });
                              } else {
                                showNoInternetConn(context);
                              }
                            });
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
                FutureBuilder(
                    future: _futureGrupo,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        default:
                          if (snapshot.hasError) {
                            return Column(
                              children: const [
                                // Icon(Icons.error),
                                Text('No existen registros.'),
                              ],
                            );
                          } else {
                            return Column(
                                children: createListView(
                                    context, snapshot.data, size, this));
                          }
                      }
                    })
              ]),
        ],
      ),
    );
  }

  List<Widget> createListView(context, dataResponse, size, state) {
    List<Widget> widgetView = [];

    for (var grupo in dataResponse) {
      widgetView.add(const Gap(15));
      widgetView.add(InkWell(
        onTap: () async {
          await checkInternetConn().then((onValue) async {
            if (onValue) {
              DialogBuilder(context).showLoadingIndicator();
              await uploadGrupo(grupo);
              await state.setState(() {
                _futureGrupo = getQueueUpload();
              });
              DialogBuilder(context).hideOpenDialog();
            } else {
              showNoInternetConn(context);
            }
          });
        },
        child: FittedBox(
          child: SizedBox(
            height: size.height * 0.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width,
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
                                  child: Text(grupo['curso'],
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 21,
                                          color: Colors.white)))),
                        ],
                      ),
                      const Gap(24),
                      customColumn(title: 'grupo', subtitle: grupo['cct']),
                      const Gap(15)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }

    return widgetView;
  }

  void checkSesion() async {
    sharedPreferences = await SharedPreferences.getInstance();

    id_sivic = sharedPreferences.getInt('id_sivyc')!;
    email_sivic = sharedPreferences.getString('correo')!;
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
      content: const Text('No cuentas con una conexion a internet'),
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
}

showSyncDialog(BuildContext context, state) {
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
      uploadAllGrupos(state);

      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text('Atencion'),
    content: const Text(
        'Se sincronizarán tus registros con el servidor, esto puede tomar varios minutos y se recomienda usar una conexión Wi-Fi ¿deseas continuar?'),
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

uploadAllGrupos(state) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'syvic_offline.db');

  Database database = await openDatabase(path,
      version: 1, onCreate: (Database db, int version) async {});

  List gruposList = await database
      .rawQuery('SELECT * FROM tbl_grupo_temp where is_queue = 1');

  for (var grupo in gruposList) {
    await uploadGrupo(grupo);
  }
}

Future createTables() async {
  helperCreateTables();
}

Future getCursosPorSupervisar() async {
  List _listAlumnos = [];

  final response = await http.post(
      Uri.parse(
          Environment.apiUrlLaravel + '/supervision/movil/cursos-supervisar'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'idUsuario': '444',
      }));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    for (var item in jsonData) {
      tempRecordExist('tbl_grupo_temp', 'clave', item['clave'])
          .then((exist) async {
        if (!exist) {
          _listAlumnos = await _getAlumnos(item['id']);
          inspect(_listAlumnos);
          Grupo grupo = Grupo(
              item['id'].toString(),
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
              item['tipo_curso']);
          grupo.isEditing = 0;
          grupo.isQueue = 0;

          grupo.addAlumos(_listAlumnos);
          saveTemporaly(grupo);
        } else {
          print('Ya existe localmente ' +
              item['clave'] +
              ' -> ' +
              item['id'].toString());
        }
      });
    }
  }
}

Future<List> _getAlumnos(clave) async {
  final response = await http.get(Uri.parse(
      Environment.apiUrlLaravel + '/supervision/movil/alumnos/$clave'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Falló la conexión');
  }
}

Future saveTemporaly(grupo) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'syvic_offline.db');

  Database database = await openDatabase(path,
      version: 1, onCreate: (Database db, int version) async {});

  await database.transaction((txn) async {
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

Future<bool> tempRecordExist(dbTable, colum, idRegistro) async {
  print(dbTable + ' | ' + colum + ' | ' + idRegistro);
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'syvic_offline.db');

  Database database = await openDatabase(path,
      version: 1, onCreate: (Database db, int version) async {});
  List row = await database
      .query(dbTable, where: '$colum = ?', whereArgs: [idRegistro]);
  if (row.isEmpty) {
    // database.close();
    return false;
  } else {
    // database.close();
    return true;
  }
}

Future<bool> checkInternetConn() async {
  try {
    final result = await InternetAddress.lookup('google.com.mx');
    print(result);
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      return true;
    } else {
      return false;
    }
  } on SocketException catch (_) {
    print('not connected');
    return false;
  }
}

//   checkInternetConn() async {
//   try {
//     final result = await InternetAddress.lookup('https://icatech-mobile.herokuapp.com/');
//     print(result);
//     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//       print('connected');
//       return true;
//     }
//   } on SocketException catch (_) {
//     print('not connected');
//     return false;
//   }
// }

Future<bool> verifyIfTableExist(db, tableName) async {
  List row = await db
      .query('sqlite_master', where: 'name = ?', whereArgs: [tableName]);

  if (row.isEmpty) {
    return false;
  } else {
    return true;
  }
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

Future uploadGrupo(grupo) async {
  String grupoAux = jsonEncode(grupo);
  String listAlumn = await getAlumnos(grupo['id_registro']);
  var test =
      jsonEncode(<String, String>{'grupo': grupoAux, 'alumnos': listAlumn});

  final response = await http.post(
    Uri.parse(Environment.apiUrlNode + '/grupo/insert'),
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
  } else {
    throw Exception('Failed to upload.');
  }
}

Future removeGrupoQueue(grupo) async {
  inspect(grupo);
  var idRegistro = grupo['id_registro'];
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'syvic_offline.db');

  Database database = await openDatabase(path,
      version: 1, onCreate: (Database db, int version) async {});

  await database.transaction((txn) async {
    var result = txn.rawDelete(
        'UPDATE tbl_grupo_temp SET active = 0, is_queue = 0 WHERE id_registro = ${idRegistro}');

    var result2 = txn.rawDelete(
        'UPDATE alumnos_pre_temp SET active = 0, is_queue = 0 WHERE id_curso = ${idRegistro}');
  });

  database.close();
}

getAlumnos(id_curso) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'syvic_offline.db');
  // await deleteDatabase(path);

  Database database = await openDatabase(path,
      version: 1, onCreate: (Database db, int version) async {});
  List alumnos_temp =
      await database.query('alumnos_pre_temp where id_curso = $id_curso');
  String aux = jsonEncode(alumnos_temp);
  // print(aux);
  // inspect(alumnos_temp[2].row);
  // for (var alumno in alumnos_temp) {
  //   print(alumno.row);
  // }
  return jsonEncode(alumnos_temp).toString();
}
