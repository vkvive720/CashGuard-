import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:notecheak/Model/fakemodel.dart';
import 'package:notecheak/Model/userModel.dart';
import 'package:notecheak/main.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:flutter_tts/flutter_tts.dart';

import 'package:croppy/croppy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notecheak/helper/helper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageUploadScreen extends StatefulWidget {
  final UserModel userModel;
  ImageUploadScreen({
    super.key,
    required this.userModel,
  });

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadcoustomModel();
    loadcoustomModel2();
  }

  //----------text recog---------------------//

  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  //----------text recog---------------------//

  File? _image;
  final ImagePicker _picker = ImagePicker();
  late final InputImage inputImage;

  String ans = "0";
  String note = "0";
  late ImageLabeler imageLabeler;
  late ImageLabeler imageLabeler2;
  String? rbi;

  // File? imageFile;
  File? strip;
  File? devnagri;
  File? mahatmagandhi;
  File? hindilevel;
  File? englishlevel;
  File? increasingtextleft;
  File? increasingtextright;
  File? greenfivehundred;
  File? ashokapillar;
  File? fivelineleft;
  File? fivelineright;

  bool? strip1;
  bool? devnagri1;
  bool? mahatmagandhi1;
  bool? hindilevel1;
  bool? englishlevel1;
  bool? increasingtextleft1;
  bool? increasingtextright1;
  bool? greenfivehundred1;
  bool? ashokapillar1;
  bool? fivelineleft1;
  bool? fivelineright1;

  String inrltt = "";

  void fake() async {
    FakeModel fakeuser = FakeModel(
        uid: widget.userModel.uid,
        email: widget.userModel.email,
        fullname: "",
        currency: note,
        notenumber: inrltt);

    await FirebaseFirestore.instance
        .collection(note)
        .doc(widget.userModel.uid)
        .set(fakeuser.toMap());
  }

  //-----------------------speaker------------------------
  // final FlutterTts flutterTts = FlutterTts();

  Audio audio = Audio.load('assets/audio/500.mp3');
  //-----------------------speaker------------------------

  //------------selecting image----------------
  // void selectImage() async {
  //   XFile? pickedFile =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     print("cooking-------------------------------");

  //     // cropImage(pickedFile, context);
  //     scanDocument();
  //   }
  // }
  //------------selecting image----------------

  //------------selecting image----------------

  // void cropImage(XFile file, context) async {
  //   CroppedFile? croppedImage = await ImageCropper().cropImage(
  //     sourcePath: file.path,
  //     // aspectRatio:
  //     //     const CropAspectRatio(ratioX: 1, ratioY: 1), //1:1 give squre photo
  //     // compressQuality: 30,

  //     uiSettings: [
  //       AndroidUiSettings(
  //         showCropGrid: true,
  //         lockAspectRatio: false,
  //         toolbarTitle: "Image cropper",
  //       ),
  //     ],
  //   );

  //   if (croppedImage != null) {
  //     setState(() {
  //       _image = File(croppedImage.path);
  //     });
  //   }
  // }
//-------------------_----cropping-----------------------------------_----
  Future<void> scanDocument() async {
    try {
      final doc = FlutterDocScanner();

      final Map<dynamic, dynamic> result = await doc.getScanDocumentsUri();
      print("------------------------------");

      print(result.runtimeType);
      print(result.toString());
      if (result != null) {
        print("------------------------------");

        String uriString = result['Uri'];

// Example of manual extraction if the format is fixed
        String? imageUri = uriString.substring(
          uriString.indexOf('imageUri=') + 16,
          uriString.indexOf(
            '}',
            uriString.indexOf('imageUri='),
          ),
        );

        print(imageUri);
        print("------------------------------");

        setState(() {
          _image = File(imageUri);

          strip = _image;
          devnagri = _image;
          mahatmagandhi = _image;
          hindilevel = _image;
          englishlevel = _image;

          increasingtextleft = _image;
          increasingtextright = _image;
          greenfivehundred = _image;
          ashokapillar = _image;
          fivelineleft = _image;
          fivelineright = _image;
          print(
            _image!.path.toString(),
          );
          cropparts();
        });
      }
    } catch (e) {
      print("------------------------------");
      print('Error scanning document: $e');
      // Handle the error, e.g., show a user-friendly message
    }
  }

  //-------------------_----cropping-----------------------------------_----

  void ocr() async {
    // InputImage inputImage = InputImage.fromFile(_image!);
    // InputImage hl = InputImage.fromFile(hindilevel!);
    InputImage el = InputImage.fromFile(englishlevel!);
    InputImage inrl = InputImage.fromFile(increasingtextleft!);
    // InputImage inrr = InputImage.fromFile(increasingtextright!);
    // InputImage gfh = InputImage.fromFile(greenfivehundred!);
    // final RecognizedText recognizedText =
    //     await textRecognizer.processImage(inputImage);
    // final RecognizedText hlt = await textRecognizer.processImage(hl);
    final RecognizedText elt = await textRecognizer.processImage(el);
    final RecognizedText inrlt = await textRecognizer.processImage(inrl);
    // final RecognizedText inrrt = await textRecognizer.processImage(inrr);
    // final RecognizedText gfht = await textRecognizer.processImage(gfh);
    // String text = recognizedText.text;
    // print(text);
    print("-----------------------------");
    // print(hlt.text);
    print(elt.text.substring(0, 21));
    print(inrlt.text);
    setState(() {
      rbi = elt.text.substring(0, 21);
      inrltt = inrlt.text;
    });
    // print(inrlt.text);
    // print(inrrt.text);
    // print(gfht.text);
    //print(text);

    print("-----------------------------");
  }

  //----------text recog---------------------//

  //----------text recog---------------------//

  //_________________ cropping parts - _ - _ - _ - _ - _ - _ - _ - _ -

  void cropparts() async {
    strip = await Helper.autocropImage(
        h: 1, w: .12, x: 0.6, y: 0, imageFile: strip!, name: "strip");

    devnagri = await Helper.autocropImage(
        h: 0.4,
        w: .2,
        x: 0.15,
        y: 0.33,
        imageFile: devnagri!,
        name: "devnagri");

    mahatmagandhi = await Helper.autocropImage(
        h: 1,
        w: .3,
        x: 0.4,
        y: 0.3,
        imageFile: mahatmagandhi!,
        name: "mahatmagandhi");

    hindilevel = await Helper.autocropImage(
        h: 0.3,
        w: .3,
        x: 0.1,
        y: 0,
        imageFile: hindilevel!,
        name: "hinindilevel");

    englishlevel = await Helper.autocropImage(
        h: 0.3,
        w: .43,
        x: 0.96,
        y: 0,
        imageFile: englishlevel!,
        name: "englishlevel");

    increasingtextleft = await Helper.autocropImage(
        h: 0.25,
        w: .1,
        x: 0.67,
        y: 0.59,
        imageFile: increasingtextleft!,
        name: "increasingtextleft");

    increasingtextright = await Helper.autocropImage(
        h: 0.6,
        w: .35,
        x: 0.9,
        y: 0.7,
        imageFile: increasingtextright!,
        name: "increasingtextright");

    greenfivehundred = await Helper.autocropImage(
        h: 0.25,
        w: .2,
        x: 0.87,
        y: 0.59,
        imageFile: greenfivehundred!,
        name: "greenfivehundred");

    ashokapillar = await Helper.autocropImage(
        h: 0.5,
        w: .2,
        x: 0.98,
        y: 0.5,
        imageFile: ashokapillar!,
        name: "ashokapillar");

    fivelineleft = await Helper.autocropImage(
        h: 1,
        w: .1,
        x: 0,
        y: 0,
        imageFile: fivelineleft!,
        name: "fivelineleft");

    fivelineright = await Helper.autocropImage(
        h: 1,
        w: .25,
        x: 1,
        y: 0,
        imageFile: fivelineright!,
        name: "fivelineright");

    setState(() {
      devnagri;
      strip;
      mahatmagandhi;
      hindilevel;
      englishlevel;

      increasingtextleft;
      increasingtextright;
      greenfivehundred;
      ashokapillar;
      fivelineleft;
      doimagelebelling();
      doimagelebelling2();
      ocr();
    });
  }

  //_________________ cropping parts - _ - _ - _ - _ - _ - _ - _ - _ -

  Future<void> _uploadImage() async {
    if (_image == null) return;

    // final uri = Uri.parse('http://10.0.2.2:4000/upload');
    //var uri = Uri.parse('http://192.168.1.103:4000/upload');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        _image!.path,
        contentType:
            MediaType('image', 'jpeg'), // Adjust based on the image type
      ))
      ..fields['currency'] = note;
    ;

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      print('Response: $responseData');

      final Map<dynamic, dynamic> detect = jsonDecode(responseData);
      //final List<dynamic> feture = jsonDecode(detect["result"]);
      print("------------------------------");
      print(detect["result"]["1"]);
      print(detect["result"]["1"].runtimeType);
      print("------------------------------");

      //strip1 = detect["result"]["1"];
      devnagri1 = detect["result"]["1"];
      //mahatmagandhi1 = detect["result"]["3"];
      hindilevel1 = detect["result"]["3"];
      englishlevel1 = detect["result"]["4"];
      increasingtextleft1 = detect["result"]["6"];
      increasingtextright1 = detect["result"]["10"];
      greenfivehundred1 = detect["result"]["5"];
      ashokapillar1 = detect["result"]["2"];
      fivelineleft1 = detect["result"]["9"];
      fivelineright1 = detect["result"]["8"];

      setState(() {
        devnagri1;
        hindilevel1;
        englishlevel1;
        increasingtextright1;
        greenfivehundred1;
        ashokapillar1;
        fivelineleft1;
        fivelineright1;
      });

      print(response.runtimeType);
    } else {
      final responseData = await response.stream.bytesToString();
      print('Response: $responseData');
      print('Failed to upload image');
    }
  }

  // ---custom model------------

  //install path provider packege to remove error
  //copy third package from documentation i.e
  // import 'package:path/path.dart';
  //--> comment this and called load model in init state class
  // final ImageLabelerOptions options =
  //     ImageLabelerOptions(confidenceThreshold: 0.5);
  // imageLabeler = ImageLabeler(options: options);

  //--> in android -->app--> build gradle -->paste
  // aaptOptions {
  //       noCompress "tflite"
  //       // or noCompress "lite"
  //   }

  //------------------------lebel image----------------------
  doimagelebelling() async {
    print("------------------- - _ - _----------------");
    InputImage inputImage = InputImage.fromFile(mahatmagandhi!);

    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    print("------------------- - _ - _----------------");
    ans = '';
    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;
      // ans += confidence.toStringAsFixed(4);
      // ans = ans.substring(2, 4);
      ans += text;
      print("------------------- - _ - _----------------");

      ans = ans.substring(2);
      print(ans);
      print("------------------- - _ - _----------------");
    }
    setState(() {
      ans;
    });
  }

  doimagelebelling2() async {
    print("------------------- - _ - _----------------");
    InputImage inputImage2 = InputImage.fromFile(_image!);

    final List<ImageLabel> labels =
        await imageLabeler2.processImage(inputImage2);
    print("------------------- - _ - _----------------");
    note = '';
    //note = labels[0].toString;
    print(labels.toString());
    for (ImageLabel label in labels) {
      final String text = label.label;

      //final int index = label.index;
      //final double confidence = label.confidence;
      //ans += confidence.toStringAsFixed(4);
      note += text;
      print("------------------- - _ - _----------------");
      print(note);
      print("------------------- - _ - _----------------");
      note = note.substring(2);
    }

    setState(
      () {
        if (note == "500") {
          Audio.load('assets/audio/500.mp3')
            ..play()
            ..dispose();
        } else if (note == "200") {
          Audio.load('assets/audio/200.aac')
            ..play()
            ..dispose();
        } else if (note == "100") {
          Audio.load('assets/audio/100.aac')
            ..play()
            ..dispose();
        } else if (note == "50") {
          Audio.load('assets/audio/50.aac')
            ..play()
            ..dispose();
        } else if (note == "20") {
          Audio.load('assets/audio/20.aac')
            ..play()
            ..dispose();
        } else if (note == "10") {
          Audio.load('assets/audio/10.aac')
            ..play()
            ..dispose();
        }
      },
    );
  }

  Future<String> getModelPath(String asset) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$asset';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(asset);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  loadcoustomModel() async {
    final modelPath = await getModelPath('assets/ml/Gandhi1_metadata.tflite');
    final options = LocalLabelerOptions(
      confidenceThreshold: 0.5,
      modelPath: modelPath,
    );
    imageLabeler = ImageLabeler(options: options);
  }

  loadcoustomModel2() async {
    final modelPath = await getModelPath('assets/ml/final_metadata.tflite');
    final options = LocalLabelerOptions(
      confidenceThreshold: 0.7,
      modelPath: modelPath,
    );
    imageLabeler2 = ImageLabeler(options: options);
  }

  // ---coustum model-------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
        elevation: 10,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              _image == null ? Text('No image selected.') : Image.file(_image!),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    devnagri1 = null;
                    hindilevel1 = null;
                    englishlevel1 = null;
                    increasingtextright1;
                    greenfivehundred1 = null;
                    ashokapillar1;
                    fivelineleft1;
                    fivelineright1 = null;
                  });

                  scanDocument();
                },
                child: Text(
                    '                   Pick Image                        '),
              ),
              SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () {
                  _uploadImage();
                  fake();
                },
                child: Text(
                    '                        Verify                           '),
              ),
              SizedBox(
                height: 5,
              ),
              note == "0" ? Text("") : Text(note),
              SizedBox(
                height: 5,
              ),
              strip == null
                  ? SizedBox(
                      height: 0,
                    )
                  : Row(
                      children: [
                        Image.file(
                          strip!,
                          height: 200,
                          width: 200,
                        ),
                        Text("Strip")
                      ],
                    ),
              SizedBox(
                height: 5,
              ),
              devnagri == null
                  ? SizedBox(
                      height: 0,
                    )
                  : Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.file(
                          devnagri!,
                          height: 200,
                          width: 200,
                        ),
                        devnagri1 == null
                            ? Text("")
                            : devnagri1 == true
                                ? Text(
                                    "Passed ✅",
                                    style: TextStyle(color: Colors.green),
                                  )
                                : Text(
                                    "Fail ❌",
                                    style: TextStyle(color: Colors.red),
                                  ),
                      ],
                    ),
              SizedBox(
                height: 5,
              ),
              mahatmagandhi == null
                  ? SizedBox(
                      height: 0,
                    )
                  : Row(
                      children: [
                        Image.file(
                          mahatmagandhi!,
                          height: 200,
                          width: 200,
                        ),
                        ans == '0'
                            ? Text("")
                            : (ans == "Real")
                                ? Text(
                                    " Pass ✅",
                                    style: TextStyle(color: Colors.green),
                                  )
                                : Text(
                                    "Fail ❌",
                                    style: TextStyle(color: Colors.red),
                                  ),
                      ],
                    ),
              SizedBox(
                height: 5,
              ),
              hindilevel == null
                  ? SizedBox(
                      height: 0,
                    )
                  : Row(
                      children: [
                        Image.file(
                          hindilevel!,
                          height: 200,
                          width: 200,
                        ),
                        hindilevel1 == null
                            ? Text("")
                            : hindilevel1 == true
                                ? Text(
                                    "Passed ✅",
                                    style: TextStyle(color: Colors.green),
                                  )
                                : Text(
                                    "Fail ❌",
                                    style: TextStyle(color: Colors.red),
                                  ),
                      ],
                    ),
              SizedBox(
                height: 5,
              ),
              englishlevel == null
                  ? SizedBox(
                      height: 0,
                    )
                  : Row(
                      children: [
                        Image.file(
                          englishlevel!,
                          height: 200,
                          width: 200,
                        ),
                        rbi == null
                            ? Text("")
                            : (rbi == "RESERVE BANK OF INDIA" ||
                                    rbi == "ESERVE BANK OF INDIA")
                                ? Text(
                                    "Passed ✅",
                                    style: TextStyle(color: Colors.green),
                                  )
                                : Text(
                                    "Fail ❌",
                                    style: TextStyle(color: Colors.red),
                                  ),
                      ],
                    ),
              SizedBox(
                height: 5,
              ),
              increasingtextleft == null
                  ? SizedBox(
                      height: 0,
                    )
                  : Row(
                      children: [
                        Image.file(
                          increasingtextleft!,
                          height: 200,
                          width: 200,
                        ),
                        increasingtextleft1 == null
                            ? Text("")
                            : increasingtextleft1 == true
                                ? Text(
                                    "Passed ✅",
                                    style: TextStyle(color: Colors.green),
                                  )
                                : Text(
                                    "Fail ❌",
                                    style: TextStyle(color: Colors.red),
                                  ),
                      ],
                    ),
              SizedBox(
                height: 10,
              ),
              increasingtextright == null
                  ? SizedBox(
                      height: 0,
                    )
                  : Row(
                      children: [
                        Image.file(
                          increasingtextright!,
                          height: 200,
                          width: 200,
                        ),
                        increasingtextright1 == null
                            ? Text("")
                            : increasingtextright1 == true
                                ? Text(
                                    "Passed ✅",
                                    style: TextStyle(color: Colors.green),
                                  )
                                : Text(
                                    "Fail ❌",
                                    style: TextStyle(color: Colors.red),
                                  ),
                      ],
                    ),
              SizedBox(
                height: 10,
              ),
              greenfivehundred == null
                  ? SizedBox(
                      height: 0,
                    )
                  : Row(
                      children: [
                        Image.file(
                          greenfivehundred!,
                          height: 200,
                          width: 200,
                        ),
                        greenfivehundred1 == null
                            ? Text("")
                            : greenfivehundred1 == true
                                ? Text(
                                    "Passed ✅",
                                    style: TextStyle(color: Colors.green),
                                  )
                                : Text(
                                    "Fail ❌",
                                    style: TextStyle(color: Colors.red),
                                  ),
                      ],
                    ),
              SizedBox(
                height: 10,
              ),
              ashokapillar == null
                  ? SizedBox()
                  : Row(
                      children: [
                        Image.file(
                          ashokapillar!,
                          height: 200,
                          width: 200,
                        ),
                        ashokapillar1 == null
                            ? Text("")
                            : ashokapillar1 == true
                                ? Text(
                                    "Passed ✅",
                                    style: TextStyle(color: Colors.green),
                                  )
                                : Text(
                                    "Fail ❌",
                                    style: TextStyle(color: Colors.red),
                                  ),
                      ],
                    ),
              SizedBox(
                height: 5,
              ),
              fivelineleft == null
                  ? SizedBox(
                      height: 0,
                    )
                  : Row(
                      children: [
                        Image.file(
                          fivelineleft!,
                          height: 200,
                          width: 200,
                        ),
                        fivelineleft1 == null
                            ? Text("")
                            : fivelineleft1 == true
                                ? Text(
                                    "Passed ✅",
                                    style: TextStyle(color: Colors.green),
                                  )
                                : Text(
                                    "Fail ❌",
                                    style: TextStyle(color: Colors.red),
                                  ),
                      ],
                    ),
              SizedBox(
                height: 5,
              ),
              fivelineright == null
                  ? SizedBox(
                      height: 0,
                    )
                  : Row(
                      children: [
                        Image.file(
                          fivelineright!,
                          height: 200,
                          width: 200,
                        ),
                        fivelineright1 == null
                            ? Text("")
                            : fivelineright1 == true
                                ? Text(
                                    "Passed ✅",
                                    style: TextStyle(color: Colors.green),
                                  )
                                : Text(
                                    "Fail ❌",
                                    style: TextStyle(color: Colors.red),
                                  ),
                      ],
                    ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
