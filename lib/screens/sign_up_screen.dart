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
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/widgets/app_button.dart';
import 'package:montage/widgets/app_text_field.dart';
import 'package:montage/core/utils/animation_utils.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/widgets/app_background.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:montage/core/constants/app_images.dart';

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
    final provider = context.watch<AuthProvider>();

    return Scaffold(
      body: AppBackground(
        style: BackgroundStyle.authVibrant,
        resizeToAvoidBottomInset: true,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                80.heightBox,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: FadeSlideTransition(
                    duration: const Duration(milliseconds: 1200),
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
                              controller: provider.usernameController,
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
                              controller: provider.emailController,
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
                              controller: provider.passwordController,
                              obscureText: !provider.isSignUpPasswordVisible,
                              validator: Validators.passwordValidator,
                              prefixChild: const Icon(
                                Icons.lock_rounded,
                                color: Colors.white70,
                                size: 20,
                              ),
                              suffixChild: IconButton(
                                onPressed:
                                    provider.toggleSignUpPasswordVisibility,
                                icon: provider.isSignUpPasswordVisible
                                    ? Icon(
                                        Icons.visibility,
                                        color: Colors.white.withValues(
                                          alpha: 0.35,
                                        ),
                                        size: 20,
                                      )
                                    : SvgPicture.asset(
                                        AppImages.eyeClosed,
                                        colorFilter: ColorFilter.mode(
                                          Colors.white.withValues(alpha: 0.35),
                                          BlendMode.srcIn,
                                        ),
                                        height: 20,
                                      ),
                              ),
                            ),
                            12.heightBox,
                            AppTextField(
                              title: "Confirm Password",
                              hint: "Re-enter your password",
                              controller: provider.confirmPasswordController,
                              obscureText: !provider.isConfirmPasswordVisible,
                              validator: (val) =>
                                  Validators.confirmPasswordValidator(
                                    val,
                                    provider.passwordController.text,
                                  ),
                              prefixChild: const Icon(
                                Icons.lock_rounded,
                                color: Colors.white70,
                                size: 20,
                              ),
                              suffixChild: IconButton(
                                onPressed:
                                    provider.toggleConfirmPasswordVisibility,
                                icon: provider.isConfirmPasswordVisible
                                    ? Icon(
                                        Icons.visibility,
                                        color: Colors.white.withValues(
                                          alpha: 0.35,
                                        ),
                                        size: 20,
                                      )
                                    : SvgPicture.asset(
                                        AppImages.eyeClosed,
                                        colorFilter: ColorFilter.mode(
                                          Colors.white.withValues(alpha: 0.35),
                                          BlendMode.srcIn,
                                        ),
                                        height: 20,
                                      ),
                              ),
                            ),
                            30.heightBox,
                            AppButton(
                              text: "Sign Up",
                              isLoading: provider.isLoading,
                              onPressed: () {
                                final usernameError =
                                    Validators.usernameValidator(
                                      provider.usernameController.text,
                                    );
                                final emailError = Validators.emailValidator(
                                  provider.emailController.text,
                                );
                                final passwordError =
                                    Validators.passwordValidator(
                                      provider.passwordController.text,
                                    );
                                final confirmError =
                                    Validators.confirmPasswordValidator(
                                      provider.confirmPasswordController.text,
                                      provider.passwordController.text,
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

                                provider
                                    .signUp()
                                    .then((credential) {
                                      if (!context.mounted) return;
                                      if (credential != null) {
                                        final user = credential.user;
                                        final settings = context
                                            .read<UserSettingsProvider>();
                                        settings.setUserEmail(
                                          user?.email ?? "",
                                        );
                                        settings.setUserName(
                                          provider.usernameController.text
                                              .trim(),
                                        );
                                        context.go(
                                          AppRoutes.mainNavigationScreenRoute,
                                        );
                                      }
                                    })
                                    .catchError((e) {
                                      if (context.mounted) {
                                        ToastUtils.show(context, e.toString());
                                      }
                                    });
                              },
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.4,
                              ),
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
                                  onTap: () =>
                                      context.go(AppRoutes.signInScreenRoute),
                                  child: const Text("Sign In").bodyMedium(
                                    color: Colors.white,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
