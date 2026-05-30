import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:montage/core/interfaces/i_media_service.dart';
import 'package:montage/core/utils/app_logger.dart';

class MediaService implements IMediaService {
  Future<String?> saveImageLocally(String sourcePath, String name) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final File file = File(sourcePath);
      final File newImage = await file.copy('${directory.path}/$name');
      return newImage.path;
    } catch (e, stackTrace) {
      AppLogger.error('MediaService: saveImageLocally failed', e, stackTrace);
      return null;
    }
  }
}
