
import 'dart:convert';
import 'package:http/http.dart' as http;

class HuggingFaceAPI {
  // final String apiKey = "token";

  Future<String> analyzeSentiment(String text) async {
    final url = Uri.parse("https://api-inference.huggingface.co/models/cardiffnlp/twitter-roberta-base-sentiment");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer apikey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"inputs": text}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String label = data[0][0]["label"];

      if (label == "LABEL_0") return "Negative";
      if (label == "LABEL_1") return "Neutral";
      if (label == "LABEL_2") return "Positive";

      return "Unknown result";
    } else {
      print("Error Hugging Face: ${response.body}");
      throw Exception("Error Hugging Face: ${response.statusCode}");
    }
  }
}