import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grock/grock.dart';
import 'package:image_picker/image_picker.dart';

void successSnackBar(BuildContext context, String title, String description) {
  Grock.snackBar(
      title: title,
      description: description,
      curve: Curves.easeInOutCubicEmphasized,
      blur: 20.0,
      color: Color.fromARGB(131, 124, 124, 124),
      opacity: 0.3,
      itemSpaceHeight: 10,
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
      color: Color.fromARGB(186, 160, 160, 160),
      opacity: 0.3,
      itemSpaceHeight: 10,
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
      color: Color.fromARGB(131, 124, 124, 124),
      opacity: 0.3,
      itemSpaceHeight: 10,
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
    color: Color.fromARGB(131, 124, 124, 124),
    opacity: 0.3,
    itemSpaceHeight: 10,
    leading: Icon(
      Icons.error_rounded,
    ),
    leadingPadding: EdgeInsets.all(10),
  );
}

Future<List<File>> pickFiles() async {
  List<File> images = [];
  final ImagePicker _picker = ImagePicker();
  final imageFiles = await _picker.pickMultiImage(requestFullMetadata: true);
  if (imageFiles.isNotEmpty) {
    for (final image in imageFiles) {
      images.add(File(image.path));
    }
  }
  return images;
}
