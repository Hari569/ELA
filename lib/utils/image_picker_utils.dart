import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

// Conditional imports
import 'image_picker_mobile.dart' if (dart.library.html) 'image_picker_web.dart'
    as platform_picker;

class ImagePickerUtils {
  static Future<String?> pickImage() async {
    return await platform_picker.pickImage();
  }

  static Widget buildImage(String imageData,
      {double? height, double? width, BoxFit? fit}) {
    if (kIsWeb) {
      // For web, imageData is already a data URL
      return Image.network(
        imageData,
        height: height,
        width: width,
        fit: fit,
      );
    } else {
      // For mobile, imageData is a base64 encoded string
      Uint8List bytes = base64Decode(imageData);
      return Image.memory(
        bytes,
        height: height,
        width: width,
        fit: fit,
      );
    }
  }
}
