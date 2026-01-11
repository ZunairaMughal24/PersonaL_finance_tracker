import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/toast_utility.dart';
import 'package:provider/provider.dart';
import 'package:personal_finance_tracker/config/router.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';
import 'package:personal_finance_tracker/core/utils/validators.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:personal_finance_tracker/widgets/appButton.dart';
import 'package:personal_finance_tracker/widgets/appTextField.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';
import 'package:personal_finance_tracker/widgets/app_background.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: const SignUpContent(),
    );
  }
}

class SignUpContent extends StatefulWidget {
  const SignUpContent({super.key});

  @override
  State<SignUpContent> createState() => _SignUpContentState();
}

class _SignUpContentState extends State<SignUpContent> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();

    return AppBackground(
      style: BackgroundStyle.authVibrant,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              80.heightBox,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: GlassContainer(
                  borderRadius: 24,
                  borderOpacity: 0.1,
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        14.heightBox,
                        const Text(
                          "Create Account",
                        ).h1(color: Colors.white, fontSize: 24),
                        6.heightBox,
                        const Text(
                          "Sign up to start your journey",
                          textAlign: TextAlign.center,
                        ).bodyMedium(color: Colors.white70),
                        20.heightBox,
                        AppTextField(
                          title: "Username",
                          hint: "Enter your username",
                          controller: viewModel.usernameController,
                          validator: Validators.usernameValidator,
                          prefixChild: const Icon(
                            Icons.person_rounded,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                        12.heightBox,
                        AppTextField(
                          title: "Email Address",
                          hint: "Enter your email",
                          controller: viewModel.emailController,
                          validator: Validators.emailValidator,
                          prefixChild: const Icon(
                            Icons.email_rounded,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                        12.heightBox,
                        AppTextField(
                          title: "Password",
                          hint: "Create a password",
                          controller: viewModel.passwordController,
                          obscureText: !viewModel.isSignUpPasswordVisible,
                          validator: Validators.passwordValidator,
                          prefixChild: const Icon(
                            Icons.lock_rounded,
                            color: Colors.white70,
                            size: 20,
                          ),
                          suffixChild: IconButton(
                            onPressed: viewModel.toggleSignUpPasswordVisibility,
                            icon: Icon(
                              viewModel.isSignUpPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white.withOpacity(0.35),
                              size: 20,
                            ),
                          ),
                        ),
                        12.heightBox,
                        AppTextField(
                          title: "Confirm Password",
                          hint: "Re-enter your password",
                          controller: viewModel.confirmPasswordController,
                          obscureText: !viewModel.isConfirmPasswordVisible,
                          validator: (val) =>
                              Validators.confirmPasswordValidator(
                                val,
                                viewModel.passwordController.text,
                              ),
                          prefixChild: const Icon(
                            Icons.lock_rounded,
                            color: Colors.white70,
                            size: 20,
                          ),
                          suffixChild: IconButton(
                            onPressed:
                                viewModel.toggleConfirmPasswordVisibility,
                            icon: Icon(
                              viewModel.isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white.withOpacity(0.35),
                              size: 20,
                            ),
                          ),
                        ),
                        30.heightBox,
                        AppButton(
                          text: "Sign Up",
                          isLoading: viewModel.isLoading,
                          onPressed: () {
                            final usernameError = Validators.usernameValidator(
                              viewModel.usernameController.text,
                            );
                            final emailError = Validators.emailValidator(
                              viewModel.emailController.text,
                            );
                            final passwordError = Validators.passwordValidator(
                              viewModel.passwordController.text,
                            );
                            final confirmError =
                                Validators.confirmPasswordValidator(
                                  viewModel.confirmPasswordController.text,
                                  viewModel.passwordController.text,
                                );

                            if (usernameError != null) {
                              ToastUtils.show(context, usernameError);
                              return;
                            }
                            if (emailError != null) {
                              ToastUtils.show(context, emailError);
                              return;
                            }
                            if (passwordError != null) {
                              ToastUtils.show(context, passwordError);
                              return;
                            }
                            if (confirmError != null) {
                              ToastUtils.show(context, confirmError);
                              return;
                            }

                            viewModel.signUp().then((_) {
                              context.go(AppRoutes.mainNavigationScreenRoute);
                            });
                          },
                          color: AppColors.primaryColor.withOpacity(0.4),
                          textColor: Colors.white,
                          width: double.infinity,
                        ),
                        20.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                            ).bodyMedium(color: Colors.white70),
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: const Text("Sign In").bodyMedium(
                                color: Colors.white,
                                weight: FontWeight.bold,
                                // decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
