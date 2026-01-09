import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/config/router.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';
import 'package:personal_finance_tracker/core/utils/validators.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/core/utils/padding_extention.dart';
import 'package:personal_finance_tracker/widgets/appButton.dart';
import 'package:personal_finance_tracker/widgets/appTextField.dart';
import 'package:personal_finance_tracker/widgets/app_background.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                60.heightBox,
                const Text("Welcome Back").h1(color: Colors.white),
                8.heightBox,
                Text(
                  "Sign in to continue your financial journey",
                ).bodyMedium(color: Colors.white.withOpacity(0.7)),
                40.heightBox,
                GlassContainer(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppTextField(
                          title: "Email Address",
                          hint: "example@mail.com",
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.emailValidator,
                          prefixChild: Icon(
                            Icons.email_outlined,
                            color: AppColors.primaryColor.withOpacity(0.7),
                            size: 20,
                          ),
                        ),
                        20.heightBox,
                        AppTextField(
                          title: "Password",
                          hint: "••••••••",
                          controller: _passwordController,
                          obscureText: true,
                          validator: Validators.passwordValidator,
                          prefixChild: Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.primaryColor.withOpacity(0.7),
                            size: 20,
                          ),
                        ),
                        12.heightBox,
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Forgot Password?",
                            ).labelSmall(color: AppColors.primaryColor),
                          ),
                        ),
                        24.heightBox,
                        AppButton(
                          text: "Sign In",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.go(AppRoutes.mainNavigationScreenRoute);
                            }
                          },
                          color: AppColors.primaryColor,
                          textColor: Colors.white,
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ),
                ),
                32.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                    ).bodySmall(color: Colors.white.withOpacity(0.7)),
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.signUpScreenRoute),
                      child: const Text("Sign Up").labelMedium(
                        color: AppColors.accent,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ).px24(),
          ),
        ),
      ),
    );
  }
}
