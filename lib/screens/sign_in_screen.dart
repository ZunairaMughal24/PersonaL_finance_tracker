import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:montage/config/router.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/toast_utility.dart';
import 'package:montage/core/utils/validators.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/providers/auth_provider.dart';
import 'package:montage/viewmodels/auth_form_view_model.dart';
import 'package:montage/widgets/app_button.dart';
import 'package:montage/widgets/app_text_field.dart';
import 'package:montage/widgets/auth_form_card.dart';
import 'package:montage/widgets/password_visibility_toggle.dart';
import 'package:montage/widgets/app_background.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignInContent();
  }
}

class SignInContent extends StatefulWidget {
  const SignInContent({super.key});

  @override
  State<SignInContent> createState() => _SignInContentState();
}

class _SignInContentState extends State<SignInContent> {
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
                140.heightBox,
                AuthFormCard(
                  formKey: _formKey,
                  children: [
                    14.heightBox,
                    const Text(
                      "Welcome Back",
                    ).h1(color: Colors.white, fontSize: 24),
                    6.heightBox,
                    const Text(
                      "Please sign in to your account",
                      textAlign: TextAlign.center,
                    ).bodyMedium(color: Colors.white70),
                    20.heightBox,
                    AppTextField(
                      title: "Email Address",
                      hint: "Enter your email",
                      controller: form.signInEmailController,
                      validator: Validators.emailValidator,
                      errorText: form.signInEmailError,
                      onChanged: (_) => form.clearErrors(field: 'signInEmail'),
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
                      hint: "Enter your password",
                      controller: form.signInPasswordController,
                      obscureText: !form.isSignInPasswordVisible,
                      validator: Validators.passwordValidator,
                      errorText: form.signInPasswordError,
                      onChanged: (_) =>
                          form.clearErrors(field: 'signInPassword'),
                      textInputAction: TextInputAction.done,
                      prefixChild: const Icon(
                        Icons.lock_rounded,
                        color: Colors.white70,
                        size: 20,
                      ),
                      suffixChild: PasswordVisibilityToggle(
                        isVisible: form.isSignInPasswordVisible,
                        onPressed: form.toggleSignInPasswordVisibility,
                      ),
                    ),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: form.rememberMe,
                                onChanged: form.toggleRememberMe,
                                side: const BorderSide(color: Colors.white70),
                                checkColor: AppColors.primaryColor,
                                activeColor: Colors.white,
                              ),
                            ),
                            8.widthBox,
                            const Text(
                              "Remember me",
                            ).bodyMedium(color: Colors.white70),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "Forgot Password?",
                          ).bodyMedium(color: Colors.white70),
                        ),
                      ],
                    ),
                    30.heightBox,
                    AppButton(
                      text: "Login",
                      isLoading: auth.isLoading,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          auth
                              .signIn(
                                form.signInEmailController.text.trim(),
                                form.signInPasswordController.text.trim(),
                              )
                              .then((failure) {
                                if (!context.mounted) return;
                                if (failure == null) {
                                  context.go(
                                    AppRoutes.mainNavigationScreenRoute,
                                  );
                                } else if (failure.code != null) {
                                  form.handleSignInFailure(failure);
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
                          "Don't have an account? ",
                        ).bodyMedium(color: Colors.white70),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.signUpScreenRoute),
                          child: const Text("Sign Up").bodyMedium(
                            color: Colors.white,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    5.heightBox,
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
