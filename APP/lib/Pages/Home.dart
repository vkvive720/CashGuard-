import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notecheak/helper/Uihelper.dart';
import 'package:notecheak/helper/helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
//import 'package:notecheak/Model/Uihealper.dart';
import 'package:image/image.dart' as img;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? imageFile;
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

  late final InputImage inputImage;
  String result = "Result will shown here";

  late ImageLabeler imageLabeler;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //initalise image lebler from google ml lib in initstate
    //comment this for using coustum lebellar
    // final ImageLabelerOptions options =
    //     ImageLabelerOptions(confidenceThreshold: 0.5);
    // imageLabeler = ImageLabeler(options: options);

    loadcoustomModel();
  }

//showing option for camera and gallrey------------------//
  void showPhotoOptions(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Upload Profile Picture"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("cancel"))
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: const Icon(Icons.photo),
                  title: const Text("Select from Gallrey"),
                ),
                ListTile(
                  onTap: () {
                    selectImage(
                      ImageSource.camera,
                    );
                  },
                  leading: const Icon(Icons.camera),
                  title: const Text("Take a Photo"),
                )
              ],
            ),
          );
        });
  }
  //showing option for camera and gallrey------------------//

  //------------selecting image----------------
  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      print("cooking-------------------------------");
      cropImage(pickedFile, context);
    }
  }
  //------------selecting image----------------

  void cropImage(XFile file, context) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        // aspectRatio:
        //     const CropAspectRatio(ratioX: 1, ratioY: 1), //1:1 give squre photo
        // compressQuality: 30,

        uiSettings: [
          AndroidUiSettings(
              lockAspectRatio: false, toolbarTitle: "Image cropper")
        ]);

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
        strip = imageFile;
        devnagri = imageFile;
        mahatmagandhi = imageFile;
        hindilevel = imageFile;
        englishlevel = imageFile;

        increasingtextleft = imageFile;
        increasingtextright = imageFile;
        greenfivehundred = imageFile;
        ashokapillar = imageFile;
        fivelineleft = imageFile;
        fivelineright = imageFile;

        // doimagelebelling();
      });

      //_________________ cropping parts - _ - _ - _ - _ - _ - _ - _ - _ -

      //Uihelper.showLoadingDialog("Plese wait", context);

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
          w: .4,
          x: 0.3,
          y: 0,
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
          h: 0.2,
          w: .35,
          x: 0.04,
          y: .2,
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
          h: 0.35,
          w: .2,
          x: 0.9,
          y: 0.6,
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

      //_________________ cropping parts - _ - _ - _ - _ - _ - _ - _ - _ -

      // strip = await autocropImage(strip!, 0.5, 0.1) as File;
      // devnagri = await autocropImage(devnagri!, 0.7, 0.2) as File;

      //devnagri = await autocropImage(imageFile!, 0.3);

      // if (croppedFile != null) {
      //   print("-------------------------------hiiii--------------------");
      //   setState(() {});
      // }

      if (imageFile != null) {
        //Navigator.pop(context);
        print("-------------------------------hiiii--------------------");
        //Navigator.pop(context);
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
        });
      }
    }
  }

  //------------------------lebel image----------------------
  doimagelebelling() async {
    print("------------------- - _ - _----------------");
    InputImage inputImage = InputImage.fromFile(mahatmagandhi!);

    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    print("------------------- - _ - _----------------");
    result = '';
    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;
      result += text + " confidence " + confidence.toStringAsFixed(4) + "\n";
      result = result.substring(2);
    }
    setState(() {
      result;
    });
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
    final modelPath = await getModelPath('assets/ml/Gandhi_metadata.tflite');
    final options = LocalLabelerOptions(
      confidenceThreshold: 0.5,
      modelPath: modelPath,
    );
    imageLabeler = ImageLabeler(options: options);
  }

  // ---coustum model-------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Currency Detector"),
        elevation: 10,
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageFile == null
                  ? Icon(Icons.image)
                  : Image.file(
                      imageFile!,
                      height: 200,
                      width: 200,
                    ),
              SizedBox(
                height: 10,
              ),
              strip == null
                  ? Icon(Icons.image)
                  : Image.file(
                      strip!,
                      height: 300,
                      width: 200,
                    ),
              SizedBox(
                height: 10,
              ),
              devnagri == null
                  ? Icon(Icons.image)
                  : Image.file(
                      devnagri!,
                      height: 200,
                      width: 200,
                    ),
              SizedBox(
                height: 10,
              ),
              mahatmagandhi == null
                  ? SizedBox(
                      height: 0,
                    )
                  : Image.file(
                      mahatmagandhi!,
                      height: 200,
                      width: 200,
                    ),
              SizedBox(
                height: 10,
              ),
              hindilevel == null
                  ? SizedBox(
                      height: 0,
                    )
                  : Column(
                      children: [
                        Image.file(
                          hindilevel!,
                          height: 200,
                          width: 200,
                        ),
                        Text("Hindi RBI")
                      ],
                    ),
              SizedBox(
                height: 10,
              ),
              englishlevel == null
                  ? SizedBox(
                      height: 0,
                    )
                  : Image.file(
                      englishlevel!,
                      height: 300,
                      width: 200,
                    ),
              SizedBox(
                height: 10,
              ),
              increasingtextleft == null
                  ? SizedBox(
                      height: 0,
                    )
                  : Image.file(
                      increasingtextleft!,
                      height: 300,
                      width: 200,
                    ),
              SizedBox(
                height: 10,
              ),
              increasingtextright == null
                  ? SizedBox(
                      height: 0,
                    )
                  : Image.file(
                      increasingtextright!,
                      height: 300,
                      width: 200,
                    ),
              SizedBox(
                height: 10,
              ),
              greenfivehundred == null
                  ? SizedBox(
                      height: 0,
                    )
                  : Image.file(
                      greenfivehundred!,
                      height: 300,
                      width: 200,
                    ),
              SizedBox(
                height: 10,
              ),
              ashokapillar == null
                  ? SizedBox()
                  : Image.file(
                      ashokapillar!,
                      height: 300,
                      width: 200,
                    ),
              SizedBox(
                height: 10,
              ),
              fivelineleft == null
                  ? SizedBox(
                      height: 0,
                    )
                  : Image.file(
                      fivelineleft!,
                      height: 300,
                      width: 200,
                    ),
              SizedBox(
                height: 10,
              ),
              fivelineright == null
                  ? SizedBox(
                      height: 0,
                    )
                  : Image.file(
                      fivelineright!,
                      height: 300,
                      width: 200,
                    ),
              SizedBox(
                height: 10,
              ),
              CupertinoButton(
                child: Text("Add image"),
                onPressed: () async {
                  showPhotoOptions(context);
                },
                color: Colors.blueAccent,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '$result',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }
}
