import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/config/router.dart';
import 'package:personal_finance_tracker/core/constants/appImages.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/core/utils/animation_utils.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';

import 'package:personal_finance_tracker/widgets/app_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(milliseconds: 4000));
    if (!mounted) return;
    context.go(AppRoutes.homeScreenRoute);
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      style: BackgroundStyle.glowMesh,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeScaleTransition(
              child: GlassContainer(
                borderRadius: 100,
                padding: const EdgeInsets.all(32),
                blur: 40,
                child: Image.asset(
                  AppImages.lineChartIcon,
                  height: 120,
                  width: 120,
                ),
              ),
            ),
            40.heightBox,
            FadeSlideTransition(
              interval: const Interval(0.3, 1.0, curve: Curves.easeOut),
              child: Column(
                children: [
                  Text(
                    "MONTAGE",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
                  ),
                  8.heightBox,
                  Text(
                    "PREMIUM FINANCE TRACKER",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
