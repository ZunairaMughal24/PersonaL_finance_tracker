import 'package:flutter/material.dart';

class TransactionTypeToggle extends StatefulWidget {
  final Function(bool) onChanged;
  const TransactionTypeToggle({super.key, required this.onChanged});

  @override
  State<TransactionTypeToggle> createState() => _TransactionTypeToggleState();
}

class _TransactionTypeToggleState extends State<TransactionTypeToggle> {
  bool isIncome = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05), // Subtle dark background
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          // 1. The Animated Background "Pill"
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: isIncome ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: (width - 40) / 2, // Accounting for padding
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                // Color changes based on selection
                color: isIncome ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isIncome ? Colors.green : Colors.red,
                  width: 1,
                ),
              ),
            ),
          ),
          
          // 2. The Text Options
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => isIncome = true);
                    widget.onChanged(true);
                  },
                  child: Center(
                    child: Text(
                      "Income",
                      style: TextStyle(
                        color: isIncome ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => isIncome = false);
                    widget.onChanged(false);
                  },
                  child: Center(
                    child: Text(
                      "Expense",
                      style: TextStyle(
                        color: !isIncome ? Colors.red : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}