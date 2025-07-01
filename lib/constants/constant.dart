import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  static const String petSearchEndpoint = 'v1/images/search';
}
