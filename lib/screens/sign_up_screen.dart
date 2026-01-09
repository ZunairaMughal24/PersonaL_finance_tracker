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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
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
                40.heightBox,
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                30.heightBox,
                Text("Create Account").h1(color: Colors.white),
                8.heightBox,
                Text(
                  "Start managing your finances professionally",
                ).bodyMedium(color: Colors.white.withOpacity(0.7)),
                32.heightBox,
                GlassContainer(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppTextField(
                          title: "Full Name",
                          hint: "John Doe",
                          controller: _nameController,
                          validator: Validators.nameValidator,
                          prefixChild: Icon(
                            Icons.person_outline_rounded,
                            color: AppColors.primaryColor.withOpacity(0.7),
                            size: 20,
                          ),
                        ),
                        20.heightBox,
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
                        32.heightBox,
                        AppButton(
                          text: "Create Account",
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
                      "Already have an account? ",
                    ).bodySmall(color: Colors.white.withOpacity(0.7)),
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.signInScreenRoute),
                      child: Text("Sign In").labelMedium(
                        color: AppColors.accent,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ).px(24),
          ),
        ),
      ),
    );
  }
}
