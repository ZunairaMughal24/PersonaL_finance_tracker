import 'package:flutter/material.dart';

@Deprecated('Use implementations in analytics_screen.dart')
class AnalyticsChartSection extends StatelessWidget {
  final Map<String, double> categoryTotals;
  final double grandTotal;
  final PageController controller;
  final Function(int) onPageChanged;

  const AnalyticsChartSection({
    super.key,
    required this.categoryTotals,
    required this.grandTotal,
    required this.controller,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
