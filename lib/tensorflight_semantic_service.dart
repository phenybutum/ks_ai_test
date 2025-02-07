import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteHelper {
  late Interpreter interpreter;
  late Map<String, int> vocab;

  /// loading the model

  Future<void> loadModel() async {
    try {
      var options = InterpreterOptions();
      options.threads = 1; // for better performance

      interpreter = await Interpreter.fromAsset(
        'assets/bert_model.tflite',
        options: options,
      );
      print("TensorFlow Lite model loaded successfully");
    } catch (e) {
      print("error while loading model $e");
    }
  }

  /// loading vocab.txt
  Future<void> loadVocab() async {
    try {
      String vocabData = await rootBundle.loadString('assets/vocab.txt');
      List<String> words = LineSplitter.split(vocabData).toList();
      vocab = {for (var i = 0; i < words.length; i++) words[i]: i};
      print("success: (${vocab.length} words)");
    } catch (e) {
      print("error $e");
    }
  }

  /// tokenization
  List<int> tokenizeInputText(String text) {
    List<int> tokens = [];
    for (var word in text.split(" ")) {
      tokens.add(vocab[word] ?? 0); // if the word is absent == [UNK]
    }
    return tokens;
  }

  /// checking the mood
  Future<String> analyzeSentiment(String text) async {
    var input = tokenizeInputText(text);
    var output = List.filled(2, 0).reshape([1, 2]); // two classes: negative and positive

    interpreter.run(input, output);

    return output[0][0] > output[0][1] ? "Negative" : "Positive";
  }
}