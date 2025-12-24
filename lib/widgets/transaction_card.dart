import 'package:flutter/material.dart';

import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.title,
    required this.amount,
    required this.type,
  });
  final String title;
  final String amount;
  final String type;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            8.heightBox,
            Text(amount),
            8.heightBox,
            Text(type, style: TextStyle(fontSize: 16, color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
