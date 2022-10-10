import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supervision_icatech/enviroment/enviroment.dart';
import 'package:supervision_icatech/http/http_handle.dart';

import 'package:supervision_icatech/models/grupo.dart';
import 'package:supervision_icatech/repo/repository.dart';
import 'package:supervision_icatech/utils/iconly/iconly_bold.dart';
import 'package:supervision_icatech/utils/layouts.dart';
import 'package:supervision_icatech/utils/styles.dart';

import 'package:supervision_icatech/views/info_grupo.dart';
import 'package:supervision_icatech/widgets/bottom_nav.dart';

import 'package:supervision_icatech/widgets/my_app_bar.dart';
import 'package:gap/gap.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import '../widgets/separator.dart';

class DownloadCursos extends StatefulWidget {
  const DownloadCursos({Key? key}) : super(key: key);

  @override
  State<DownloadCursos> createState() => _DownloadCursosState();
}

class _DownloadCursosState extends State<DownloadCursos> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<String> searchKeywordNotifier = ValueNotifier('');
  String connStatusMsg = 'Verificando conexion a internet';
  Color connStatusColor = Color.fromARGB(255, 224, 240, 105);
  late Grupo grupoObject;

  Future? _listGrupos;
  @override
  void initState() {
    _listGrupos = HttpHandle().getCursosPorSupervisar();
    checkInternetConn().then((connected) async {
      String msg = 'Sin conexion a internet';
      Color color = Color.fromARGB(255, 240, 213, 105);
      if (connected) {
        msg = 'Con conexion a internet';
        color = Color.fromARGB(255, 105, 240, 174);
      }
      setState(() {
        connStatusMsg = msg;
        connStatusColor = color;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = Layouts.getSize(context);
    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      appBar: myAppBar(
          title: 'Cursos Asignados Para Supervision',
          connStatus: connStatusMsg,
          connStatusColor: connStatusColor,
          implyLeading: false,
          context: context),
      body: ListView(
        padding: const EdgeInsets.all(2),
        children: [
          FutureBuilder(
              future: HttpHandle().getCursosPorSupervisar(),
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
              }),
        ],
      ),
    );
  }

  List<Widget> createListView(context, dataResponse, size, state) {
    List<Widget> widgetView = [];
    // List listGrupos = omitDownloadedCurso(dataResponse);

    widgetView.add(separatorText(
        context: context, text: 'Cursos Disponibles para supervision'));
    for (var grupo in dataResponse) {
      widgetView.add(const Gap(15));
      widgetView.add(InkWell(
        onTap: () {
          _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length));
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: new Icon(Icons.download),
                      title: new Text('Descargar'),
                      onTap: () {
                        HttpHandle()
                            .descargarCurso(grupo['clave'])
                            .then((value) {
                          if (value == 'success') {
                            successDownload(context);
                          } else {
                            print(value);
                          }
                        });
                        // state.setState({
                        //   _listGrupos = HttpHandle().getCursosPorSupervisar()
                        // });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
          // descargarGrupo
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => InfoGrupo(clave: grupo.clave),
          //     ));
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
                      infoCurso(
                          clave: 'Clave ' + grupo['clave'],
                          date: 'De ' +
                              grupo['inicio'] +
                              ' a ' +
                              grupo['termino']),
                      const Gap(15),
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

  FutureOr onGoBack(dynamic value) {
    super.initState();
    setState(() {});
  }
}

Widget customColumn({required String title, required String subtitle}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title.toUpperCase(),
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5))),
      const Gap(2),
      Text(subtitle,
          style: TextStyle(fontSize: 19, color: Colors.white.withOpacity(0.8))),
    ],
  );
}

Widget infoCurso({required String clave, required String date}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(clave.toUpperCase(),
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5))),
      const Gap(2),
      Text(date.toUpperCase(),
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5))),
    ],
  );
}

inputEmptyMsg(BuildContext context) {
  // set up the buttons

  Widget continueButton = TextButton(
    child: const Text('Aceptar'),
    onPressed: () async {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text('Oops!'),
    content: const Text('Por favor introduce la clave de curso'),
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

Future<bool> checkInternetConn() async {
  try {
    final result = await InternetAddress.lookup('google.com.mx');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    return false;
  } on SocketException catch (_) {
    print('not connected');
    return false;
  }
}

Future omitDownloadedCurso(cursos) async {
  List listGrupos = [];
  for (var curso in cursos) {
    tempRecordExist('tbl_grupo_temp', 'clave',
            curso['clave']) //verify is the group exist on sqlite
        .then((exist) {
      inspect(exist);
      if (!exist) {
        print('Grupo -> ' + curso['clave'] + ' no descargado');
        listGrupos.add(curso);
      }
    });
  }
}

Future<bool> tempRecordExist(dbTable, colum, idRegistro) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'syvic_offline.db');

  Database database = await openDatabase(path,
      version: 1, onCreate: (Database db, int version) async {});
  List row = await database
      .query(dbTable, where: '$colum = ?', whereArgs: [idRegistro]);
  return row.isNotEmpty;
}

successDownload(BuildContext context) {
  // set up the buttons
  print('alert');
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
    title: const Text('Exito'),
    content: const Text('Se descargo el grupo con exito'),
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
