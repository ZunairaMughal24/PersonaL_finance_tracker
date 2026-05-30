import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get geminiApiKey => dotenv.get('GEMINI_API_KEY', fallback: '');
}
