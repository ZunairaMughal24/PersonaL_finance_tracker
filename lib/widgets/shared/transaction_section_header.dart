import 'package:flutter/material.dart';
import 'package:montage/core/themes/app_text_theme.dart';
import 'package:montage/core/themes/text_theme_extension.dart';

class TransactionSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? badgeText;
  final Widget? trailing;
  final double horizontalPadding;
  final double opacity;

  const TransactionSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.badgeText,
    this.trailing,
    this.horizontalPadding = 20,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    if (opacity == 0) return const SizedBox.shrink();

    return Opacity(
      opacity: opacity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 8,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                  ).labelLarge(color: Colors.white, weight: FontWeight.bold),
                  if (subtitle != null) ...[
                    Text(subtitle!).bodyMedium(
                      color: Colors.white.withValues(alpha: 0.8),
                      weight: FontWeight.w500,
                    ),
                  ],
                ],
              ),
            ),
            if (badgeText != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  badgeText!,
                  style: AppTextTheme.body(
                    color: Colors.white70,
                    weight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
