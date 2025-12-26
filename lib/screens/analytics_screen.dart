import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:personal_finance_tracker/core/contants/category_const.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';


class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spending Analytics"),
        centerTitle: true,
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          // 1. Call your logic
          final results = provider.calculateTotals();
          
          final Map<String, double> categoryTotals = results['categoryTotals'];
          final double grandTotal = results['grandTotal'];

          if (categoryTotals.isEmpty) {
            return const Center(child: Text("No data to display"));
          }

          return Column(
            children: [
              const SizedBox(height: 30),
              
              // --- THE PIE CHART SECTION ---
              SizedBox(
                height: 250,
                child: Stack(
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 75,
                        sections: categoryTotals.entries.map((entry) {
                          // Look up color from your constant map
                          final color = categoryDetails[entry.key]?.color ?? Colors.grey;
                          return PieChartSectionData(
                            color: color,
                            value: entry.value,
                            radius: 45,
                            showTitle: false, // Cleaner look
                          );
                        }).toList(),
                      ),
                    ),
                    // Center Text
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Total Spent", 
                            style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                          Text(
                            "\$${grandTotal.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 22, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // --- THE LEGEND SECTION ---
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  itemCount: categoryTotals.length,
                  itemBuilder: (context, index) {
                    String category = categoryTotals.keys.elementAt(index);
                    double amount = categoryTotals.values.elementAt(index);
                    Color color = categoryDetails[category]?.color ?? Colors.grey;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(category, style: const TextStyle(fontSize: 16)),
                          const Spacer(),
                          Text(
                            "\$${amount.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}