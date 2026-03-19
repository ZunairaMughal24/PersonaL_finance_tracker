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
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/widgets/app_button.dart';
import 'package:montage/widgets/app_text_field.dart';
import 'package:montage/core/utils/animation_utils.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/widgets/app_background.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:montage/core/constants/app_images.dart';

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
    final provider = context.watch<AuthProvider>();

    return Scaffold(
      body: AppBackground(
        style: BackgroundStyle.authVibrant,
        resizeToAvoidBottomInset: true,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                140.heightBox,
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
                              hint: "Enter your password",
                              controller: provider.passwordController,
                              obscureText: !provider.isSignInPasswordVisible,
                              validator: Validators.passwordValidator,
                              prefixChild: const Icon(
                                Icons.lock_rounded,
                                color: Colors.white70,
                                size: 20,
                              ),
                              suffixChild: IconButton(
                                onPressed:
                                    provider.toggleSignInPasswordVisibility,
                                icon: provider.isSignInPasswordVisible
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
                                        value: provider.rememberMe,
                                        onChanged: provider.toggleRememberMe,
                                        side: const BorderSide(
                                          color: Colors.white70,
                                        ),
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
                                  child: RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Forgot Password? ",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            30.heightBox,
                            AppButton(
                              text: "Login",
                              isLoading: provider.isLoading,
                              onPressed: () {
                                final emailError = Validators.emailValidator(
                                  provider.emailController.text,
                                );
                                final passwordError =
                                    Validators.passwordValidator(
                                      provider.passwordController.text,
                                    );
                                if (emailError != null) {
                                  ToastUtils.show(context, emailError);
                                  return;
                                }
                                if (passwordError != null) {
                                  ToastUtils.show(context, passwordError);
                                  return;
                                }

                                provider
                                    .signIn()
                                    .then((credential) {
                                      if (!context.mounted) return;
                                      if (credential != null) {
                                        final user = credential.user;
                                        final settings = context
                                            .read<UserSettingsProvider>();
                                        settings.setUserEmail(
                                          user?.email ?? "",
                                        );
                                        if (user?.displayName != null &&
                                            user!.displayName!.isNotEmpty) {
                                          settings.setUserName(
                                            user.displayName!,
                                          );
                                        }
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
                                  "Don't have an account? ",
                                ).bodyMedium(color: Colors.white70),
                                GestureDetector(
                                  onTap: () =>
                                      context.go(AppRoutes.signUpScreenRoute),
                                  child: const Text("Sign Up").bodyMedium(
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
