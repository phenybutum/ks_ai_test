import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FirebaseFaceService {
  final String apiKey = "token";

  Future<void> detectFace(File imageFile) async {
    final String base64Image = base64Encode(await imageFile.readAsBytes());
    final Uri url = Uri.parse("https://vision.googleapis.com/v1/images:annotate?key=$apiKey");

    final Map<String, dynamic> requestBody = {
      "requests": [
        {
          "image": {"content": base64Image},
          "features": [{"type": "FACE_DETECTION"}]
        }
      ]
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(" Answer:");
      print(jsonEncode(jsonResponse));
    } else {
      print(" Error: ${response.body}");
    }
  }
}