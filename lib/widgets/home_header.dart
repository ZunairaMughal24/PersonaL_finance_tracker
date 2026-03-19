import 'dart:io';
import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/constants/app_images.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:montage/widgets/glass_container.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String? profileImagePath;
  final String summaryText;

  const HomeHeader({
    super.key,
    required this.userName,
    this.profileImagePath,
    required this.summaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 16, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 27,
                  backgroundColor: AppColors.primaryLight.withValues(
                    alpha: 0.15,
                  ),
                  backgroundImage: profileImagePath != null
                      ? FileImage(File(profileImagePath!)) as ImageProvider
                      : null,
                  child: profileImagePath == null
                      ? const Icon(
                          Icons.person,
                          color: AppColors.primaryColor,
                          size: 24,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${userName.split(' ')[0]}!',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    summaryText,
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GlassContainer(
            borderRadius: 50,
            padding: const EdgeInsets.all(10),
            blur: 10,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  AppImages.bell,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                  height: 22,
                ),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
