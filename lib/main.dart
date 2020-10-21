import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:path/path.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File pickedImage;
  var imageFile;
  List<Rect> rect = new List<Rect>();

  bool isFaceDetected = false;

  Future pickImage() async {
    var awaitImage = await ImagePicker().getImage(
        source: ImageSource.gallery);
    print("image file type ${awaitImage.runtimeType}");
    // final appDir = await pPath.getApplicationDocumentsDirectory();
    // final fileName = path.basename(imageFile.path);
    // final savedImage = await File(imageFile.path).copy('${appDir.path}/$fileName');

    imageFile = await awaitImage.readAsBytes();
    imageFile = await decodeImageFromList(imageFile);

    setState(() {
      imageFile = imageFile;
      pickedImage = File(awaitImage.path);
    });
    print("image file type ${pickedImage.runtimeType}");
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(pickedImage);
    // final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFilePath(savedImage.toString());
    final faceDetector = FirebaseVision.instance.faceDetector(FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
        enableLandmarks: true,
        enableClassification: true
    ));
    // final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();
    var beforeTime = new DateTime.now();
    final List<Face> faces = await faceDetector.processImage(visionImage);
    print('Processing time: ' +
        DateTime.now().difference(beforeTime).inMilliseconds.toString());
    print(faces.length.toString());
    if (rect.length > 0) {
      rect = new List<Rect>();
    }
    for (Face face in faces) {
      rect.add(face.boundingBox);


      final double rotY =
          face.headEulerAngleY; // Head is rotated to the right rotY degrees
      final double rotZ =
          face.headEulerAngleZ; // Head is tilted sideways rotZ degrees
      print('the rotation y is ' + rotY.toStringAsFixed(2));
      print('the rotation z is ' + rotZ.toStringAsFixed(2));
    }

    setState(() {
      isFaceDetected = true;
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(pickedImage.path);

    StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(pickedImage);

    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    print('ll');
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tonton with Mask'),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 50.0),
          isFaceDetected
              ? Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(blurRadius: 20),
                ],
              ),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: FittedBox(
                child: SizedBox(
                  width: imageFile.width.toDouble(),
                  height: imageFile.height.toDouble(),
                  child: CustomPaint(
                    painter:
                    FacePainter(rect: rect, imageFile: imageFile),
                  ),
                ),
              ),
            ),
          )
              : Container(),
          FloatingActionButton(
            backgroundColor: Colors.indigo,
            child: Icon(
              Icons.photo_camera,
            ),
            onPressed: () async {
              pickImage();
            },
          ),
          FloatingActionButton(
            backgroundColor: Colors.indigo,
            child: Icon(
              Icons.upload_file,
            ),
            onPressed: () => uploadImageToFirebase(context)
          ),
        ],
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  List<Rect> rect;
  var imageFile;

  FacePainter({@required this.rect, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {

      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    for (Rect rectangle in rect) {
      canvas.drawRect(
        rectangle,
        Paint()
          ..color = Colors.teal
          ..strokeWidth = 6.0
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}