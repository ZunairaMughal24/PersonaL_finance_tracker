import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/widgets/appTextField.dart';

class TransactionTitleField extends StatelessWidget {
  final TextEditingController controller;

  const TransactionTitleField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AppTextField(
        title: "Title",
        hint: "What is this for?",
        controller: controller,
        validator: (val) => val!.isEmpty ? "Required" : null,
      ),
    );
  }
}
