import 'package:flutter/material.dart';
import 'package:montage/core/utils/animation_utils.dart';
import 'package:montage/widgets/glass_container.dart';

class AuthFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> children;

  const AuthFormCard({
    super.key,
    required this.formKey,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: FadeSlideTransition(
        duration: const Duration(milliseconds: 1200),
        child: GlassContainer(
          borderRadius: 24,
          borderOpacity: 0.1,
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(children: children),
          ),
        ),
      ),
    );
  }
}
