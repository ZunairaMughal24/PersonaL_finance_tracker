import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:montage/config/router.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/providers/category_provider.dart';
import 'package:montage/core/utils/currency_utils.dart';
import 'package:montage/domain/entities/transaction.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:montage/core/constants/app_images.dart';
import 'package:montage/widgets/app_background.dart';
import 'package:montage/widgets/app_button.dart';
import 'package:provider/provider.dart';

class TransactionDetailSheet extends StatelessWidget {
  final Transaction transaction;
  final String currency;

  const TransactionDetailSheet({
    super.key,
    required this.transaction,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = transaction.isIncome ? AppColors.green : AppColors.red;
    final catProvider = context.watch<CategoryProvider>();
    final iconColor = catProvider.getCategoryColor(transaction.category);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(38)),
      child: AppBackground(
        style: BackgroundStyle.detailSheet,
        expand: false,
        alignment: Alignment.bottomCenter,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: Stack(
            children: [
              GlassContainer(
                customBorderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
                blur: 24,
                showBottomBorder: false,
                showShadow: false,
                borderOpacity: 0.10,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                gradientColors: [
                  const Color(0xFF111827).withValues(alpha: 0.98),
                  const Color(0xFF0D1117).withValues(alpha: 0.98),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    20.heightBox,
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: iconColor.withValues(alpha: 0.2),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: iconColor.withValues(alpha: 0.12),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        catProvider.getIconForCategory(transaction.category),
                        color: iconColor,
                        size: 32,
                      ),
                    ),
                    12.heightBox,
                    Text(
                      transaction.category,
                      textAlign: TextAlign.center,
                    ).h2(color: Colors.white, weight: FontWeight.w700),
                    2.heightBox,
                    Text(transaction.isIncome ? "INCOME" : "EXPENSE").labelLarge(
                      color: statusColor.withValues(alpha: 0.7),
                      weight: FontWeight.w900,
                      letterSpacing: 1.5,
                      fontSize: 11,
                    ),
                    8.heightBox,
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        CurrencyUtils.formatAmount(transaction.amount, currency),
                      ).h1(color: statusColor, weight: FontWeight.w900, fontSize: 24),
                    ),
                    12.heightBox,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.06),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            iconPath: AppImages.calendar,
                            label: "DATE",
                            value: transaction.date,
                          ),
                          if (transaction.title.isNotEmpty) ...[
                            Divider(
                              color: Colors.white.withValues(alpha: 0.07),
                              height: 20,
                            ),
                            _buildInfoRow(
                              icon: Icons.notes_rounded,
                              label: "NOTE",
                              value: transaction.title,
                              isMultiline: true,
                            ),
                          ],
                          if (transaction.imagePath != null) ...[
                            Divider(
                              color: Colors.white.withValues(alpha: 0.07),
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  color: Colors.white.withValues(alpha: 0.6),
                                  size: 17,
                                ),
                                10.widthBox,
                                Text("MEDIA").labelLarge(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  weight: FontWeight.w600,
                                  letterSpacing: 1.1,
                                  fontSize: 12,
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    context.push(
                                      AppRoutes.imageViewScreenRoute,
                                      extra: transaction.imagePath!,
                                    );
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.1),
                                        width: 1,
                                      ),
                                      image: DecorationImage(
                                        image: FileImage(File(transaction.imagePath!)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    24.heightBox,
                    AppButton(
                      text: "Close",
                      onPressed: () => Navigator.pop(context),
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          statusColor.withValues(alpha: 0.18),
                          statusColor.withValues(alpha: 0.06),
                          const Color.fromARGB(0, 0, 0, 0),
                        ],
                        stops: const [0.0, 0.3, 1.0],
                      ),
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

  Widget _buildInfoRow({
    IconData? icon,
    String? iconPath,
    required String label,
    required String value,
    bool isMultiline = false,
  }) {
    return Row(
      crossAxisAlignment:
          isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        if (iconPath != null)
          SvgPicture.asset(
            iconPath,
            colorFilter: ColorFilter.mode(
              Colors.white.withValues(alpha: 0.5),
              BlendMode.srcIn,
            ),
            height: 16,
          )
        else
          Icon(icon, color: Colors.white.withValues(alpha: 0.6), size: 17),
        10.widthBox,
        Text(label).labelLarge(
          color: Colors.white.withValues(alpha: 0.6),
          weight: FontWeight.w600,
          letterSpacing: 1.1,
          fontSize: 12,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: isMultiline ? null : 1,
          ).labelLarge(
            color: Colors.white.withValues(alpha: 0.9),
            weight: FontWeight.w600,
            fontSize: label == "DATE" ? 16 : 15,
          ),
        ),
      ],
    );
  }
}
