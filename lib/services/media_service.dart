import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MediaService {
  Future<String?> saveImageLocally(String sourcePath, String name) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final File file = File(sourcePath);
      final File newImage = await file.copy('${directory.path}/$name');
      return newImage.path;
    } catch (e) {
      return null;
    }
  }
}
