import 'package:flutter/material.dart';
import 'package:supervision_icatech/utils/size_config.dart';

class Styles {
  static Color primaryColor = const Color(0xFF161D28);
  static Color accentColor = const Color(0xFF030C10);
  static Color primaryWithOpacityColor = const Color(0xFF212E3E);
  static Color yellowColor = const Color(0xFFDFE94B);
  static Color greenColor = const Color(0xFF024751);
  static Color greyColor = const Color(0xFFE6E8E8);
  static Color whiteColor = Colors.white;
  static Color buttonColor = const Color(0xFF4C66EE);
  static Color blueColor = const Color(0xFF4BACF7);
  static Color icatechGoldColor = Color.fromARGB(255, 178, 158, 90);
  static Color icatechGrayColor = Color.fromARGB(255, 49, 53, 55);
  static Color icatechPurpleColor = Color.fromARGB(255, 97, 16, 48);
  static TextStyle textStyle =
      TextStyle(fontSize: getProportionateScreenWidth(15));
  static TextStyle titleStyle = TextStyle(
      fontFamily: 'DMSans',
      fontSize: getProportionateScreenWidth(19),
      fontWeight: FontWeight.w500);
}
