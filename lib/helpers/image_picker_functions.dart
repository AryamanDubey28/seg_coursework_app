import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

/// The logic behind the upload/take picture library is made
/// with the help of: https://youtu.be/MSv38jO4EJk
/// and https://youtu.be/u52TWx41oU4

/// A class added to make the image picking functions reusable and
/// reduces code duplication.
class ImagePickerFunctions {
  const ImagePickerFunctions();

  /// Enable the user to either upload or take an image depending on
  /// the source argument. Return the picked image as File.
  Future<File?> pickImage(
      {required ImageSource source, required BuildContext context}) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return null;

      return File(image.path);
    } on PlatformException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                  "Couldn't upload/take a picture, make sure you have given image permissions in your device's settings"),
            );
          });
      return null;
    }
  }
}
