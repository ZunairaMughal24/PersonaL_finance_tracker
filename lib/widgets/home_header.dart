import 'dart:io';
import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/constants/app_images.dart';
import 'package:montage/core/themes/app_text_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:montage/core/enums/sync_status.dart';
import 'package:montage/widgets/glass_container.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String? profileImagePath;
  final String summaryText;
  final SyncStatus syncStatus;

  const HomeHeader({
    super.key,
    required this.userName,
    this.profileImagePath,
    required this.summaryText,
    this.syncStatus = SyncStatus.idle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                    style: AppTextTheme.h3(
                      color: AppColors.white,
                      weight: FontWeight.bold,
                    ).copyWith(fontSize: 18, letterSpacing: -0.5),
                  ),
                  Row(
                    children: [
                      Text(
                        summaryText,
                        style: AppTextTheme.body(
                          color: AppColors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                          weight: FontWeight.w400,
                        ),
                      ),
                      if (syncStatus != SyncStatus.idle) ...[
                        const SizedBox(width: 8),
                        _buildSyncIcon(),
                      ],
                    ],
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
                  placeholderBuilder: (BuildContext context) =>
                      const SizedBox(height: 22, width: 22),
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

  Widget _buildSyncIcon() {
    switch (syncStatus) {
      case SyncStatus.idle:
        return const SizedBox.shrink();
      case SyncStatus.syncing:
        return const _SpinningSyncIcon();
      case SyncStatus.success:
        return Icon(
          Icons.cloud_done_rounded,
          size: 14,
          color: Colors.greenAccent.withValues(alpha: 0.9),
        );
      case SyncStatus.error:
        return Icon(
          Icons.cloud_off_rounded,
          size: 14,
          color: Colors.redAccent.withValues(alpha: 0.9),
        );
    }
  }
}

class _SpinningSyncIcon extends StatefulWidget {
  const _SpinningSyncIcon();

  @override
  State<_SpinningSyncIcon> createState() => _SpinningSyncIconState();
}

class _SpinningSyncIconState extends State<_SpinningSyncIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(
        Icons.sync_rounded,
        size: 14,
        color: Colors.blueAccent.withValues(alpha: 0.9),
      ),
    );
  }
}
