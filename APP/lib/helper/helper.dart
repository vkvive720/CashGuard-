import 'dart:io';

import 'package:image/image.dart' as img;

class Helper {
  static Future<File?> autocropImage(
      {required File imageFile,
      required double w,
      required double h,
      required double x,
      required double y,
      required String name}) async {
    // Load the image
    //File? newimagefile = imageFile;
    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
    if (image == null) return null;

    // Define the crop area
    int cropWidth = (image.width * w).toInt();
    int cropHeight = (image.height * h).toInt();
    int offsetX = ((image.width - cropWidth) * x).toInt();
    // int offsetY = ((image.height) * y).toInt();
    int offsetY = (image.height * y).toInt();

    // Crop the image
    //img.Image croppedImage = img.copyCrop();

    img.Image croppedImage = img.copyCrop(
      image,
      offsetX,
      offsetY,
      cropWidth,
      cropHeight,
    );

    String z = DateTime.now().toString();

    // Save the cropped image to a new file
    File croppedFile =
        await File(imageFile.path.replaceFirst('.jpg', '${z}+${name}.jpg'))
            .writeAsBytes(img.encodeJpg(croppedImage));

    return croppedFile;
  }
}
