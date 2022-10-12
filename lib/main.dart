import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervision_icatech/enviroment/enviroment.dart';
import 'package:supervision_icatech/utils/styles.dart';
import 'package:supervision_icatech/view_models/view_models.dart';
import 'package:supervision_icatech/views/login.dart';
import 'package:supervision_icatech/widgets/bottom_nav.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await dotenv.load(fileName: Environment.fileName);
  WidgetsFlutterBinding.ensureInitialized();

  ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences sharedPreferences;

  Future<String?> verificarSesion() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('correo') == null) {
      return '';
    }
    return sharedPreferences.getString('name');
  } 

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ViewModel())],
      child: MaterialApp(
          title: 'Icatech Supervision',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'DMSans',
            primaryColor: Styles.primaryColor,
            backgroundColor: Styles.primaryColor,
          ),
          home: FutureBuilder(
            future: verificarSesion(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  if (snapshot.data != '') {
                    return const BottomNav();
                  }
                  return const LoginPage();
                } else {
                  return const LoginPage();
                }
              }
              return Container(
                  child: Center(
                      child: CircularProgressIndicator(
                color: Color(0xFF541533),
              )));
            },
            //child: Home()
          )),
    );
  }
}
