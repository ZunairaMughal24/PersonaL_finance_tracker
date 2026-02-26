import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AIInsightsCard extends StatelessWidget {
  final TransactionProvider txProvider;

  const AIInsightsCard({super.key, required this.txProvider});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: txProvider.insightsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.data == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(24),
              ),
            ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1.5.seconds),
          );
        }

        final insights = snapshot.data ?? txProvider.cachedInsightsValue;
        if (insights == null || insights.isEmpty)
          return const SizedBox.shrink();

        return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.03),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.02),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -10,
                        right: -10,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor.withOpacity(0.05),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                                  Icons.auto_awesome,
                                  color: AppColors.primaryColor,
                                  size: 22,
                                )
                                .animate(onPlay: (c) => c.repeat())
                                .shimmer(
                                  duration: 4.seconds,
                                  color: Colors.white24,
                                ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                insights,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.95),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 1000.ms)
            .slideX(begin: 0.05, curve: Curves.easeOut);
      },
    );
  }
}
