import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/config/router.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/constants/appImages.dart';

import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/widgets/appButton.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1614850523459-c2f4c699c52e?q=80&w=2187&auto=format&fit=crop',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(0.6),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 8),
                GlassContainer(
                  borderRadius: 100,
                  padding: const EdgeInsets.all(24),
                  child: Image.asset(
                    AppImages.lineChartIcon,
                    height: 90,
                    width: 90,
                  ),
                ),
                30.heightBox,
                Padding(
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
                20.heightBox,
                Padding(
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
                40.heightBox,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
