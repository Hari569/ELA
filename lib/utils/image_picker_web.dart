import 'package:image_picker_web/image_picker_web.dart';

Future<String?> pickImage() async {
  final image = await ImagePickerWeb.getImageAsBytes();
  if (image != null) {
    final imageData =
        Uri.dataFromBytes(image, mimeType: 'image/png').toString();
    return imageData;
  }
  return null;
}
