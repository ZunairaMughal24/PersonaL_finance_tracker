import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:personal_finance_tracker/config/router.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';
import 'package:personal_finance_tracker/core/utils/toast_utility.dart';
import 'package:personal_finance_tracker/core/utils/validators.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/providers/auth_provider.dart';
import 'package:personal_finance_tracker/widgets/appButton.dart';
import 'package:personal_finance_tracker/widgets/appTextField.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';
import 'package:personal_finance_tracker/widgets/app_background.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const SignInContent(),
    );
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

    return AppBackground(
      style: BackgroundStyle.authVibrant,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              140.heightBox,
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
                        Text(
                          "Welcome Back",
                        ).h1(color: Colors.white, fontSize: 24),
                        6.heightBox,
                        Text(
                          "Please sign in to your account",
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
                            onPressed: provider.toggleSignInPasswordVisibility,
                            icon: Icon(
                              provider.isSignInPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white.withOpacity(0.35),
                              size: 20,
                            ),
                          ),
                        ),
                        8.heightBox,
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
                                text: TextSpan(
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
                            final usernameError = Validators.usernameValidator(
                              provider.usernameController.text,
                            );
                            final passwordError = Validators.passwordValidator(
                              provider.passwordController.text,
                            );

                            if (usernameError != null) {
                              ToastUtils.show(context, usernameError);
                              return;
                            }
                            if (passwordError != null) {
                              ToastUtils.show(context, passwordError);
                              return;
                            }

                            provider.signIn().then((_) {
                              context.go(AppRoutes.mainNavigationScreenRoute);
                            });
                          },

                          color: AppColors.primaryColor.withOpacity(0.4),
                          textColor: Colors.white,
                          width: double.infinity,
                        ),
                        12.heightBox,
                        AppButton(
                          text: "Login with Google",
                          onPressed: provider.signInWithGoogle,
                          color: Colors.transparent,
                          textColor: Colors.white,
                          width: double.infinity,
                          borderColor: Colors.white.withOpacity(0.5),
                          icon: const Icon(
                            Icons.g_mobiledata_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        20.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                            ).bodyMedium(color: Colors.white70),
                            GestureDetector(
                              onTap: () =>
                                  context.push(AppRoutes.signUpScreenRoute),
                              child: Text("Sign Up").bodyMedium(
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
            ],
          ),
        ),
      ),
    );
  }
}
