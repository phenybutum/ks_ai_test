/// Tensorlight Sentiment Analysis

// import 'package:flutter/material.dart';
// import 'tensorflight_semantic_service.dart';
//
// void main() {
//   runApp(SentimentApp());
// }
//
// class SentimentApp extends StatefulWidget {
//   @override
//   _SentimentAppState createState() => _SentimentAppState();
// }
//
// class _SentimentAppState extends State<SentimentApp> {
//   final TextEditingController _controller = TextEditingController();
//   String result = "";
//   final TFLiteHelper sentimentService = TFLiteHelper();
//
//   @override
//   void initState() {
//     super.initState();
//     sentimentService.loadModel();
//     sentimentService.loadVocab();
//   }
//
//   void analyze() async {
//     String sentiment = await sentimentService.analyzeSentiment(_controller.text);
//     setState(() {
//       result = sentiment;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Sentiment Analysis")),
//         body: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             children: [
//               TextField(
//                 controller: _controller,
//                 decoration: InputDecoration(labelText: "Enter text"),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(onPressed: analyze, child: Text("Analyse")),
//               SizedBox(height: 20),
//               Text(result, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

/// Sentiment Analysis (huggingface)
//
// import 'package:flutter/material.dart';
// import 'package:ks_tflite/google_ml_service.dart';
// import 'package:ks_tflite/hugging_face_service.dart';
//
// void main() {
//   runApp(SentimentApp());
// }
//
// class SentimentApp extends StatefulWidget {
//   @override
//   _SentimentAppState createState() => _SentimentAppState();
// }
//
// class _SentimentAppState extends State<SentimentApp> {
//   final TextEditingController _controller = TextEditingController();
//   String resultMood = "";
//   String resultLang = "";
//   final HuggingFaceAPI sentimentService = HuggingFaceAPI();
//   final FirebaseMLHelper mlService = FirebaseMLHelper();
//
//   void analyzeTextLang() async {
//     try {
//       String language = await mlService.detectLanguage(_controller.text);
//       setState(() {
//         resultLang = language;
//       });
//     } catch (e) {
//       setState(() {
//         resultLang = "Error: $e";
//         print(e);
//       });
//     }
//   }
//
//
//   void analyze() async {
//     try {
//       String sentiment = await sentimentService.analyzeSentiment(_controller.text);
//       setState(() {
//         resultMood = sentiment;
//       });
//     } catch (e) {
//       setState(() {
//         resultMood = "Error: $e";
//         print(e);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Hugging Face Sentiment Analysis")),
//         body: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             spacing: 20,
//             children: [
//               TextField(
//                 controller: _controller,
//                 decoration: InputDecoration(labelText: "Enter text"),
//               ),
//               ElevatedButton(onPressed: analyze, child: Text("Analyse Mood")),
//               Text(resultMood, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//               ElevatedButton(onPressed: analyzeTextLang, child: Text("Analyse Language")),
//               Text(resultLang, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

/// Google ml kit


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ks_tflite/face_emotion_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraScreen(),
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  final FaceEmotionDetector _emotionDetector = FaceEmotionDetector();
  String emotion = "Waiting...";

  @override
  void initState() {
    super.initState();
  }

  Future<void> captureImage() async {
    setState(() {
      emotion = "Analyzing...";
    });
    final result = await _emotionDetector.analyzeFace(_image!.path);
    setState(() {
      emotion = result;
    });
  }
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

    if (photo == null) return;

    final File imageFile = File(photo.path);
    final File savedImage = await _saveImage(imageFile);

    setState(() {
      _image = savedImage;
    });
  }

  Future<File> _saveImage(File image) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String fileName = basename(image.path);
    final File newImage = await image.copy('${dir.path}/$fileName');
    return newImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Face emotion detection")),
      body: Column(
        children: [
          Center(
            child: _image == null
                ? const Text("No photo", style: TextStyle(fontSize: 18))
                : Image.file(_image!),
          ),
          ElevatedButton(onPressed: captureImage, child: const Text("Detect emotion")),
          Text(emotion, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePhoto,
        child: const Icon(Icons.camera),
      ),
    );
  }
}

/// Firebase Face Detection

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:ks_tflite/firebase_face_emotion_service.dart';
// import 'dart:io';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(FaceApp());
// }
//
// class FaceApp extends StatefulWidget {
//   @override
//   _FaceAppState createState() => _FaceAppState();
// }
//
// class _FaceAppState extends State<FaceApp> {
//   final ImagePicker _picker = ImagePicker();
//   final FirebaseFaceService _faceService = FirebaseFaceService();
//   File? _selectedImage;
//   String _result = "Take a photo";
//
//   Future<void> pickImage() async {
//     final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile == null) return;
//
//     setState(() {
//       _selectedImage = File(pickedFile.path);
//     });
//
//     await _faceService.detectFace(_selectedImage!);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Face Detection (Firebase)")),
//         body: Column(
//           children: [
//             _selectedImage != null ? Image.file(_selectedImage!) : Placeholder(fallbackHeight: 200),
//             ElevatedButton(onPressed: pickImage, child: Text("Pick photo")),
//             SizedBox(height: 20),
//             Text(_result, style: TextStyle(fontSize: 18)),
//           ],
//         ),
//       ),
//     );
//   }
// }
