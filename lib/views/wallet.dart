import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_banking_app/models/grupo.dart';
import 'package:flutter_banking_app/repo/repository.dart';
import 'package:flutter_banking_app/utils/iconly/iconly_bold.dart';
import 'package:flutter_banking_app/utils/layouts.dart';
import 'package:flutter_banking_app/utils/styles.dart';

import 'package:flutter_banking_app/views/info_grupo.dart';
import 'package:flutter_banking_app/widgets/my_app_bar.dart';
import 'package:gap/gap.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../widgets/separator.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<String> searchKeywordNotifier = ValueNotifier('');

  late Grupo grupoObject;
  Future<List>? _futureSavedGrupos;

  @override
  void initState() {
    super.initState();
    _futureSavedGrupos = getSaved();
  }

  Future<List> getSaved() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'syvic_offline.db');
    Database database = await openDatabase(path,
        version: 1, onCreate: (Database db, int version) async {});
    List row = await database
        .rawQuery('SELECT * FROM tbl_grupo_temp where is_editing = 1');
    return Future.value(row);
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
                child: Expanded(
                    child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(CupertinoIcons.search),
                      hintText: 'Buscar por clave de grupo'),
                )),
              ),
              Expanded(
                  child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  InfoGrupo(clave: _controller.text),
                            ));
                      },
                      child: CircleAvatar(
                        backgroundColor: Repository.accentColor(context),
                        child: Icon(IconlyBold.Search,
                            color: Repository.textColor(context)),
                        radius: 23,
                      ))),
            ],
          ),
          FutureBuilder(
              future: _futureSavedGrupos,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Column(
                        children: const [
                          // Icon(Icons.error),
                          Text('No existen registros.'),
                        ],
                      );
                    } else {
                      return Column(
                          children: createListView(
                              context, snapshot.data, size, this));
                    }
                }
              }),
        ],
      ),
    );
  }

  List<Widget> createListView(context, dataResponse, size, state) {
    List<Widget> widgetView = [];

    widgetView
        .add(separatorText(context: context, text: 'Vistos recientemente'));
    for (var grupo in dataResponse) {
      widgetView.add(const Gap(15));
      widgetView.add(InkWell(
        onTap: () {
          _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length));
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InfoGrupo(clave: grupo['clave']),
              ));
        },
        child: FittedBox(
          child: SizedBox(
            height: size.height * 0.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width,
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
                        children: <Widget>[
                          Flexible(
                              child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(grupo['curso'],
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 21,
                                          color: Colors.white)))),
                        ],
                      ),
                      const Gap(24),
                      customColumn(title: 'Clave', subtitle: grupo['clave']),
                      const Gap(15)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }

    return widgetView;
  }
}

Widget customColumn({required String title, required String subtitle}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title.toUpperCase(),
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5))),
      const Gap(2),
      Text(subtitle,
          style: TextStyle(fontSize: 19, color: Colors.white.withOpacity(0.8))),
    ],
  );
}
