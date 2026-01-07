import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:personal_finance_tracker/core/constants/category_const.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Spending Analytic"), centerTitle: true),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          final summary = provider.spendingSummary;

          if (summary.categoryTotals.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              const SizedBox(height: 30),
              _buildPieChart(summary.categoryTotals, summary.grandTotal),
              const SizedBox(height: 40),
              _buildLegend(summary.categoryTotals),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        "No data to display",
        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
      ),
    );
  }

  Widget _buildPieChart(Map<String, double> categoryTotals, double grandTotal) {
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 75,
              sections: _buildPieChartSections(categoryTotals),
            ),
          ),
          _buildCenterText(grandTotal),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
    Map<String, double> categoryTotals,
  ) {
    return categoryTotals.entries.map((entry) {
      final color = categoryDetails[entry.key]?.color ?? Colors.grey;
      return PieChartSectionData(
        color: color,
        value: entry.value,
        radius: 45,
        showTitle: false,
      );
    }).toList();
  }

  Widget _buildCenterText(double grandTotal) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Total Spent",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "\$${grandTotal.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Map<String, double> categoryTotals) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        itemCount: categoryTotals.length,
        itemBuilder: (context, index) {
          final category = categoryTotals.keys.elementAt(index);
          final amount = categoryTotals.values.elementAt(index);
          return _buildLegendItem(category, amount);
        },
      ),
    );
  }

  Widget _buildLegendItem(String category, double amount) {
    final color = categoryDetails[category]?.color ?? Colors.grey;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 15),
          Text(
            category,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
