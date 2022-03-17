

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banking_app/generated/assets.dart';

import 'package:flutter_banking_app/models/grupo.dart';
import 'package:flutter_banking_app/repo/repository.dart';
import 'package:flutter_banking_app/utils/iconly/iconly_bold.dart';
import 'package:flutter_banking_app/utils/layouts.dart';
import 'package:flutter_banking_app/utils/styles.dart';

import 'package:flutter_banking_app/views/info_grupo.dart';
import 'package:flutter_banking_app/widgets/my_app_bar.dart';
import 'package:gap/gap.dart';



class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<String> searchKeywordNotifier = ValueNotifier('');

  late Grupo grupoObject;


  @override
  void initState() {
    super.initState();
    // _futureGrupo = _getGrupo('NONE');
  }

  @override
  Widget build(BuildContext context) {
    final size = Layouts.getSize(context);
    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      appBar: myAppBar(
          title: 'Realizar Nueva Auditoria',
          implyLeading: false,
          context: context),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 38,
                width: size.width * 0.70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19),
                  color: Styles.greyColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(CupertinoIcons.search),
                      hintText: 'Buscar por clave de grupo'),
                ),
              ),
              MaterialButton(
                  onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InfoGrupo(clave: _controller.text),
                      ));
                  },
                  child: CircleAvatar(
                    backgroundColor: Repository.accentColor(context),
                    child: Icon(IconlyBold.Search,
                        color: Repository.textColor(context)),
                    radius: 23,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

List<Widget> _showInfo(dataResponse, size, context) {
  print('hellos');
  List<Widget> widget = [];
  // List<Alumno> data = dataResponse;
// Row(
//   children: [
//     Icon(Icons.arrow_back),
//     Expanded(child: SizedBox()),
//     Icon(Icons.account_box),
//     Flexible(
//     child:
//     Text("Some Text Here and here and here and here and more and more and more and more and more and more ", maxLines: 1)), // ➜ This is the text.
//     Expanded(child: SizedBox()),
//     Icon(Icons.arrow_forward),
//   ],
// )
  widget.add(
    Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Repository.headerColor2(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(Assets.cardsVisaWhite,
                  width: 60, height: 45, fit: BoxFit.cover),
              const Padding(
                padding: EdgeInsets.only(top: 20, right: 5),
                child: Text('2.00 DHS',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                        color: Colors.white)),
              ),
            ],
          ),
          const Gap(24),
          customColumn(title: 'CARD NUMBER', subtitle: '3829 4820 4629 5025'),
          const Gap(15)
        ],
      ),
    ),
  );

  widget.add(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
            child: Text('Alumnos inscritos a este grupo',
                style: TextStyle(color: Repository.subTextColor(context)))),
        Divider(
          color: Repository.dividerColor(context),
          thickness: 2,
        ),
        Container(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
            child: Text('20.00 DHS',
                style: TextStyle(
                    color: Repository.titleColor(context),
                    fontSize: 32,
                    fontWeight: FontWeight.bold))),
      ],
    ),
  );
  // for (var item in data) {
  //   widget.add(
  //     InkWell(
  //       onTap: () {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => InfoAlumno(curp: item.curp),
  //             ));
  //       },
  //       child: FittedBox(
  //         child: SizedBox(
  //           height: size.height * 0.23,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Container(
  //                 width: size.width * 0.67,
  //                 padding: const EdgeInsets.fromLTRB(16, 10, 0, 20),
  //                 decoration: BoxDecoration(
  //                   borderRadius: const BorderRadius.horizontal(
  //                       left: Radius.circular(15)),
  //                   color: Styles.greenColor,
  //                 ),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     // Image.asset(Assets.cardsVisaYellow,
  //                     //     width: 60, height: 50, fit: BoxFit.cover),
  //                     Text(item.nombre,
  //                         style: const TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 32,
  //                             color: Colors.white)),
  //                     const Gap(20),
  //                     Text('CURP',
  //                         style: TextStyle(
  //                             color: Colors.white.withOpacity(0.5),
  //                             fontSize: 12)),
  //                     const Gap(5),
  //                     Text(item.curp,
  //                         style: const TextStyle(
  //                             color: Colors.white, fontSize: 15)),
  //                   ],
  //                 ),
  //               ),
  //               Container(
  //                 width: size.width * 0.27,
  //                 padding: const EdgeInsets.fromLTRB(20, 10, 0, 20),
  //                 decoration: BoxDecoration(
  //                   borderRadius: const BorderRadius.horizontal(
  //                       right: Radius.circular(15)),
  //                   color: Styles.yellowColor,
  //                 ),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Container(
  //                       padding: const EdgeInsets.all(10),
  //                       margin: const EdgeInsets.only(top: 10),
  //                       decoration: BoxDecoration(
  //                         shape: BoxShape.circle,
  //                         color: Styles.greenColor,
  //                       ),
  //                       child: const Icon(Icons.swipe_rounded,
  //                           color: Colors.white, size: 20),
  //                     ),
  //                     const Spacer(),
  //                     const Text('Matricula', style: TextStyle(fontSize: 12)),
  //                     const Gap(5),
  //                     Text(item.matricula, style: TextStyle(fontSize: 15)),
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  return widget;
}

Widget customColumn({required String title, required String subtitle}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title.toUpperCase(),
          style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.5))),
      const Gap(2),
      Text(subtitle,
          style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8))),
    ],
  );
}
