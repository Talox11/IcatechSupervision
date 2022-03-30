import 'package:flutter_banking_app/enviroment/enviroment.dart';
import 'package:mysql1/mysql1.dart';

dbSettings() {
  var settings = ConnectionSettings(
      host: Environment.dbHost,
      port: int.parse(Environment.dbPort),
      user: Environment.dbUsername,
      db: Environment.dbDatabase);
  return settings;
}
