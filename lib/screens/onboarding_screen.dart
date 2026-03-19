import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:montage/config/router.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/constants/app_images.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/app_button.dart';
import 'package:montage/core/utils/animation_utils.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/widgets/app_background.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      style: BackgroundStyle.glowMesh,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 8),
            FadeScaleTransition(
              child: GlassContainer(
                borderRadius: 100,
                padding: const EdgeInsets.all(24),
                child: Image.asset(
                  AppImages.lineChartIcon,
                  height: 90,
                  width: 90,
                ),
              ),
            ),
            30.heightBox,
            FadeSlideTransition(
              interval: const Interval(0.4, 1.0, curve: Curves.easeOut),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "Smart Finance\nManagement",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
            ),
            20.heightBox,
            FadeSlideTransition(
              interval: const Interval(0.6, 1.0, curve: Curves.easeOut),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  "Take control of your finances. Track spending, manage budgets, and build wealth effortlessly.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ),
            ),
            const Spacer(),
            FadeSlideTransition(
              interval: const Interval(0.8, 1.0, curve: Curves.easeOut),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    AppButton(
                      text: "Get Started",
                      onPressed: () {
                        context.go(AppRoutes.signUpScreenRoute);
                      },
                      color: AppColors.primaryColor.withValues(alpha: 0.4),
                      textColor: Colors.white,
                      width: double.infinity,
                    ),
                    16.heightBox,
                    AppButton(
                      text: "Sign In",
                      onPressed: () {
                        context.go(AppRoutes.signInScreenRoute);
                      },
                      borderColor: AppColors.white.withValues(alpha: 0.4),
                      color: Colors.transparent,
                      textColor: AppColors.white,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
            40.heightBox,
          ],
        ),
      ),
    );
  }
}
