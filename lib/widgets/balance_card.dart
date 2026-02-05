import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';
import 'package:personal_finance_tracker/core/utils/date_formatter.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';
import 'package:personal_finance_tracker/providers/user_settings_provider.dart';
import 'package:provider/provider.dart';

class TotalBalanceCard extends StatelessWidget {
  final double totalBalance;

  const TotalBalanceCard({super.key, required this.totalBalance});

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
              color: Colors.black.withOpacity(0.3),
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
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.5),
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
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.02),
                  ],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
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
                              const Text('PERSONAL WALLET').labelSmall(
                                color: Colors.white.withOpacity(0.8),
                                weight: FontWeight.w800,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Smart Finance Companion',
                              ).caption(color: Colors.white.withOpacity(0.6)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
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
                                CurrencyUtils.formatAmount(
                                  totalBalance,
                                  settings.selectedCurrency,
                                ),
                              ).mono(
                                fontSize: 28,
                                weight: FontWeight.w600,
                                color: Colors.white,
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
                              const Text('LAST UPDATED').labelSmall(
                                color: Colors.white.withOpacity(0.5),
                                weight: FontWeight.w700,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateUtilsCustom.formatFullDate(today),
                              ).caption(
                                color: Colors.white.withOpacity(0.9),
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
                                      color: Colors.white.withOpacity(0.2),
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
                                      color: Colors.white.withOpacity(0.1),
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
