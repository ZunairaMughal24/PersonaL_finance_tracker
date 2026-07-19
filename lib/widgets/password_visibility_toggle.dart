import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:montage/core/constants/app_images.dart';

class PasswordVisibilityToggle extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onPressed;

  const PasswordVisibilityToggle({
    super.key,
    required this.isVisible,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: isVisible
          ? Icon(
              Icons.visibility,
              color: Colors.white.withValues(alpha: 0.35),
              size: 20,
            )
          : SvgPicture.asset(
              AppImages.eyeClosed,
              colorFilter: ColorFilter.mode(
                Colors.white.withValues(alpha: 0.35),
                BlendMode.srcIn,
              ),
              height: 20,
            ),
    );
  }
}
