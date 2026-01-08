import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/config/router.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';

import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/widgets/appButton.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "Manage your savings, one step at a time",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              16.heightBox,

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  "See your progress, get reminders, and start building the habits that leads to freedom",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
              ),
              const Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    AppButton(
                      text: "Get Started",
                      onPressed: () {
                        context.go(AppRoutes.mainNavigationScreenRoute);
                      },
                      color: AppColors.primaryColor,
                      textColor: Colors.white,
                      width: double.infinity,
                    ),
                    16.heightBox,
                    AppButton(
                      text: "Sign In",
                      onPressed: () {
                        context.go(AppRoutes.mainNavigationScreenRoute);
                      },
                      color: Colors.white,
                      textColor: AppColors.primaryColor,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
              40.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
