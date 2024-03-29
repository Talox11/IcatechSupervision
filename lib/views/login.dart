// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:supervision_icatech/enviroment/enviroment.dart';
import 'package:supervision_icatech/generated/assets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supervision_icatech/alerts/loader.dart';
import 'package:supervision_icatech/http/http_handle.dart';
import 'package:supervision_icatech/views/home.dart';
import 'package:supervision_icatech/widgets/bottom_nav.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showPassword = false;
  final _formKey = GlobalKey<FormState>();
  final EmailController = TextEditingController();
  final PassController = TextEditingController();
  late SharedPreferences sharedPreferences;
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  void showSnackBar(String texto) {
    final snackBar = SnackBar(
      content: Text(texto),
      padding: const EdgeInsets.all(15),
      backgroundColor: Theme.of(context).primaryColor,
      duration: const Duration(seconds: 15),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Scaffold(
        key: _scaffoldstate,
        backgroundColor: Colors.white,
        body: Padding(
          padding:
              const EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 40),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'v. 1.0.1 © 2022 ICATECH',
                      style: TextStyle(color: Colors.grey),
                    )),
                const SizedBox(
                  height: 70,
                ),
                Image.asset(
                  Assets.icatechIcon,
                  width: 250,
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  'Bienvenido',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Iniciar sesion para continuar',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[400]),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    controller: EmailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su correo electronico';
                      } else if (!EmailValidator.validate(value)) {
                        return 'Ingrese un correo valido';
                      }
                      return null;
                    },
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.mail,
                          size: 30,
                        ),
                        labelText: 'Correo electronico',
                        labelStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w800)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    controller: PassController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su contraseña';
                      }
                      return null;
                    },
                    obscureText: !_showPassword,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.lock,
                        size: 30,
                      ),
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w800),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Loader().showCargando(context);

                        HttpHandle()
                            .auth(EmailController.text, PassController.text)
                            .then((value) async {
                          Navigator.of(context).pop();
                          if (value == 'error') {
                            showSnackBar(
                                'Ocurrio un error de comunicación con los servidores, intente de nuevo.');
                          } else {
                            if (value == 'noExiste') {
                              showSnackBar(
                                  'No se encontro el usuario. Verifique que los datos ingresados estan escritos correctamente!');
                            } else {
                              sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences.setString(
                                  'correo', EmailController.text);
                              sharedPreferences.setString(
                                  'name', value['name']);
                              sharedPreferences.setInt('id_sivyc', value['id']);
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const BottomNav()),
                                  (route) => false);
                            }
                          }
                        });
                      }
                    },
                    child: const Text('Iniciar sesion'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
