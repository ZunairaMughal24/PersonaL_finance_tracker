import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/viewmodels/image_view_model.dart';

class ImageViewScreen extends StatelessWidget {
  final String imagePath;
  const ImageViewScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ImageViewModel(),
      child: _ImageViewScreenContent(imagePath: imagePath),
    );
  }
}

class _ImageViewScreenContent extends StatelessWidget {
  final String imagePath;
  const _ImageViewScreenContent({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ImageViewModel>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Colors.white, size: 22),
            onPressed: () => context.read<ImageViewModel>().downloadImage(context, imagePath),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
          
          if (vm.isDownloading || vm.showSavedToast)
            Center(
              child: GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (vm.isDownloading) ...[
                      const SizedBox(
                        width: 18, 
                        height: 18, 
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white)
                      ),
                      const SizedBox(width: 12),
                      const Text("Downloading...").h2(color: AppColors.white, weight: FontWeight.w700),
                    ] else ...[
                      const Icon(Icons.check_circle_rounded, color: AppColors.green, size: 22),
                      const SizedBox(width: 8),
                      const Text("Saved!").h2(color: AppColors.green, weight: FontWeight.w700),
                    ]
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
