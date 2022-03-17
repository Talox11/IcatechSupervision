import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_banking_app/generated/assets.dart';
import 'package:flutter_banking_app/json/shortcut_list.dart';
import 'package:flutter_banking_app/models/grupo.dart';
import 'package:flutter_banking_app/models/salumnomodel.dart';
import 'package:flutter_banking_app/repo/repository.dart';
import 'package:flutter_banking_app/utils/layouts.dart';
import 'package:flutter_banking_app/utils/styles.dart';
import 'package:flutter_banking_app/views/info_alumno.dart';
import 'package:flutter_banking_app/widgets/buttons.dart';
import 'package:flutter_banking_app/widgets/my_app_bar.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

class InfoGrupo extends StatefulWidget {
  final String clave;
  const InfoGrupo({Key? key, required this.clave}) : super(key: key);

  @override
  State<InfoGrupo> createState() => _InfoGrupoState();
}

class _InfoGrupoState extends State<InfoGrupo> {
  late Future<Grupo> _futureGrupo;
  late List _listAlumnos = [];
  Future<Grupo> _getInfoGrupo() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/curso/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'clave': widget.clave}),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      // print(jsonData);
      _listAlumnos = await _getAlumnos(jsonData[0]['id']);
      // print(_listAlumnos);

      Grupo grupo = Grupo(
          jsonData[0]['id'],
          jsonData[0]['curso'],
          jsonData[0]['cct'],
          jsonData[0]['unidad'],
          jsonData[0]['clave'],
          jsonData[0]['inicio'],
          jsonData[0]['termino']);
      grupo.setAlumnos(_listAlumnos);
      // print(grupo.alumnos);
      return grupo;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.

      throw Exception('Failed to create album.');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureGrupo = _getInfoGrupo();
  }

  @override
  Widget build(BuildContext context) {
    final size = Layouts.getSize(context);
    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      appBar: myAppBar(
          title: 'Informacion general del grupo',
          implyLeading: false,
          context: context),
      body: FutureBuilder(
          future: _futureGrupo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                padding: const EdgeInsets.all(15),
                children: _showInfo(snapshot.data, size, context),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Text('Error' + snapshot.error.toString());
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

List<Widget> _showInfo(dataResponse, size, context) {
  List<Widget> widgetInfoGeneral = [];
  Grupo infoGrupo = dataResponse;
  List<Alumno> infoAlumno = [];

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
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
            child: Text('Alumnos inscritos a este grupo',
                style: TextStyle(
                    color: Repository.subTextColor(context), fontSize: 30))),
        Divider(
          color: Repository.dividerColor(context),
          thickness: 2,
        ),
        Container(padding: const EdgeInsets.fromLTRB(20, 25, 20, 30)),
      ],
    ),
  );
  // print(infoGrupo.alumnos);
  var data = infoGrupo.alumnos;
  for (var item in data) {
    // print(item);
    widgetInfoGeneral.add(
      InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InfoAlumno(curp: item['curp']),
              ));
        },
        child: FittedBox(
          child: SizedBox(
            height: size.height * 0.23,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.67,
                  padding: const EdgeInsets.fromLTRB(16, 10, 0, 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(15)),
                    color: Styles.greenColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image.asset(Assets.cardsVisaYellow,
                      //     width: 60, height: 50, fit: BoxFit.cover),
                      Text(item['nombre'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: Colors.white)),
                      const Gap(20),
                      Text('CURP',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12)),
                      const Gap(5),
                      Text(item['curp'],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15)),
                    ],
                  ),
                ),
                Container(
                  width: size.width * 0.27,
                  padding: const EdgeInsets.fromLTRB(20, 10, 0, 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(15)),
                    color: Styles.yellowColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Styles.greenColor,
                        ),
                        child: const Icon(Icons.swipe_rounded,
                            color: Colors.white, size: 20),
                      ),
                      const Spacer(),
                      const Text('Matricula', style: TextStyle(fontSize: 12)),
                      const Gap(5),
                      Text(item['matricula'], style: TextStyle(fontSize: 15)),
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
      print('subir datos ');
    },
    text: 'Finalizar',
  ));
  print('done');
  return widgetInfoGeneral;
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
