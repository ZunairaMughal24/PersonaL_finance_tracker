import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/utils/toast_utility.dart';
import 'package:provider/provider.dart';
import 'package:montage/config/router.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/validators.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/providers/auth_provider.dart';
import 'package:montage/viewmodels/auth_form_view_model.dart';
import 'package:montage/widgets/app_button.dart';
import 'package:montage/widgets/app_text_field.dart';
import 'package:montage/widgets/auth_form_card.dart';
import 'package:montage/widgets/password_visibility_toggle.dart';
import 'package:montage/widgets/app_background.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignUpContent();
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
    final auth = context.watch<AuthProvider>();
    final form = context.watch<AuthFormViewModel>();

    return Scaffold(
      body: AppBackground(
        style: BackgroundStyle.authVibrant,
        resizeToAvoidBottomInset: true,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                80.heightBox,
                AuthFormCard(
                  formKey: _formKey,
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
                      controller: form.signUpUsernameController,
                      validator: Validators.usernameValidator,
                      errorText: form.signUpUsernameError,
                      onChanged: (_) =>
                          form.clearErrors(field: 'signUpUsername'),
                      textInputAction: TextInputAction.next,
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
                      controller: form.signUpEmailController,
                      validator: Validators.emailValidator,
                      errorText: form.signUpEmailError,
                      onChanged: (_) => form.clearErrors(field: 'signUpEmail'),
                      textInputAction: TextInputAction.next,
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
                      controller: form.signUpPasswordController,
                      obscureText: !form.isSignUpPasswordVisible,
                      validator: Validators.passwordValidator,
                      errorText: form.signUpPasswordError,
                      onChanged: (_) =>
                          form.clearErrors(field: 'signUpPassword'),
                      textInputAction: TextInputAction.next,
                      prefixChild: const Icon(
                        Icons.lock_rounded,
                        color: Colors.white70,
                        size: 20,
                      ),
                      suffixChild: PasswordVisibilityToggle(
                        isVisible: form.isSignUpPasswordVisible,
                        onPressed: form.toggleSignUpPasswordVisibility,
                      ),
                    ),
                    12.heightBox,
                    AppTextField(
                      title: "Confirm Password",
                      hint: "Re-enter your password",
                      controller: form.signUpConfirmPasswordController,
                      obscureText: !form.isConfirmPasswordVisible,
                      validator: (val) => Validators.confirmPasswordValidator(
                        val,
                        form.signUpPasswordController.text,
                      ),
                      prefixChild: const Icon(
                        Icons.lock_rounded,
                        color: Colors.white70,
                        size: 20,
                      ),
                      suffixChild: PasswordVisibilityToggle(
                        isVisible: form.isConfirmPasswordVisible,
                        onPressed: form.toggleConfirmPasswordVisibility,
                      ),
                    ),
                    30.heightBox,
                    AppButton(
                      text: "Sign Up",
                      isLoading: auth.isLoading,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          auth
                              .signUp(
                                form.signUpEmailController.text.trim(),
                                form.signUpPasswordController.text.trim(),
                                form.signUpUsernameController.text.trim(),
                              )
                              .then((failure) {
                                if (!context.mounted) return;
                                if (failure == null) {
                                  context.go(
                                    AppRoutes.mainNavigationScreenRoute,
                                  );
                                } else if (failure.code != null) {
                                  form.handleSignUpFailure(failure);
                                } else {
                                  ToastUtils.show(context, failure.message);
                                }
                              });
                        }
                      },
                      color: AppColors.primaryColor.withValues(alpha: 0.4),
                      textColor: Colors.white,
                      width: double.infinity,
                    ),
                    20.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                        ).bodyMedium(color: Colors.white70),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.signInScreenRoute),
                          child: const Text("Sign In").bodyMedium(
                            color: Colors.white,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
