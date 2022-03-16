import 'package:flutter/cupertino.dart';
import 'package:flutter_banking_app/generated/assets.dart';

List<Map<String, dynamic>> transactions = [
  {
    'icon': CupertinoIcons.house_fill,
    'name': 'Ingles Basico I',
    'date': 'Abierto Ult. Vez. 4:56 PM',
    'amount': '-140'
  },
  {
    'avatar': Assets.dash,
    'name': 'Ingles Basico II',
    'date': 'Abierto Ult. Vez. 5:20 PM',
    'amount': '+100'
  },
  { //Assets.memoji2 for emoji from assets
    'avatar': Assets.memoji1,
    'name': 'Ingles Basico III',
    'date': 'Abierto Ult. Vez. 7:21 PM',
    'amount': '+110'
  },
];
