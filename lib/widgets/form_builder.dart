import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_banking_app/models/alumno.dart';
import 'package:flutter_banking_app/repo/repository.dart';
import 'package:flutter_banking_app/utils/styles.dart';
import 'package:flutter_banking_app/views/info_alumno.dart';
import 'package:flutter_banking_app/widgets/buttons.dart';
import 'package:flutter_banking_app/widgets/separator.dart';
import 'package:gap/gap.dart';
import 'dart:convert';

import '../views/home.dart';
import 'default_text_field.dart';
import 'package:http/http.dart' as http;

List<Widget> formBuilder(data, cardSize, context, state) {
  List<Widget> alumno = [];
  Alumno alumnoInfo = data;
  final TextEditingController _entidadNacimiento = TextEditingController();
  final TextEditingController _seccionVota = TextEditingController();
  final TextEditingController _calle = TextEditingController();
  final TextEditingController _numExt = TextEditingController();
  final TextEditingController _numInt = TextEditingController();
  final TextEditingController _observaciones = TextEditingController();

  final TextEditingController _nombreCompleto = TextEditingController();
  final TextEditingController _domicilio = TextEditingController();
  final TextEditingController _curp = TextEditingController();
  final TextEditingController _estado = TextEditingController();
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _numeroTelefono = TextEditingController();

  alumno.add(
    SizedBox(
      width: double.infinity,
      height: cardSize,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: cardSize * 0.35,
            padding: const EdgeInsets.fromLTRB(16, 10, 20, 20),
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              color: Styles.icatechGoldColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Image.asset(Assets.cardsVisaWhite,
                //     width: 60, height: 45, fit: BoxFit.cover),
                Text(alumnoInfo.nombre,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 0, 20),
            height: cardSize * 0.65,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(15)),
              color: Styles.icatechPurpleColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customColumn(
                    title: 'Matricula', subtitle: alumnoInfo.matricula),
                const Spacer(),
                Row(
                  children: [
                    customColumn(
                        title: 'Fecha Nacimiento',
                        subtitle: alumnoInfo.fechaNacimiento
                            .toString()
                            .split('T')[0]),
                    const Gap(40),
                    customColumn(title: 'Sexo', subtitle: alumnoInfo.sexo)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
  alumno.add(const Gap(20));

  alumno.add(const Gap(30));
  alumno.add(separatorText(context: context, text: 'Informacion General'));
  alumno.add(
    DefaultTextField(
        controller: _nombreCompleto,
        title: 'Nombre y Apellidos',
        label: alumnoInfo.nombre +
            ' ' +
            alumnoInfo.apellidoPaterno +
            ' ' +
            alumnoInfo.apellidoMaterno,
        enabled: false),
  );
  alumno.add(DefaultTextField(
      controller: _curp,
      title: 'CURP',
      label: alumnoInfo.curp,
      enabled: false));

  alumno.add(DefaultTextField(
      controller: _domicilio,
      title: 'Domicilio',
      label: alumnoInfo.domicilio,
      enabled: false));

  alumno.add(
    Row(
      children: [
        Flexible(
          child: DefaultTextField(
              controller: _domicilio,
              title: 'Municipio',
              label: alumnoInfo.estado,
              enabled: false),
        ),
        const Gap(10),
        Flexible(
            child: DefaultTextField(
                controller: _estado,
                title: 'Estado',
                label: alumnoInfo.estado,
                enabled: false)),
      ],
    ),
  );
  alumno.add(
    Row(
      children: [
        Flexible(
          child: DefaultTextField(
              controller: _correo,
              title: 'Correo',
              label: alumnoInfo.correo,
              enabled: false),
        ),
        const Gap(10),
        Flexible(
          child: DefaultTextField(
              controller: _numeroTelefono,
              title: 'Telefono',
              label: alumnoInfo.telefono,
              obscure: true,
              enabled: false),
        ),
      ],
    ),
  );

  alumno.add(
    DefaultTextField(
        controller: _entidadNacimiento,
        title: 'Entidad nacimiento',
        label: 'Nacimiento',
        enabled: true),
  );

  alumno.add(
    Row(
      children: [
        Flexible(
          child: DefaultTextField(
              controller: _calle,
              title: 'Calle',
              label: 'Introduzca su direccion',
              enabled: true),
        ),
      ],
    ),
  );

  alumno.add(
    Row(
      children: [
        Flexible(
          child: DefaultTextField(
              controller: _seccionVota,
              title: 'Seccion Vota',
              label: '###',
              obscure: true,
              enabled: true,
              isRequired: true),
        ),
        const Gap(10),
        Flexible(
          child: DefaultTextField(
              controller: _numExt,
              title: 'Num Ext',
              label: '####',
              obscure: true,
              enabled: true,
              isRequired: true),
        ),
        const Gap(10),
        Flexible(
          child: DefaultTextField(
              controller: _numInt,
              title: 'Num Int',
              label: '####',
              obscure: true,
              enabled: true,
              isRequired: true),
        ),
      ],
    ),
  );
  alumno.add(DefaultTextField(
      controller: _observaciones,
      title: 'Observaciones',
      label: 'Escriba aqui sus observaciones',
      obscure: false,
      enabled: true,
      maxLines: 8,
      isRequired: false));
  alumno.add(const Gap(10));

  alumno
      .add(separatorText(context: context, text: 'Preguntas de Satisfaccion'));
  alumno.add(elevatedButton(
    color: Repository.selectedItemColor(context),
    context: context,
    callback: () {
      alumnoInfo.addNewInfo(_entidadNacimiento.text, _seccionVota.text,
          _calle.text, _numExt.text, _numInt.text, _observaciones.text);
      saveAlumno(data);
    },
    text: 'Guardar',
  ));

  return alumno;
}

void saveAlumno(data) async {
  bool connectivitiExist = await checkInternetConnection();
  if (connectivitiExist) {
    print('hay conexion');

    // var connection = PostgreSQLConnection("localhost", 5432, "dart_test", username: "dart", password: "dart");
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/save/alumno'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'clave': data}),
    );
  }
  
}
