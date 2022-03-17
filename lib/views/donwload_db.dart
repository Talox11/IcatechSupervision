import 'dart:async';

import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_banking_app/repo/repository.dart';
import 'package:flutter_banking_app/utils/layouts.dart';
import 'package:flutter_banking_app/widgets/buttons.dart';

import 'package:flutter_banking_app/widgets/my_app_bar.dart';
import 'package:gap/gap.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DownloadDB extends StatefulWidget {
  const DownloadDB({Key? key}) : super(key: key);

  @override
  _DownloadDBState createState() => _DownloadDBState();
}

class _DownloadDBState extends State<DownloadDB> {
  late List _futureGrupo;
  late List _listAlumnos = [];

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<List> _getInfoGrupo() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/list/grupo'));

    if (response.statusCode == 201) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      // final data = GrupoJson.fromJson(jsonData);

      return jsonDecode(body);
    } else {
      throw Exception('Failed to create album.');
    }
  }

  @override
  void initState() {
    super.initState();
    // _getInfoGrupo();
    checkInternetConnection();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // testQuery();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = Layouts.getSize(context);
    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      appBar: myAppBar(
          title: 'DESCARGAR BASE DE DATOS',
          implyLeading: true,
          context: context),
      bottomSheet: Container(
        color: Repository.bgColor(context),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
        child: elevatedButton(
          color: Repository.selectedItemColor(context),
          context: context,
          callback: () {},
          text: 'DESCARGAR BASE DE DATOS',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          elevatedButton(
            color: Repository.selectedItemColor(context),
            context: context,
            callback: () {
              print('subir datos ');
            },
            text: 'DESCARGAR BASE DE DATOS',
          ),
        ],
      ),
    );
  }
}

void checkInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    print('connected to internet mobile');
  } else if (connectivityResult == ConnectivityResult.wifi) {
    print('connected to internet wifi');
    // I am connected to a wifi network.
  } else {
    print('no connection to internet');
  }
}

void testQuery() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'demo.db');

// open the database

  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
  });

  await database.transaction((txn) async {
    int id1 = await txn.rawInsert(
        'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
    print('inserted1: $id1');
    int id2 = await txn.rawInsert(
        'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
        ['another name', 12345678, 3.1416]);
    print('inserted2: $id2');
  });

  List<Map> list = await database.rawQuery('SELECT * FROM Test');
  print(list);
}

void testQuery2() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'demo.db');

// open the database

  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE IF DONT EXIST Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
  });

  List<Map> list = await database.rawQuery('SELECT * FROM Test');
  print(list);
}
