import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banking_app/models/salumnomodel.dart';
import 'package:flutter_banking_app/views/info_alumno.dart';
import 'package:flutter_banking_app/widgets/buttons.dart';
import 'package:flutter_banking_app/widgets/default_text_field.dart';
import 'package:flutter_banking_app/widgets/my_app_bar.dart';
import 'package:flutter_banking_app/repo/repository.dart';
import 'package:flutter_banking_app/utils/layouts.dart';
import 'package:flutter_banking_app/utils/styles.dart';
import 'package:flutter_banking_app/generated/assets.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../utils/size_config.dart';

class InfoAlumno extends StatefulWidget {
  final String curp;
  const InfoAlumno({Key? key, required this.curp}) : super(key: key);

  @override
  State<InfoAlumno> createState() => _InfoAlumnoState();
}

class _InfoAlumnoState extends State<InfoAlumno> {
  final TextEditingController _cardHolderName = TextEditingController();
  final TextEditingController _cardNumber = TextEditingController();

  List paymentCardsList = [
    Assets.cardsVisa,
    Assets.cardsMastercard,
    Assets.cardsPaypal,
    // Assets.cardsSkrill
  ];
  late Future<List> _futureDatosAlumno;

  Future<List> _getInfoAlumno() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:5000/info/alumno/${widget.curp}'));

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      return jsonData;
    } else {
      throw Exception('Falló la conexión');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureDatosAlumno = _getInfoAlumno();
  }

  int selectedCard = 0;
  @override
  Widget build(BuildContext context) {
    final size = Layouts.getSize(context);
    final cardSize = size.height * 0.23;
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      appBar: myAppBar(
          title: 'Informacion Alumno', implyLeading: true, context: context),
      body: FutureBuilder(
          future: _futureDatosAlumno,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                padding: const EdgeInsets.all(15),
                children: _showInfo(snapshot.data, cardSize, context, this),
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

  Widget customColumn({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: const TextStyle(fontSize: 12)),
        const Gap(4),
        Text(subtitle, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}

List<Widget> _showInfo(dataResponse, cardSize, context, state) {
  print(dataResponse);
  List<Widget> alumno = [];
  var data = dataResponse[0];
  final TextEditingController _cardHolderName = TextEditingController();
  final TextEditingController _cardNumber = TextEditingController();

  final f = new DateFormat('yyyy-MM-dd');

  List paymentCardsList = [
    Assets.cardsVisa,
    Assets.cardsMastercard,
    Assets.cardsPaypal,
    // Assets.cardsSkrill
  ];

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
              color: Styles.greenColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Image.asset(Assets.cardsVisaWhite,
                //     width: 60, height: 45, fit: BoxFit.cover),
                Text(data['nombre'],
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
              color: Styles.yellowColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customColumn(title: 'Matricula', subtitle: data['matricula']),
                const Spacer(),
                Row(
                  children: [
                    customColumn(
                        title: 'Fecha Nacimiento',
                        subtitle: data['fecha_nacimiento']),
                    const Gap(40),
                    customColumn(title: 'Sexo', subtitle: data['sexo'])
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
  alumno.add(
    const Gap(20),
  );

  alumno.add(const Gap(30));
  alumno.add(
    DefaultTextField(controller: _cardHolderName, title: data['domicilio']),
  );

  alumno.add(DefaultTextField(
      controller: _cardNumber, title: 'Estado', label: data['estado']));
  alumno.add(
    Row(
      children: [
        Flexible(
          child: DefaultTextField(
              controller: _cardNumber,
              title: 'Correo',
              label: data['correo'] ?? 'Sin correo electronico'),
        ),
        const Gap(10),
        Flexible(
          child: DefaultTextField(
              controller: _cardNumber,
              title: 'Telefono',
              label: data['telefono'] ?? 'Sin numero telefono',
              obscure: true),
        ),
      ],
    ),
  );
  alumno.add(const Gap(10));

  alumno.add(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
            child: Text('¿EL TRAMITE DE INSCRIPCION AL CURSO FUE FACIL?',
                style: TextStyle(color: Repository.subTextColor(context)))),
        Divider(
          color: Repository.dividerColor(context),
          thickness: 2,
        ),
        Container(padding: const EdgeInsets.fromLTRB(20, 25, 20, 0)),
      ],
    ),
  );

  bool? checkedValue = false;
  alumno.add(CheckboxListTile(
    title: const Text("SI'"),
    value: checkedValue,
    onChanged: (newValue) {
      state.setState(() {
        checkedValue = newValue;
      });
    },
    controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
  ));
  alumno.add(CheckboxListTile(
    title: const Text("NO'"),
    value: checkedValue,
    onChanged: (newValue) {
      state.setState(() {
        checkedValue = newValue;
      });
    },
    controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
  ));

  alumno.add(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
            child: Text('¿LA CUOTA DE RECUPERACION AL CURSO FUE ACEPTABLE?',
                style: TextStyle(color: Repository.subTextColor(context)))),
        Divider(
          color: Repository.dividerColor(context),
          thickness: 2,
        ),
        Container(padding: const EdgeInsets.fromLTRB(20, 25, 20, 0)),
      ],
    ),
  );
  bool? checkedValue2 = false;
  alumno.add(CheckboxListTile(
    title: const Text("SI'"),
    value: checkedValue2,
    onChanged: (newValue) {
      state.setState(() {
        checkedValue2 = newValue;
      });
    },
    controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
  ));
  alumno.add(CheckboxListTile(
    title: const Text("NO'"),
    value: checkedValue2,
    onChanged: (newValue) {
      state.setState(() {
        checkedValue2 = newValue;
      });
    },
    controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
  ));

  alumno.add(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
            child: Text(
                '¿RECOMENDARIAS A TUS FAMILIARES Y AMIGOS A CAPACITARSE EN EL ICATECH?',
                style: TextStyle(color: Repository.subTextColor(context)))),
        Divider(
          color: Repository.dividerColor(context),
          thickness: 2,
        ),
        Container(padding: const EdgeInsets.fromLTRB(20, 25, 20, 0)),
      ],
    ),
  );
  bool? checkedValue3 = false;
  alumno.add(CheckboxListTile(
    title: const Text("SI'"),
    value: checkedValue3,
    onChanged: (newValue) {
      state.setState(() {
        checkedValue3 = newValue;
      });
    },
    controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
  ));
  alumno.add(CheckboxListTile(
    title: const Text("NO'"),
    value: checkedValue3,
    onChanged: (newValue) {
      state.setState(() {
        checkedValue3 = newValue;
      });
    },
    controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
  ));

  alumno.add(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
            child: Text(
                '¿TE PARECE BIEN LOS CURSOS A DISTANCIA?',
                style: TextStyle(color: Repository.subTextColor(context)))),
        Divider(
          color: Repository.dividerColor(context),
          thickness: 2,
        ),
        Container(padding: const EdgeInsets.fromLTRB(20, 25, 20, 0)),
      ],
    ),
  );

  bool? checkedValue4 = false;
  alumno.add(CheckboxListTile(
    title: const Text("SI'"),
    value: checkedValue4,
    onChanged: (newValue) {
      state.setState(() {
        checkedValue4 = newValue;
      });
    },
    controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
  ));
  alumno.add(CheckboxListTile(
    title: const Text("NO'"),
    value: checkedValue4,
    onChanged: (newValue) {
      state.setState(() {
        checkedValue4 = newValue;
      });
    },
    controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
  ));

  
  alumno.add(elevatedButton(
    color: Repository.selectedItemColor(context),
    context: context,
    callback: () {},
    text: 'Guardar',
  ));

  return alumno;
}

Widget customColumn({required String title, required String subtitle}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title.toUpperCase(), style: const TextStyle(fontSize: 12)),
      const Gap(4),
      Text(subtitle, style: const TextStyle(fontSize: 16)),
    ],
  );
}
