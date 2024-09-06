// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/services.dart';
// import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:notecheak/main.dart';


// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   _cameras = await availableCameras();
// //   runApp(const CameraScreen());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: CameraScreen(),
// //     );
// //   }
// // }

// class CameraScreen extends StatefulWidget {
//   const CameraScreen({Key? key}) : super(key: key);

//   @override
//   State<CameraScreen> createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   late CameraController controller;
//   CameraImage? img;
//   bool isBusy = false;
//   String result = "results to be shown here";

//   late ImageLabeler imageLabeler;

//   @override
//   void initState() {
//     super.initState();
//     loadCustomModel();
//     initializeCamera();
//   }

//   void initializeCamera() {
//     controller = CameraController(
//       _cameras[0],
//       ResolutionPreset.high,
//       enableAudio: false,
//       imageFormatGroup: Platform.isAndroid
//           ? ImageFormatGroup.nv21 // for Android
//           : ImageFormatGroup.bgra8888,
//     );

//     controller.initialize().then((_) {
//       if (!mounted) return;
//       controller.startImageStream((image) {
//         if (!isBusy) {
//           isBusy = true;
//           img = image;
//           doImageLabeling();
//         }
//       });
//       setState(() {});
//     }).catchError((Object e) {
//       if (e is CameraException) {
//         switch (e.code) {
//           case 'CameraAccessDenied':
//             print('User denied camera access.');
//             break;
//           default:
//             print('Handle other errors.');
//             break;
//         }
//       }
//     });
//   }

//   Future<void> loadCustomModel() async {
//     final modelPath = await getModelPath('assets/ml/Sound_metadata.tflite');
//     final options = LocalLabelerOptions(
//       confidenceThreshold: 0.5,
//       modelPath: modelPath,
//     );
//     imageLabeler = ImageLabeler(options: options);
//   }

//   Future<String> getModelPath(String asset) async {
//     final path = '${(await getApplicationSupportDirectory()).path}/$asset';
//     await Directory(dirname(path)).create(recursive: true);
//     final file = File(path);
//     if (!await file.exists()) {
//       final byteData = await rootBundle.load(asset);
//       await file.writeAsBytes(byteData.buffer
//           .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
//     }
//     return file.path;
//   }

//   void doImageLabeling() async {
//     result = "";

//     InputImage? inputImage = _inputImageFromCameraImage(img!);

//     final List<ImageLabel> labels =
//         await imageLabeler.processImage(inputImage!);

//     for (ImageLabel label in labels) {
//       final String text = label.label;
//       final int index = label.index;
//       final double confidence = label.confidence;
//       result += text + " " + confidence.toStringAsFixed(2) + "\n";
//     }

//     setState(() {
//       result;
//       isBusy = false;
//     });
//   }

//   final Map<DeviceOrientation, int> _orientations = {
//     DeviceOrientation.portraitUp: 0,
//     DeviceOrientation.landscapeLeft: 90,
//     DeviceOrientation.portraitDown: 180,
//     DeviceOrientation.landscapeRight: 270,
//   };

//   InputImage? _inputImageFromCameraImage(CameraImage image) {
//     final camera = _cameras[0];
//     final sensorOrientation = camera.sensorOrientation;
//     InputImageRotation? rotation;

//     if (Platform.isIOS) {
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else if (Platform.isAndroid) {
//       var rotationCompensation =
//           _orientations[controller.value.deviceOrientation];
//       if (rotationCompensation == null) return null;
//       if (camera.lensDirection == CameraLensDirection.front) {
//         rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
//       } else {
//         rotationCompensation =
//             (sensorOrientation - rotationCompensation + 360) % 360;
//       }
//       rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
//     }
//     if (rotation == null) return null;

//     final format = InputImageFormatValue.fromRawValue(image.format.raw);
//     if (format == null ||
//         (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

//     if (image.planes.length != 1) return null;
//     final plane = image.planes.first;

//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(image.width.toDouble(), image.height.toDouble()),
//         rotation: rotation,
//         format: format,
//         bytesPerRow: plane.bytesPerRow,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return Container();
//     }
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           CameraPreview(controller),
//           Container(
//             margin: const EdgeInsets.only(left: 10, bottom: 10),
//             child: Align(
//               alignment: Alignment.bottomLeft,
//               child: Text(
//                 result,
//                 style: const TextStyle(color: Colors.white, fontSize: 25),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
