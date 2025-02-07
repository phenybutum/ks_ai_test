import 'package:google_ml_kit/google_ml_kit.dart';

class FirebaseMLHelper {
  final _languageIdentifier = GoogleMlKit.nlp.languageIdentifier();

  Future<String> detectLanguage(String text) async {
    final language = await _languageIdentifier.identifyLanguage(text);
    await _languageIdentifier.close();

    return "Text language: $language";
  }
}