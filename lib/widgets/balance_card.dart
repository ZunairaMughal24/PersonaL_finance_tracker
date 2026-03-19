import 'package:flutter/material.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/date_formatter.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/core/utils/currency_utils.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:provider/provider.dart';

class TotalBalanceCard extends StatelessWidget {
  final double totalBalance;
  final bool hasEntries;

  const TotalBalanceCard({
    super.key,
    required this.totalBalance,
    this.hasEntries = true,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return Consumer<UserSettingsProvider>(
      builder: (context, settings, _) => Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  'https://images.unsplash.com/photo-1620641788421-7a1c342ea42e?q=80&w=2574&auto=format&fit=crop',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: const Color(0xFF0A0E27)),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.black.withValues(alpha: 0.2),
                        Colors.black.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: GlassContainer(
                  borderRadius: 20,
                  blur: 20,
                  gradientColors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.02),
                  ],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('PERSONAL WALLET').labelMedium(
                                color: Colors.white.withValues(alpha: 0.8),
                                weight: FontWeight.w800,
                              ),
                              const SizedBox(height: 2),
                              Text('Smart Finance Companion').labelMedium(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child:
                              Text(
                                totalBalance < 0
                                    ? "(${CurrencyUtils.formatAmount(totalBalance.abs(), settings.selectedCurrency)})"
                                    : CurrencyUtils.formatAmount(
                                        totalBalance,
                                        settings.selectedCurrency,
                                      ),
                              ).mono(
                                fontSize: 28,
                                weight: FontWeight.w600,
                                color: totalBalance < 0
                                    ? Colors.redAccent.withValues(alpha: 0.9)
                                    : Colors.white,
                              ),
                        ),
                      ),
                      6.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                hasEntries ? 'LAST UPDATED' : 'ACCOUNT STATUS',
                              ).labelSmall(
                                color: Colors.white.withValues(alpha: 0.6),
                                weight: FontWeight.w700,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                hasEntries
                                    ? DateUtilsCustom.formatFullDate(today)
                                    : 'Awaiting first entry',
                              ).caption(
                                color: Colors.white.withValues(alpha: 0.9),
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 26,
                            width: 44,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
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
