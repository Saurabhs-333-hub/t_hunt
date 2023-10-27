import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:grock/grock.dart';
import 'package:image_picker/image_picker.dart';

void successSnackBar(BuildContext context, String title, String description) {
  Grock.snackBar(
      title: title,
      description: description,
      curve: Curves.easeInOutCubicEmphasized,
      blur: 20.0,
      color: Color.fromARGB(126, 124, 124, 124),
      // opacity: 0.3,
      itemSpaceHeight: 0,
      leading: Icon(
        Icons.check_circle_rounded,
        color: Colors.green,
      ),
      descriptionColor: Colors.green[300],
      leadingPadding: EdgeInsets.all(10),
      titleColor: Colors.green);
}

void errorSnackBar(BuildContext context, String title, String description) {
  Grock.snackBar(
      title: "Error! 😥",
      description: description,
      curve: Curves.easeInOutCubicEmphasized,
      blur: 20.0,
      color: Color.fromARGB(96, 165, 165, 165),
      // opacity: 0.3,
      itemSpaceHeight: 0,
      leading: Icon(
        Icons.error_rounded,
        color: Colors.red,
      ),
      descriptionColor: Colors.red[400],
      leadingPadding: EdgeInsets.all(10),
      titleColor: Colors.red);
}

void warningSnackBar(BuildContext context, String title, String description) {
  Grock.snackBar(
      title: title,
      description: description,
      curve: Curves.easeInOutCubicEmphasized,
      blur: 20.0,
      color: Color.fromARGB(126, 124, 124, 124),
      // opacity: 0.3,
      itemSpaceHeight: 0,
      borderRadius: BorderRadius.circular(20),
      leading: Icon(
        Icons.error_rounded,
        color: Colors.yellow,
      ),
      descriptionColor: Colors.yellow[200],
      leadingPadding: EdgeInsets.all(10),
      titleColor: Colors.yellow);
}

void defaultSnackBar(BuildContext context, String title, String description) {
  Grock.snackBar(
    title: title,
    description: description,
    curve: Curves.easeInOutCubicEmphasized,
    blur: 20.0,
    color: Color.fromARGB(126, 124, 124, 124),
    // opacity: 0.3,
    itemSpaceHeight: 0,
    leading: Icon(
      Icons.error_rounded,
    ),
    leadingPadding: EdgeInsets.all(10),
  );
}

Future<List<File>> pickFiles() async {
  if (Platform.isAndroid || Platform.isIOS) {
    List<File> compressedImages = [];
    final ImagePicker _picker = ImagePicker();
    final imageFiles =
        await _picker.pickMultipleMedia(requestFullMetadata: true);
    if (imageFiles.isNotEmpty) {
      for (final image in imageFiles) {
        final File pickedImage = File(image.path);
        print('pickedImage ${pickedImage.lengthSync()}');

        final compressedImage = await compressImage(pickedImage);
        compressedImages.add(compressedImage);
      }
    }
    return compressedImages;
  } else {
    List<File> images = [];
    final ImagePicker _picker = ImagePicker();
    final imageFiles =
        await _picker.pickMultipleMedia(requestFullMetadata: true);
    if (imageFiles.isNotEmpty) {
      for (final image in imageFiles) {
        images.add(File(image.path));
      }
    }
    return images;
  }
}

Future<File> compressImage(File image) async {
  final Uint8List? compressedBytes =
      await FlutterImageCompress.compressWithFile(
    image.absolute.path,
    minWidth: 1024,
    minHeight: 1024,
    quality: 95,
  );
  if (compressedBytes != null) {
    final File compressedImage =
        File(image.path.replaceAll('.jpg', '_compressed.jpg'));
    await compressedImage.writeAsBytes(compressedBytes.toList());
    print('cpmpressedImage ${compressedImage.lengthSync()}');
    return compressedImage;
  } else {
    throw Exception('Image compression failed');
  }
}

Color parseColor(String colorString) {
  // Define a regular expression to match the format "Color(0xRRGGBBAA)"
  final RegExp colorRegExp = RegExp(r"Color\(0x([0-9a-fA-F]+)\)");

  // Attempt to match the regular expression with the input string
  final Match? match = colorRegExp.firstMatch(colorString);

  if (match != null && match.groupCount == 1) {
    // Extract the hexadecimal color value
    String hexColor = match.group(1)!;

    // Parse the hexadecimal color value
    int colorValue = int.parse(hexColor, radix: 16);

    // Create a Color object from the parsed value
    return Color(colorValue);
  } else {
    // Return a default color if the format is incorrect
    return Colors.black;
  }
}
