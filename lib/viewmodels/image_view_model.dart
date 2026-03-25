import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:montage/core/utils/toast_utility.dart';

class ImageViewModel extends ChangeNotifier {
  bool _isDownloading = false;
  bool _showSavedToast = false;

  bool get isDownloading => _isDownloading;
  bool get showSavedToast => _showSavedToast;

  Future<void> downloadImage(BuildContext context, String imagePath) async {
    if (_isDownloading) return;

    _isDownloading = true;
    _showSavedToast = false;
    notifyListeners();
    
    try {
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        await Gal.requestAccess();
      }
      await Gal.putImage(imagePath);
      
      _isDownloading = false;
      _showSavedToast = true;
      notifyListeners();
      
      await Future.delayed(const Duration(seconds: 2));
      
      _showSavedToast = false;
      notifyListeners();
    } catch (e) {
      _isDownloading = false;
      notifyListeners();
      if (context.mounted) {
        ToastUtils.show(context, "Failed to download: $e");
      }
    }
  }
}
