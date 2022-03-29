import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banking_app/models/db_helper.dart';

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
                            checkInternetConnection().then((connected) {
                              if (connected) {
                                showDownloadDBDialog(context);
                              } else {
                                showNoInternetConn(context);
                              }
                            });
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
                          onTap: () async {
                            //update
                            checkInternetConnection().then((connected) async{
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
                                Icon(Icons.error),
                                Text('Failed to fetch data.'),
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
          await checkInternetConnection().then((onValue) {
            if (onValue) {
              uploadGrupo(grupo);
              state.setState(() {
                _futureGrupo = getQueueUpload();
              });
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
      onPressed: () async {
        bool connectivityExist = false;
        await checkInternetConnection().then((onValue) {
          connectivityExist = onValue;
          print('On connectivityExist =  $connectivityExist');
        });

        if (connectivityExist) {
          print('downloading');
          DialogBuilder(context).showLoadingIndicator();
          await downloadDB();
          Navigator.pop(context);
          DialogBuilder(context).hideOpenDialog();
        } else {
          print('No hay conexion');
        }
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
  print(gruposList);
  for (var grupo in gruposList) {
    await uploadGrupo(grupo);
  }
}

Future<List> downloadDB() async {
  late List _listGrupos = [];
  late List _listAlumnosInscritos = [];
  late List _listAlumnosPre = [];
  // saveDB(jsonData);
  print('dowloading ');
  _listGrupos = await _getGrupos();
  _listAlumnosInscritos = await _getAlumnosInscritos();
  _listAlumnosPre = await _getAlumnosPre();

  await saveDB(_listGrupos, _listAlumnosInscritos, _listAlumnosPre);
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

Future<List> saveDB(grupos, alumnosIns, alumnosPre) async {
  await dowloadDB(grupos, alumnosIns, alumnosPre);
  return [
    {'done'}
  ];
}

Future createTables() async {
  helperCreateTables();
}

Future<bool> checkInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    return false;
  }
}

Future<bool> verifyIfTableExist(db, tableName) async {
  List row = await db
      .query('sqlite_master', where: 'name = ?', whereArgs: [tableName]);
  print(row);
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
          'curso': grupo['curso'],
          'cct': grupo['cct'],
          'unidad': grupo['unidad'],
          'clave': grupo['clave'],
          'mod': grupo['mod'],
          'area': grupo['area'] ?? 'N/A',
          'espe': grupo['espe'],
          'tcapacitacion': grupo['tcapacitacion'],
          'depen': grupo['depen'],
          'tipo_curso': grupo['tipo_curso'],
        });
    return row;
    // );
  }).then((insertedId) async {
    await connection.transaction((ctx) async {
      List alumnos = await getAlumnos(grupo['id_registro']);

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
              'entidad_nacimiento': '', //entidad nacimiento,
              'seccion_vota': alumno['seccion_vota'],
              'calle': '', //calle
              'num_ext': alumno['numExt'],
              'num_int': alumno['numInt'],
              'observaciones': '', //observaciones
              'resp_satisfaccion': alumno['resp_satisfaccion'],
              'com_satisfaccion': alumno['com_satisfaccion'],
            });
      }
    });
    await removeGrupoQueue(grupo);
  });

  connection.close();
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
