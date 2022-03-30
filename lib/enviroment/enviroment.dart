import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName => kReleaseMode ? '.env.production' : '.env.development';
  static String get apiUrl => dotenv.env['API_URL'] ?? 'MY_FALLBACK';
  static String get dbUsername => dotenv.env['DB_USERNAME'] ?? 'root';
  static String get dbHost => dotenv.env['DB_HOST'] ?? '10.0.2.2';
  static String get dbPassword => dotenv.env['DB_PASSWORD'] ?? '';
  static String get dbDatabase => dotenv.env['DB_DATABASE'] ?? 'wwicat_db_auditoria';
  static String get dbPort => dotenv.env['DB_PORT'] ?? '3306';
}