import 'package:google_ml_kit/google_ml_kit.dart';

class FaceEmotionDetector {
  final FaceDetector _faceDetector = GoogleMlKit.vision.faceDetector(
    FaceDetectorOptions(enableClassification: true,  // Allows detecting emotions
      enableLandmarks: true,       // Allows detecting landmarks
      enableContours: true,        // Allows detecting contours
      minFaceSize: 0.1,            // Min face size
        performanceMode: FaceDetectorMode.accurate,  //  More accurate (but slower)
      ),
  );

  Future<String> analyzeFace(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final List<Face> faces = await _faceDetector.processImage(inputImage);

    if (faces.isEmpty) {
      print("ML Kit didn't find any face");
      return "Face not detected ";
    }

    final face = faces.first;

    // Print the face details
    print(" face detected!");
    print(" smile: ${face.smilingProbability}");
    print(" left eye opened: ${face.leftEyeOpenProbability}");
    print(" right eye opened: ${face.rightEyeOpenProbability}");
    print(" borders: ${face.boundingBox}");

    if (faces.isEmpty) return "No face detected";

    if (face.smilingProbability != null && face.smilingProbability! > 0.7) {
      return "Happy";
    } else if (face.smilingProbability != null && face.smilingProbability! < 0.3) {
      return "Sad";
    } else {
      return "Neutral";
    }
  }
}
