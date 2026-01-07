import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';

class InfoBox extends StatelessWidget {
  final String title;
  final String amount;
  final Color amountColor;

  const InfoBox({
    super.key,
    required this.title,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 150,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 44, 51, 86),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          4.heightBox,
          Text(amount, style: TextStyle(fontSize: 18, color: amountColor)),
        ],
      ),
    );
  }
}
