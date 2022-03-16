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
import 'package:http/http.dart' as http;

import '../utils/size_config.dart';

class AlumnoDetail extends StatefulWidget {
  @override
  _AlumnoDetailState createState() => _AlumnoDetailState();
}

class _AlumnoDetailState extends State<AlumnoDetail> {
  final TextEditingController _cardHolderName = TextEditingController();
  final TextEditingController _cardNumber = TextEditingController();
  List paymentCardsList = [
    Assets.cardsVisa,
    Assets.cardsMastercard,
    Assets.cardsPaypal,
    // Assets.cardsSkrill
  ];
  late Future<List<Alumno>> _listadoAlumno;

  Future<List<Alumno>> _getAlumnos() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/curso/223850032'));

    List<Alumno> alumnos = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData['rows']) {
        alumnos.add(Alumno(
          item['nombre'],
          item['curp'],
          item['matricula'],
          item['id '],
          item['apellidoPaterno '],
          item['apellidoMaterno '],
          item['correo '],
          item['telefono '],
          item['sexo '],
          item['fechaNacimiento '],
          item['domicilio '],
          item['colonia '],
          item['estado ']));
      }
      return alumnos;
    } else {
      throw Exception('Falló la conexión');
    }
  }

  @override
  void initState() {
    super.initState();
    _listadoAlumno = _getAlumnos();
  }

  int selectedCard = 0;
  @override
  Widget build(BuildContext context) {
    final size = Layouts.getSize(context);
    final cardSize = size.height * 0.23;
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      appBar: myAppBar(title: 'Informacion Alumno', implyLeading: true, context: context),
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
                    color: Styles.greenColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(Assets.cardsVisaWhite,
                          width: 60, height: 45, fit: BoxFit.cover),
                      const Text('\$00.00',
                          style: TextStyle(
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
                    color: Styles.yellowColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customColumn(
                          title: 'CARD NUMBER',
                          subtitle: '**** **** **** ****'),
                      const Spacer(),

                      Row(
                        children: [
                          customColumn(
                              title: 'CARD HOLDER NAME', subtitle: 'N/A'),
                          const Gap(40),
                          customColumn(title: 'VALID', subtitle: 'N/A')
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: paymentCardsList.map<Widget>((paymentCard) {
              return MaterialButton(
                elevation: 0,
                color: Repository.accentColor(context),
                minWidth: 70,
                height: 100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(paymentCard),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const Gap(15),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 700),
                      child: Icon(
                        selectedCard == paymentCardsList.indexOf(paymentCard)
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: selectedCard ==
                                paymentCardsList.indexOf(paymentCard)
                            ? Repository.selectedItemColor(context)
                            : Colors.white.withOpacity(0.5),
                      ),
                    )
                  ],
                ),
                onPressed: () {
                  setState(() {
                    selectedCard = paymentCardsList.indexOf(paymentCard);
                  });
                },
              );
            }).toList(),
          ),
          const Gap(30),
          DefaultTextField(
              controller: _cardHolderName, title: 'Card Holder Name'),
          DefaultTextField(
              controller: _cardNumber,
              title: 'Card Number',
              label: '5632-1587-536-256'),
          Row(
            children: [
              Flexible(
                child: DefaultTextField(
                    controller: _cardNumber,
                    title: 'Expiry date',
                    label: '05/2022'),
              ),
              const Gap(10),
              Flexible(
                child: DefaultTextField(
                    controller: _cardNumber,
                    title: 'CVC/CVV',
                    label: '******',
                    obscure: true),
              ),
            ],
          ),
          const Gap(10),
          elevatedButton(
            color: Repository.selectedItemColor(context),
            context: context,
            callback: () {},
            text: 'Add Card',
          )
        ],
      ),
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

List<Widget> _showInfo(dataResponse, size, context) {
  List<Widget> alumnos = [];
  List<Alumno> data = dataResponse;

  for (var item in data) {
    alumnos.add(
      InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InfoAlumno(curp: item.curp),
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
                      Text(item.nombre,
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
                      Text(item.curp,
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
                      Text(item.matricula, style: TextStyle(fontSize: 15)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  return alumnos;
}
