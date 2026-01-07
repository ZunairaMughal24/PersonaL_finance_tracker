import 'package:flutter/material.dart';

class TransactionTypeToggle extends StatelessWidget {
  final bool isIncome;
  final Function(bool) onChanged;

  const TransactionTypeToggle({
    super.key,
    required this.isIncome,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: isIncome ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: (width - 40) / 2,

              decoration: BoxDecoration(
                color: isIncome
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isIncome ? Colors.green : Colors.red,
                  width: 1,
                ),
              ),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!isIncome) onChanged(true);
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
                    if (isIncome) onChanged(false);
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
