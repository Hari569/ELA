import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

Future<String?> pickImage() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    List<int> imageBytes = await image.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  return null;
}
