import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banking_app/models/alumno.dart';
import 'package:flutter_banking_app/widgets/buttons.dart';
import 'package:flutter_banking_app/widgets/default_text_field.dart';
import 'package:flutter_banking_app/widgets/form_builder.dart';
import 'package:flutter_banking_app/widgets/my_app_bar.dart';
import 'package:flutter_banking_app/repo/repository.dart';
import 'package:flutter_banking_app/utils/layouts.dart';
import 'package:flutter_banking_app/utils/styles.dart';
import 'package:flutter_banking_app/widgets/separator.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // join()
import '../utils/size_config.dart';

class InfoAlumno extends StatefulWidget {
  final Alumno alumno;
  const InfoAlumno({Key? key, required this.alumno}) : super(key: key);

  @override
  State<InfoAlumno> createState() => _InfoAlumnoState();
}

class _InfoAlumnoState extends State<InfoAlumno> {
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

  bool checkedValueSi1 = false;
  bool checkedValueNo1 = false;
  bool checkedValueSi2 = false;
  bool checkedValueNo2 = false;
  bool checkedValueSi3 = false;
  bool checkedValueNo3 = false;
  bool checkedValueSi4 = false;
  bool checkedValueNo4 = false;
  bool checkedValueSi5 = false;
  bool checkedValueNo5 = false;
  bool checkedValueSi6 = false;
  bool checkedValueNo6 = false;
  bool checkedValueSi7 = false;
  bool checkedValueNo7 = false;
  bool checkedValueSi8 = false;
  bool checkedValueNo8 = false;
  bool checkedValueSi9 = false;
  bool checkedValueNo9 = false;
  bool checkedValueSi10 = false;
  bool checkedValueNo10 = false;
  bool checkedValueSi11 = false;
  bool checkedValueNo11 = false;
  bool checkedValueSi12 = false;
  bool checkedValueNo12 = false;
  bool checkedValueSi13 = false;
  bool checkedValueNo13 = false;
  bool checkedValueSi14 = false;
  bool checkedValueNo14 = false;
  bool checkedValueSi15 = false;
  bool checkedValueNo15 = false;
  bool checkedValueSi16 = false;
  bool checkedValueNo16 = false;
  bool checkedValueSi17 = false;
  bool checkedValueNo17 = false;

  String dropdownValue = 'Selecciona una opcion';

  @override
  void initState() {
    inspect(widget.alumno);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = Layouts.getSize(context);
    final cardSize = size.height * 0.23;
    SizeConfig.init(context);
    return Scaffold(
        backgroundColor: Repository.bgColor(context),
        appBar: myAppBar(
            title: 'Informacion Alumno', implyLeading: true, context: context),
        body: ListView(
          padding: const EdgeInsets.all(15),
          children: [
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
                        Text(widget.alumno.nombre,
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
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(15)),
                      color: Styles.icatechPurpleColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customColumn(
                            title: 'Matricula',
                            subtitle: widget.alumno.matricula),
                        const Spacer(),
                        Row(
                          children: [
                            customColumn(
                                title: 'Fecha Nacimiento',
                                subtitle: widget.alumno.fechaNacimiento
                                    .toString()
                                    .split('T')[0]),
                            const Gap(40),
                            customColumn(
                                title: 'Sexo', subtitle: widget.alumno.sexo)
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Gap(50),
            separatorText(context: context, text: 'Informacion General'),
            DefaultTextField(
                controller: _nombreCompleto,
                title: 'Nombre y Apellidos',
                label: widget.alumno.nombre +
                    ' ' +
                    widget.alumno.apellidoPaterno +
                    ' ' +
                    widget.alumno.apellidoMaterno,
                enabled: false),
            DefaultTextField(
                controller: _curp,
                title: 'CURP',
                label: widget.alumno.curp,
                enabled: false),
            DefaultTextField(
                controller: _domicilio,
                title: 'Domicilio',
                label: widget.alumno.domicilio,
                enabled: false),
            Row(
              children: [
                Flexible(
                  child: DefaultTextField(
                      controller: _domicilio,
                      title: 'Municipio',
                      label: widget.alumno.estado,
                      enabled: false),
                ),
                const Gap(10),
                Flexible(
                    child: DefaultTextField(
                        controller: _estado,
                        title: 'Estado',
                        label: widget.alumno.estado,
                        enabled: false)),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: DefaultTextField(
                      controller: _correo,
                      title: 'Correo',
                      label: widget.alumno.correo,
                      enabled: false),
                ),
                const Gap(10),
                Flexible(
                  child: DefaultTextField(
                      controller: _numeroTelefono,
                      title: 'Telefono',
                      label: widget.alumno.telefono,
                      obscure: true,
                      enabled: false),
                ),
              ],
            ),
            const Gap(10),
            DefaultTextField(
                controller: _entidadNacimiento,
                title: 'Entidad nacimiento',
                label: 'Nacimiento',
                enabled: true),
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
            DefaultTextField(
                controller: _observaciones,
                title: 'Observaciones',
                label: 'Escriba aqui sus observaciones',
                obscure: false,
                enabled: true,
                maxLines: 8,
                isRequired: false),
            separatorText(context: context, text: 'Preguntas de Satisfaccion'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                    child: Text(
                        '¿EL TRAMITE DE INSCRIPCION AL CURSO FUE FACIL?',
                        style: TextStyle(
                            color: Repository.subTextColor(context)))),
                Divider(
                  color: Repository.dividerColor(context),
                  thickness: 2,
                ),
                Container(padding: const EdgeInsets.fromLTRB(20, 25, 20, 0)),
                CheckboxListTile(
                  title: const Text("SI'"),
                  value: checkedValueSi1,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueSi1 = newValue!;
                      checkedValueNo1 = !newValue;
                      print('$newValue');
                      print('$checkedValueSi1-->$checkedValueNo1');
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                CheckboxListTile(
                  title: const Text("NO'"),
                  value: checkedValueNo1,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueNo1 = newValue!;
                      checkedValueSi1 = !newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                    child: Text(
                        '¿LA CUOTA DE RECUPERACION AL CURSO FUE ACEPTABLE?',
                        style: TextStyle(
                            color: Repository.subTextColor(context)))),
                Divider(
                  color: Repository.dividerColor(context),
                  thickness: 2,
                ),
                Container(padding: const EdgeInsets.fromLTRB(20, 25, 20, 0)),
                CheckboxListTile(
                  title: const Text("SI'"),
                  value: checkedValueSi2,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueSi2 = newValue!;
                      checkedValueNo2 = !newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                CheckboxListTile(
                  title: const Text("NO'"),
                  value: checkedValueNo2,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueNo2 = newValue!;
                      checkedValueSi2 = !newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                    child: Text(
                        '¿RECOMENDARIAS A TUS FAMILIARES Y AMIGOS A CAPACITARSE EN EL ICATECH?',
                        style: TextStyle(
                            color: Repository.subTextColor(context)))),
                Divider(
                  color: Repository.dividerColor(context),
                  thickness: 2,
                ),
                Container(padding: const EdgeInsets.fromLTRB(20, 25, 20, 0)),
                CheckboxListTile(
                  title: const Text("SI'"),
                  value: checkedValueSi3,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueSi3 = newValue!;
                      checkedValueNo3 = !newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                CheckboxListTile(
                  title: const Text("NO'"),
                  value: checkedValueNo3,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueNo3 = newValue!;
                      checkedValueSi3 = !newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                    child: Text('¿TE PARECE BIEN LOS CURSOS A DISTANCIA?',
                        style: TextStyle(
                            color: Repository.subTextColor(context)))),
                Divider(
                  color: Repository.dividerColor(context),
                  thickness: 2,
                ),
                Container(padding: const EdgeInsets.fromLTRB(20, 25, 20, 0)),
                CheckboxListTile(
                  title: const Text("SI'"),
                  value: checkedValueSi4,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueSi4 = newValue!;
                      checkedValueNo4 = !newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                CheckboxListTile(
                  title: const Text("NO'"),
                  value: checkedValueNo4,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueNo4 = newValue!;
                      checkedValueSi4 = !newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                    child: Text(
                        'SI EL CURSO FUE PRESENCIAL ¿EL ESPACIO, MOBILIARIO Y MATERIAL UTILIZADO FUE BUENO?',
                        style: TextStyle(
                            color: Repository.subTextColor(context)))),
                Divider(
                  color: Repository.dividerColor(context),
                  thickness: 2,
                ),
                Container(padding: const EdgeInsets.fromLTRB(20, 25, 20, 0)),
                CheckboxListTile(
                  title: const Text("SI'"),
                  value: checkedValueSi5,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueSi5 = newValue!;
                      checkedValueNo5 = !newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                CheckboxListTile(
                  title: const Text("NO'"),
                  value: checkedValueNo5,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueNo5 = newValue!;
                      checkedValueSi5 = !newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                )
              ],
            ),
            elevatedButton(
              color: Repository.selectedItemColor(context),
              context: context,
              callback: () {
                updateInfoAlumno();
              },
              text: 'Guardar',
            )
          ],
        ));
  }

  void updateInfoAlumno() {
     print(_entidadNacimiento.text);
  print(_seccionVota.text);
  print(_calle.text);
  print(_numExt.text);
  print(_numInt.text);
  print(_observaciones.text);

  print(_nombreCompleto.text);
  print(_domicilio.text);
  print(_curp.text);
  print(_estado.text);
  print(_correo.text);
  print(_numeroTelefono.text);
    
  }
}

Widget customColumn({required String title, required String subtitle}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title.toUpperCase(),
          style: const TextStyle(fontSize: 14, color: Colors.white)),
      const Gap(4),
      Text(subtitle, style: const TextStyle(fontSize: 18, color: Colors.white)),
    ],
  );
}

void saveAlumno(data) async {}
