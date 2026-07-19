import 'package:image_picker/image_picker.dart';

abstract class IMediaService {
  Future<String?> saveImageLocally(String sourcePath, String name);
  Future<XFile?> pickImage(ImageSource source);
}
