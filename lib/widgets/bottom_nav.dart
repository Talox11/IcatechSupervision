import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supervision_icatech/repo/repository.dart';
import 'package:supervision_icatech/utils/iconly/iconly_bold.dart';
import 'package:supervision_icatech/utils/styles.dart';
import 'package:supervision_icatech/views/home.dart';
import 'package:supervision_icatech/views/list_cursos.dart';


import 'package:supervision_icatech/views/test_query.dart';
import 'package:supervision_icatech/views/downloaded_cursos.dart';


/// This is the stateful widget that the main application instantiates.
class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _BottomNavState extends State<BottomNav> {
  String nombre = '';
  String email_sivic = '';
  int id_sivic = 0;
  late SharedPreferences sharedPreferences;


  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const Home(),
    const DownloadCursos(),
    const CursosDescargados(),
    const TestQuery(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
      checkSesion();
      super.initState();
      // inicializarNotificacion();
  }
  void checkSesion() async {
      sharedPreferences = await SharedPreferences.getInstance();
      
      id_sivic = sharedPreferences.getInt('id_sivyc')!;
      email_sivic = sharedPreferences.getString('correo')!;
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Repository.navbarColor(context),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedLabelStyle: TextStyle(fontSize: 20, color: Styles.primaryColor),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Styles.icatechGoldColor,
        unselectedItemColor: Colors.grey.withOpacity(0.7),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(IconlyBold.Home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyBold.Document),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyBold.Document),
            label: 'Wallet',
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
