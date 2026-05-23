import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/services/export_service.dart';
import 'package:montage/widgets/glass_container.dart';

class ExportBottomSheet extends StatelessWidget {
  final List<TransactionModel> transactions;
  final String userName;
  final String currency;

  const ExportBottomSheet({
    super.key,
    required this.transactions,
    required this.userName,
    required this.currency,
  });

  static Future<void> show({
    required BuildContext context,
    required List<TransactionModel> transactions,
    required String userName,
    required String currency,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ExportBottomSheet(
        transactions: transactions,
        userName: userName,
        currency: currency,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 24,
      blur: 20,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      gradientColors: [
        Colors.white.withValues(alpha: 0.15),
        AppColors.primaryColor.withValues(alpha: 0.1),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          24.heightBox,
          Text(
            "Export Results",
          ).h2(color: Colors.white, weight: FontWeight.bold),
          8.heightBox,
          Text(
            "Total items: ${transactions.length}",
          ).bodyMedium(color: Colors.white.withValues(alpha: 0.5)),
          24.heightBox,
          _buildExportOption(
            context,
            icon: Icons.text_snippet_outlined,
            title: "Share as Text",
            subtitle: "Send a quick summary to any app",
            color: Colors.blueAccent,
            onTap: () {
              Navigator.pop(context);
              ExportService.exportToText(transactions, userName);
            },
          ),
          16.heightBox,
          _buildExportOption(
            context,
            icon: Icons.picture_as_pdf_outlined,
            title: "Export as PDF",
            subtitle: "Generate a professional document",
            color: Colors.redAccent,
            onTap: () {
              Navigator.pop(context);
              ExportService.exportToPDF(transactions, currency, userName);
            },
          ),
          16.heightBox,
          _buildExportOption(
            context,
            icon: Icons.table_chart_outlined,
            title: "Export as Excel/CSV",
            subtitle: "Detailed data for spreadsheets",
            color: Colors.greenAccent,
            onTap: () {
              Navigator.pop(context);
              ExportService.exportToExcel(transactions, userName);
            },
          ),
          32.heightBox,
        ],
      ),
    );
  }

  Widget _buildExportOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        borderRadius: 16,
        padding: const EdgeInsets.all(16),
        gradientColors: [
          Colors.white.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.02),
        ],
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            16.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title).titleMedium(color: Colors.white),
                  4.heightBox,
                  Text(
                    subtitle,
                  ).bodySmall(color: Colors.white.withValues(alpha: 0.4)),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}
