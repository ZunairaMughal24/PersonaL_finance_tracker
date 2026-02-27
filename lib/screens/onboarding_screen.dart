import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/config/router.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/constants/appImages.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/widgets/appButton.dart';
import 'package:personal_finance_tracker/core/utils/animation_utils.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';
import 'package:personal_finance_tracker/widgets/app_background.dart';

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
                    color: Colors.white.withOpacity(0.8),
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
                      color: AppColors.primaryColor.withOpacity(0.4),
                      textColor: Colors.white,
                      width: double.infinity,
                    ),
                    16.heightBox,
                    AppButton(
                      text: "Sign In",
                      onPressed: () {
                        context.go(AppRoutes.signInScreenRoute);
                      },
                      borderColor: AppColors.white.withOpacity(0.4),
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
