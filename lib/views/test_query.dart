import 'dart:async';

import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_banking_app/repo/repository.dart';
import 'package:flutter_banking_app/utils/layouts.dart';

import 'package:flutter_banking_app/widgets/my_app_bar.dart';
import 'package:gap/gap.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
      print('Couldn\'t check connectivity status $e');
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
          title: 'TEST QUERY',
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
                    print('hacer query');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    width: size.width * 0.44,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Repository.headerColor(context)),
                    child: const Text('Income',
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
                    child: Text('Expenses ${_connectionStatus.toString()}',
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
  String path = join(databasesPath, 'syvic_offline.db');
  // await deleteDatabase(path);

  Database database = await openDatabase(path,
      version: 1, onCreate: (Database db, int version) async {});

  (await database.query('sqlite_master', columns: ['type', 'name']))
      .forEach((row) {
    print(row.values);
  });
  List<Map> grupos =
      await database.rawQuery('SELECT COUNT (*) FROM tbl_grupo_offline ');
  List<Map> inscripcion =
      await database.rawQuery('SELECT COUNT (*) FROM tbl_inscripcion_offline ');
  List<Map> alumnos =
      await database.rawQuery('SELECT COUNT(*) FROM alumnos_pre_offline');

  List<Map> grupos_temp =
      await database.rawQuery('SELECT * FROM tbl_grupo_temp');
  List<Map> inscripcion_temp =
      await database.rawQuery('SELECT COUNT(*) FROM tbl_inscripcion_temp');
  List<Map> alumnos_temp =
      await database.rawQuery('SELECT COUNT(*) FROM alumnos_pre_temp where id_curso = 222260047');

        List<Map> queue =
      await database.rawQuery('SELECT * FROM tbl_queue_grupos');

  print('============== grupos');
  for (var item in grupos) {
    print(item);
  }
  print('============== inscritor');
  for (var item in inscripcion) {
    print(item);
  }
  print('============== alumnos');
  for (var item in alumnos) {
    print(item);
  }

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

  print('============== queue');
  for (var item in queue) {
    print(item);
  }
}
