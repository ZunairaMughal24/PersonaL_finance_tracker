import 'package:flutter/material.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/services/export_service.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/widgets/app_bottom_sheet.dart';

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
    return AppBottomSheet.show(
      context: context,
      child: ExportBottomSheet(
        transactions: transactions,
        userName: userName,
        currency: currency,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Export Results",
        ).titleLarge(color: Colors.white, weight: FontWeight.bold),
        8.heightBox,
        Text(
          "Total items: ${transactions.length}",
        ).bodyLarge(color: Colors.white.withValues(alpha: 0.6)),
        24.heightBox,
        _buildExportOption(
          context,
          icon: Icons.share_rounded,
          title: "Share as Text",
          subtitle: "Send a quick summary to any app",
          color: Colors.blueAccent,
          onTap: () {
            Navigator.pop(context);
            ExportService.exportToText(transactions, userName);
          },
        ),
        12.heightBox,
        _buildExportOption(
          context,
          icon: Icons.picture_as_pdf_rounded,
          title: "Export as PDF",
          subtitle: "Generate a professional document",
          color: Colors.redAccent,
          onTap: () {
            Navigator.pop(context);
            ExportService.exportToPDF(transactions, currency, userName);
          },
        ),
        12.heightBox,
        _buildExportOption(
          context,
          icon: Icons.description_rounded,
          title: "Export as CSV",
          subtitle: "Detailed data for spreadsheets",
          color: Colors.greenAccent,
          onTap: () {
            Navigator.pop(context);
            ExportService.exportToExcel(transactions, userName);
          },
        ),
      ],
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: GlassContainer(
        borderRadius: 18,
        blur: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        gradientColors: [
          Colors.white.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.02),
        ],
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            16.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                  ).titleMedium(color: Colors.white, weight: FontWeight.w600),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                  ).bodySmall(color: Colors.white.withValues(alpha: 0.5)),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
