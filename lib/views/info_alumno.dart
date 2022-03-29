import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_banking_app/models/alumno.dart';
import 'package:flutter_banking_app/widgets/buttons.dart';
import 'package:flutter_banking_app/widgets/default_text_field.dart';

import 'package:flutter_banking_app/widgets/my_app_bar.dart';
import 'package:flutter_banking_app/repo/repository.dart';
import 'package:flutter_banking_app/utils/layouts.dart';
import 'package:flutter_banking_app/utils/styles.dart';
import 'package:flutter_banking_app/widgets/separator.dart';
import 'package:gap/gap.dart';
import 'package:postgres/postgres.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // join()
import '../utils/size_config.dart';
import '../widgets/loadingIndicator.dart';

class InfoAlumno extends StatefulWidget {
  final Alumno alumno;
  final String clave;
  const InfoAlumno({Key? key, required this.alumno, required this.clave})
      : super(key: key);

  @override
  State<InfoAlumno> createState() => _InfoAlumnoState();
}

class _InfoAlumnoState extends State<InfoAlumno> {
  String claveGrupo = '';
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

  String dropdownValue = 'Selecciona una opcion';

  @override
  void initState() {
    claveGrupo = widget.clave;
    inspect(widget.alumno);
    if (widget.alumno.respSatisfaccion != '') {
      setCheckedValues(widget.alumno);
    }

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
              enabled: false,
              isRequired: true,
            ),
            DefaultTextField(
                controller: _curp,
                title: 'CURP',
                label: widget.alumno.curp,
                enabled: false,
                isRequired: true),
            DefaultTextField(
                controller: _domicilio,
                title: 'Domicilio',
                label: widget.alumno.domicilio,
                enabled: false,
                isRequired: true),
            Row(
              children: [
                Flexible(
                  child: DefaultTextField(
                      controller: _domicilio,
                      title: 'Municipio',
                      label: widget.alumno.estado,
                      enabled: false,
                      isRequired: true),
                ),
                const Gap(10),
                Flexible(
                    child: DefaultTextField(
                        controller: _estado,
                        title: 'Estado',
                        label: widget.alumno.estado,
                        enabled: false,
                        isRequired: true)),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: DefaultTextField(
                      controller: _correo,
                      title: 'Correo',
                      label: widget.alumno.correo,
                      enabled: false,
                      isRequired: true),
                ),
                const Gap(10),
                Flexible(
                  child: DefaultTextField(
                      controller: _numeroTelefono,
                      title: 'Telefono',
                      label: widget.alumno.telefono,
                      obscure: true,
                      enabled: false,
                      isRequired: true),
                ),
              ],
            ),
            const Gap(10),
            DefaultTextField(
                controller: _entidadNacimiento,
                title: 'Entidad nacimiento',
                label: 'Introduzca entidad nacimiento',
                enabled: true,
                isRequired: true),
            Row(
              children: [
                Flexible(
                  child: DefaultTextField(
                      controller: _calle,
                      title: 'Calle',
                      label: 'Introduzca su direccion',
                      enabled: true,
                      isRequired: true),
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
                      isRequired: false),
                ),
              ],
            ),
            DefaultTextField(
              controller: _observaciones,
              title: 'Observaciones',
              label: 'Escriba aqui sus observaciones',
              obscure: false,
              enabled: true,
              isRequired: false,
              maxLines: 8,
            ),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                    child: Text(
                        'Si el curso fue a distancia ¿La conectividad a internet fue constante sin interrupciones?',
                        style: TextStyle(
                            color: Repository.subTextColor(context)))),
                Divider(
                  color: Repository.dividerColor(context),
                  thickness: 2,
                ),
                Container(padding: const EdgeInsets.fromLTRB(20, 25, 20, 0)),
                CheckboxListTile(
                  title: const Text("SI'"),
                  value: checkedValueSi6,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueSi6 = newValue!;
                      checkedValueNo6 = !newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                CheckboxListTile(
                  title: const Text("NO'"),
                  value: checkedValueNo6,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueNo6 = newValue!;
                      checkedValueSi6 = !newValue;
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
                        '¿El tiempo de duración del curso (días), es aceptable?',
                        style: TextStyle(
                            color: Repository.subTextColor(context)))),
                Divider(
                  color: Repository.dividerColor(context),
                  thickness: 2,
                ),
                Container(padding: const EdgeInsets.fromLTRB(20, 25, 20, 0)),
                CheckboxListTile(
                  title: const Text("SI'"),
                  value: checkedValueSi7,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueSi7 = newValue!;
                      checkedValueNo7 = !newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                CheckboxListTile(
                  title: const Text("NO'"),
                  value: checkedValueNo7,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueNo7 = newValue!;
                      checkedValueSi7 = !newValue;
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
                    child: Text('¿¿El horario diario del curso es aceptable?',
                        style: TextStyle(
                            color: Repository.subTextColor(context)))),
                Divider(
                  color: Repository.dividerColor(context),
                  thickness: 2,
                ),
                Container(padding: const EdgeInsets.fromLTRB(20, 25, 20, 0)),
                CheckboxListTile(
                  title: const Text("SI'"),
                  value: checkedValueSi8,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueSi8 = newValue!;
                      checkedValueNo8 = !newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                CheckboxListTile(
                  title: const Text("NO'"),
                  value: checkedValueNo8,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueNo8 = newValue!;
                      checkedValueSi8 = !newValue;
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
                        '¿Quedaste satisfecho(a) con el contenido del curso?',
                        style: TextStyle(
                            color: Repository.subTextColor(context)))),
                Divider(
                  color: Repository.dividerColor(context),
                  thickness: 2,
                ),
                Container(padding: const EdgeInsets.fromLTRB(20, 25, 20, 0)),
                CheckboxListTile(
                  title: const Text("SI'"),
                  value: checkedValueSi9,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueSi9 = newValue!;
                      checkedValueNo9 = !newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                CheckboxListTile(
                  title: const Text("NO'"),
                  value: checkedValueNo9,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueNo9 = newValue!;
                      checkedValueSi9 = !newValue;
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
                        '¿El curso es lo que esperabas, aprendiste suficiente para ponerlo en práctica?',
                        style: TextStyle(
                            color: Repository.subTextColor(context)))),
                Divider(
                  color: Repository.dividerColor(context),
                  thickness: 2,
                ),
                Container(padding: const EdgeInsets.fromLTRB(20, 25, 20, 0)),
                CheckboxListTile(
                  title: const Text("SI'"),
                  value: checkedValueSi10,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueSi10 = newValue!;
                      checkedValueNo10 = !newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                CheckboxListTile(
                  title: const Text("NO'"),
                  value: checkedValueNo10,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueNo10 = newValue!;
                      checkedValueSi10 = !newValue;
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
                        '¿El instructor fue claro en la explicación del curso?',
                        style: TextStyle(
                            color: Repository.subTextColor(context)))),
                Divider(
                  color: Repository.dividerColor(context),
                  thickness: 2,
                ),
                Container(padding: const EdgeInsets.fromLTRB(20, 25, 20, 0)),
                CheckboxListTile(
                  title: const Text("SI'"),
                  value: checkedValueSi11,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueSi11 = newValue!;
                      checkedValueNo11 = !newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                CheckboxListTile(
                  title: const Text("NO'"),
                  value: checkedValueNo11,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueNo11 = newValue!;
                      checkedValueSi11 = !newValue;
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
                        '¿El material de apoyo del Instructor fue bueno? (presentaciones, videos, audios, etc.?',
                        style: TextStyle(
                            color: Repository.subTextColor(context)))),
                Divider(
                  color: Repository.dividerColor(context),
                  thickness: 2,
                ),
                Container(padding: const EdgeInsets.fromLTRB(20, 25, 20, 0)),
                CheckboxListTile(
                  title: const Text("SI'"),
                  value: checkedValueSi12,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueSi12 = newValue!;
                      checkedValueNo12 = !newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                CheckboxListTile(
                  title: const Text("NO'"),
                  value: checkedValueNo12,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueNo12 = newValue!;
                      checkedValueSi12 = !newValue;
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
                        '¿El Instructor motivó a los asistentes a participar en clase, por lo que ésta fue dinámica ? ',
                        style: TextStyle(
                            color: Repository.subTextColor(context)))),
                Divider(
                  color: Repository.dividerColor(context),
                  thickness: 2,
                ),
                Container(padding: const EdgeInsets.fromLTRB(20, 25, 20, 0)),
                CheckboxListTile(
                  title: const Text("SI'"),
                  value: checkedValueSi13,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueSi13 = newValue!;
                      checkedValueNo13 = !newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                CheckboxListTile(
                  title: const Text("NO'"),
                  value: checkedValueNo13,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValueNo13 = newValue!;
                      checkedValueSi13 = !newValue;
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
                try {
                  if (validateAnswers()) {
                    
                    updateInfoAlumno(context);
                  } else {
                    
                    showFormNoCompleted(context);
                    // DialogBuilder(context).showLoadingIndicator();
                  }
                  // Navigator.pop(context);
                } catch (e) {
                  throw e;
                }
              },
              text: 'Guardar',
            )
          ],
        ));
  }

  void updateInfoAlumno(context) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'syvic_offline.db');

    Database database = await openDatabase(path,
        version: 1, onCreate: (Database db, int version) async {});
    await validateAnswers();
    await database.transaction((txn) async {
      txn.rawInsert(
          'UPDATE alumnos_pre_temp SET entidad_nacimiento = "${_entidadNacimiento.text}", calle = "${_calle.text}", observaciones = "${_observaciones.text}", seccion_vota = "${_seccionVota.text}", numExt = "${_numExt.text}", numInt = "${_numInt.text}", resp_satisfaccion="${await getRespSatisfaccion()}", com_satisfaccion ="NA"'
          'WHERE id_registro = ${widget.alumno.id}');
    });
    var query = await database.transaction((txn) async {
      var xd = txn.rawQuery(
          'SELECT * FROM alumnos_pre_temp WHERE id_registro = ${widget.alumno.id}');

      inspect(xd);
    });

    Navigator.pop(context);
  }

  Future<String> getRespSatisfaccion() async {
    String result = '';

    if (checkedValueSi1) {
      result = result + 'Si,';
    } else {
      result = result + 'No,';
    }
    if (checkedValueSi2) {
      result = result + 'Si,';
    } else {
      result = result + 'No,';
    }
    if (checkedValueSi3) {
      result = result + 'Si,';
    } else {
      result = result + 'No,';
    }
    if (checkedValueSi4) {
      result = result + 'Si,';
    } else {
      result = result + 'No,';
    }
    if (checkedValueSi5) {
      result = result + 'Si,';
    } else {
      result = result + 'No,';
    }
    if (checkedValueSi6) {
      result = result + 'Si,';
    } else {
      result = result + 'No,';
    }
    if (checkedValueSi7) {
      result = result + 'Si,';
    } else {
      result = result + 'No,';
    }
    if (checkedValueSi8) {
      result = result + 'Si,';
    } else {
      result = result + 'No,';
    }
    if (checkedValueSi9) {
      result = result + 'Si,';
    } else {
      result = result + 'No,';
    }
    if (checkedValueSi10) {
      result = result + 'Si,';
    } else {
      result = result + 'No,';
    }
    if (checkedValueSi11) {
      result = result + 'Si,';
    } else {
      result = result + 'No,';
    }
    if (checkedValueSi12) {
      result = result + 'Si,';
    } else {
      result = result + 'No,';
    }
    if (checkedValueSi13) {
      result = result + 'Si';
    } else {
      result = result + 'No';
    }

    return result;
  }

  validateAnswers() {
    bool isValid = false;
    bool inputsValid = false;

    if (_entidadNacimiento.text.isNotEmpty &&
        _seccionVota.text.isNotEmpty &&
        _calle.text.isNotEmpty &&
        _numExt.text.isNotEmpty) {
      inputsValid = true;
    } else {
      inputsValid = false;
    }

    if (checkedValueSi1 != checkedValueNo1) {
      isValid = true;
    } else {
      isValid = false;
    }
    if (checkedValueSi2 != checkedValueNo2) {
      isValid = true;
    } else {
      isValid = false;
    }
    if (checkedValueSi3 != checkedValueNo3) {
      isValid = true;
    } else {
      isValid = false;
    }
    if (checkedValueSi4 != checkedValueNo4) {
      isValid = true;
    } else {
      isValid = false;
    }
    if (checkedValueSi5 != checkedValueNo5) {
      isValid = true;
    } else {
      isValid = false;
    }
    if (checkedValueSi6 != checkedValueNo6) {
      isValid = true;
    } else {
      isValid = false;
    }
    if (checkedValueSi7 != checkedValueNo7) {
      isValid = true;
    } else {
      isValid = false;
    }
    if (checkedValueSi8 != checkedValueNo8) {
      isValid = true;
    } else {
      isValid = false;
    }
    if (checkedValueSi9 != checkedValueNo9) {
      isValid = true;
    } else {
      isValid = false;
    }
    if (checkedValueSi10 != checkedValueNo10) {
      isValid = true;
    } else {
      isValid = false;
    }
    if (checkedValueSi11 != checkedValueNo11) {
      isValid = true;
    } else {
      isValid = false;
    }
    if (checkedValueSi12 != checkedValueNo12) {
      isValid = true;
    } else {
      isValid = false;
    }
    if (checkedValueSi13 != checkedValueNo13) {
      isValid = true;
    } else {
      isValid = false;
    }
    if (isValid && inputsValid) {
      isValid = true;
    } else {
      isValid = false;
    }
    return isValid;
  }

  Widget customColumn({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(),
            style: const TextStyle(fontSize: 14, color: Colors.white)),
        const Gap(4),
        Text(subtitle,
            style: const TextStyle(fontSize: 18, color: Colors.white)),
      ],
    );
  }

  Future<List> ifTempRecordExist(database, idRegistro) async {
    List row = await database.query('alumnos_pre_temp',
        where: 'id_registro = ?', whereArgs: [idRegistro]);
    if (row.isEmpty) {
      return [];
    } else {
      return row;
    }
  }

  setCheckedValues(Alumno alumnoInfo) {
    //set values from local db
    List valuesChecked = alumnoInfo.respSatisfaccion!.split(',');
    
    if (valuesChecked[0] == 'Si') {
      checkedValueSi1 = true;
      checkedValueNo1 = false;
    } else if (valuesChecked[0] == 'No') {
      checkedValueSi1 = false;
      checkedValueNo1 = true;
    } else {
      checkedValueSi1 = false;
      checkedValueNo1 = false;
    }
    if (valuesChecked[1] == 'Si') {
      checkedValueSi2 = true;
      checkedValueNo2 = false;
    } else if (valuesChecked[1] == 'No') {
      checkedValueSi2 = false;
      checkedValueNo2 = true;
    } else {
      checkedValueSi1 = false;
      checkedValueNo1 = false;
    }
    if (valuesChecked[2] == 'Si') {
      checkedValueSi3 = true;
      checkedValueNo3 = false;
    } else if (valuesChecked[2] == 'No') {
      checkedValueSi3 = false;
      checkedValueNo3 = true;
    } else {
      checkedValueSi1 = false;
      checkedValueNo1 = false;
    }
    if (valuesChecked[3] == 'Si') {
      checkedValueSi4 = true;
      checkedValueNo4 = false;
    } else if (valuesChecked[3] == 'No') {
      checkedValueSi4 = false;
      checkedValueNo4 = true;
    } else {
      checkedValueSi1 = false;
      checkedValueNo1 = false;
    }
    if (valuesChecked[4] == 'Si') {
      checkedValueSi5 = true;
      checkedValueNo5 = false;
    } else if (valuesChecked[4] == 'No') {
      checkedValueSi5 = false;
      checkedValueNo5 = true;
    } else {
      checkedValueSi1 = false;
      checkedValueNo1 = false;
    }
    if (valuesChecked[5] == 'Si') {
      checkedValueSi6 = true;
      checkedValueNo6 = false;
    } else if (valuesChecked[5] == 'No') {
      checkedValueSi6 = false;
      checkedValueNo6 = true;
    } else {
      checkedValueSi1 = false;
      checkedValueNo1 = false;
    }
    if (valuesChecked[6] == 'Si') {
      checkedValueSi7 = true;
      checkedValueNo7 = false;
    } else if (valuesChecked[6] == 'No') {
      checkedValueSi7 = false;
      checkedValueNo7 = true;
    } else {
      checkedValueSi1 = false;
      checkedValueNo1 = false;
    }
    if (valuesChecked[7] == 'Si') {
      checkedValueSi8 = true;
      checkedValueNo8 = false;
    } else if (valuesChecked[7] == 'No') {
      checkedValueSi8 = false;
      checkedValueNo8 = true;
    } else {
      checkedValueSi1 = false;
      checkedValueNo1 = false;
    }
    if (valuesChecked[8] == 'Si') {
      checkedValueSi9 = true;
      checkedValueNo9 = false;
    } else if (valuesChecked[8] == 'No') {
      checkedValueSi9 = false;
      checkedValueNo9 = true;
    } else {
      checkedValueSi1 = false;
      checkedValueNo1 = false;
    }
    if (valuesChecked[9] == 'Si') {
      checkedValueSi10 = true;
      checkedValueNo10 = false;
    } else if (valuesChecked[9] == 'No') {
      checkedValueSi10 = false;
      checkedValueNo10 = true;
    } else {
      checkedValueSi1 = false;
      checkedValueNo1 = false;
    }
    if (valuesChecked[10] == 'Si') {
      checkedValueSi11 = true;
      checkedValueNo11 = false;
    } else if (valuesChecked[10] == 'No') {
      checkedValueSi11 = false;
      checkedValueNo11 = true;
    } else {
      checkedValueSi1 = false;
      checkedValueNo1 = false;
    }
    if (valuesChecked[11] == 'Si') {
      checkedValueSi12 = true;
      checkedValueNo12 = false;
    } else if (valuesChecked[11] == 'No') {
      checkedValueSi12 = false;
      checkedValueNo12 = true;
    } else {
      checkedValueSi1 = false;
      checkedValueNo1 = false;
    }
    if (valuesChecked[12] == 'Si') {
      checkedValueSi13 = true;
      checkedValueNo13 = false;
    } else if (valuesChecked[12] == 'No') {
      checkedValueSi13 = false;
      checkedValueNo13 = true;
    } else {
      checkedValueSi1 = false;
      checkedValueNo1 = false;
    }
  }

  showFormNoCompleted(BuildContext context) {
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
      content: const Text('Faltan algunos campos por rellenar.'),
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
