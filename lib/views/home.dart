import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banking_app/models/db_helper.dart';
import 'package:flutter_banking_app/models/grupo.dart';

import 'package:flutter_banking_app/repo/repository.dart';
import 'package:flutter_banking_app/utils/iconly/iconly_bold.dart';
import 'package:flutter_banking_app/utils/layouts.dart';
import 'package:flutter_banking_app/utils/size_config.dart';
import 'package:flutter_banking_app/utils/styles.dart';

import 'package:flutter_banking_app/widgets/loadingIndicator.dart';
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
  Future<List>? _futureGrupo;
  bool visible = true;

  @override
  void initState() {
    createTables();
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
                        Text('Hola verificador' + Environment.fileName,
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

Future<List> _getGrupos() async {
  final response =
      await http.get(Uri.parse(Environment.apiUrl + '/list/grupo'));

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    return jsonDecode(body);
  } else {
    throw Exception('Failed to create album.');
  }
}

Future<List> _getAlumnosInscritos() async {
  final response =
      await http.get(Uri.parse(Environment.apiUrl + '/list/alumnosInscritos'));

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    return jsonDecode(body);
  } else {
    throw Exception('Falló la conexión');
  }
}

Future<List> _getAlumnosPre() async {
  final response =
      await http.get(Uri.parse(Environment.apiUrl + '/list/alumnosPre'));

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    return jsonDecode(body);
  } else {
    throw Exception('Falló la conexión');
  }
}

Future createTables() async {
  helperCreateTables();
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
  } else {
    throw Exception('Failed to upload.');
  }
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

    var result2 = txn.rawDelete(
        'DELETE FROM alumnos_pre_temp WHERE id_curso = ${idRegistro}');
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
