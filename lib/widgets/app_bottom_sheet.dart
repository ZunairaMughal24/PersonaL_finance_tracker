import 'package:flutter/material.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';

class AppBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    EdgeInsetsGeometry? padding,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: isScrollControlled,
      builder: (context) =>
          AppBottomSheetContainer(padding: padding, child: child),
    );
  }
}

class AppBottomSheetContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppBottomSheetContainer({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      customBorderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
      showBottomBorder: false,
      blur: 40,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          24.heightBox,
          child,
          (MediaQuery.of(context).viewInsets.bottom > 0 ? 0.0 : 20.0).heightBox,
        ],
      ),
    );
  }
}
