import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:supervision_icatech/enviroment/enviroment.dart';
import 'package:supervision_icatech/models/alumno.dart';
import 'package:supervision_icatech/models/grupo.dart';
import 'package:supervision_icatech/views/home.dart';

class HttpHandle {
  String path = 'http://sivyc.icatech.gob.mx/api'; //civyc
  String path2 = 'http://10.0.2.2:9000'; //siata
  //  String path = 'http://sivyc.icatech.gob.mx';

  HttpHandle() {
    path = 'http://10.0.2.2:8000'; //civyc
    path2 = 'http://10.0.2.2:9000'; //siata
  }
  Future auth(String email, String password) async {
    
    try {
      final response = await http.post(
      Uri.parse(Environment.apiUrlLaravel + '/sivycMovil/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    inspect(response);
      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        // await authSiata(email, token);
        return jsonDecode(body);
      }
      return null;
    } catch (e) {
      return e;
    }
  }

  Future authSiata(String email, String token) async {
    var url = Uri.parse('$path2/api/sivycMovil/login');

    try {
      var response =
          await http.post(url, body: {'email': email, 'token': token});
      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        return;
      } else if (response.statusCode == 204) {
        print('mostrar alerta');
      }
      return null;
    } catch (e) {
      return 'error';
    }
  }

  Future updateToken(String id) async {
    var url = Uri.parse('$path/api/sivycMovil/updateToken');
    try {
      var response = await http.post(url, body: {'id': id});
      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        return jsonDecode(body);
      }
      return null;
    } catch (e) {
      return e;
    }
  }

  Future getCursosPorSupervisar() async {
    List listaCursos = [];
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
      listaCursos = jsonDecode(response.body);
    }

    return listaCursos;
  }

  Future descargarCurso(clave) async {
    List _listAlumnos = [];

    tempRecordExist('tbl_grupo_temp', 'clave',
            clave) //verify is the group exist on sqlite
        .then((exist) async {
      if (!exist) {
        //si existe localmente obtiene datos
        print('registro almacenado localmente');
        final response = await http.get(
            Uri.parse(Environment.apiUrlLaravel +
                '/supervision/movil/curso/' +
                clave),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            });
        // inspect(response);

        if (response.statusCode == 200) {
          // String body = utf8.decode(response.bodyBytes);
          final jsonData = jsonDecode(response.body);
          _listAlumnos = await _getAlumnos(jsonData[0]['id']);
          Grupo grupo = Grupo(
              jsonData[0]['id'].toString(),
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

          // return grupo;
          print('downloading curso ->' + clave);
          return jsonEncode('success');
        } else {
          // statusCode = response.statusCode.toString();
          throw Exception(
              'Failed to create album.: ' + response.statusCode.toString());
        }
      }
    });
  }

  Future _getAlumnos(clave) async {
    final response = await http.get(Uri.parse(
        Environment.apiUrlLaravel + '/supervision/movil/alumnos/$clave'));

    if (response.statusCode == 200) {
      // String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      inspect(response);
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
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'syvic_offline.db');

    Database database = await openDatabase(path,
        version: 1, onCreate: (Database db, int version) async {});
    List row = await database
        .query(dbTable, where: '$colum = ?', whereArgs: [idRegistro]);
    return row.isNotEmpty;
  }

  Future getCursosDescargados() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'syvic_offline.db');
    Database database = await openDatabase(path,
        version: 1, onCreate: (Database db, int version) async {});
    List row = await database
        .rawQuery('SELECT * FROM tbl_grupo_temp where is_editing = 1');
    return Future.value(row);
  }

  Future getInfoGrupo(clave) async {
    print(clave);
    List grupo = [];
    tempRecordExist('tbl_grupo_temp', 'clave',
            clave) //verify is the group exist on sqlite
        .then((exist) async {
      if (exist) {
        //si existe localmente obtiene datos
        return await getGrupoFromLocalDB(clave); // i get info from sqlite
      } else {
        // si no existe, hace peticion al servidor
        bool connected =
            await checkInternetConn(); //verify if i have internet connection
        if (connected) {
          return await _getInfoGrupo(
              clave); //if group doesn't exist i get info from a remote server
        } else {
          return grupo;
        }
      }
    });
  }

  Future _getInfoGrupo(clave) async {
    List _listAlumnos = [];

    final response = await http.get(
        Uri.parse(
            Environment.apiUrlLaravel + '/supervision/movil/curso/' + clave),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    // inspect(response);

    if (response.statusCode == 200) {
      // String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(response.body);
      // _listAlumnos = await _getAlumnos(jsonData[0]['id']);
      Grupo grupo = Grupo(
          jsonData[0]['id'].toString(),
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

      // grupo.addAlumos(_listAlumnos);
      // saveTemporaly(grupo);

      return grupo.toMap();
    } else {
      // statusCode = response.statusCode.toString();
      throw Exception(
          'Failed to create album.: ' + response.statusCode.toString());
    }
  }

  Future getGrupoFromLocalDB(clave) async {
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
}
