import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';

class CustomCategoryDialog extends StatefulWidget {
  final Function(String) onSubmitted;

  const CustomCategoryDialog({super.key, required this.onSubmitted});

  @override
  State<CustomCategoryDialog> createState() => _CustomCategoryDialogState();
}

class _CustomCategoryDialogState extends State<CustomCategoryDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: GlassContainer(
        borderRadius: 24,
        blur: 40,
        borderOpacity: 0.15,
        padding: const EdgeInsets.all(24),
        gradientColors: [
          Colors.white.withValues(alpha: 0.15),
          AppColors.primaryColor.withValues(alpha: 0.08),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Custom Category").h2(color: Colors.white),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            Text(
              "Enter a name for your custom category",
            ).bodyLarge(color: Colors.white.withValues(alpha: 0.8)),
            15.heightBox,
            TextField(
              controller: _controller,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: "e.g. Shopping, Rent, Gifts",
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  widget.onSubmitted(value.trim());
                  Navigator.pop(context);
                }
              },
            ),
            24.heightBox,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_controller.text.trim().isNotEmpty) {
                    widget.onSubmitted(_controller.text.trim());
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Confirm",
                ).titleLarge(weight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
