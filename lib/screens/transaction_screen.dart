import 'package:flutter/material.dart';

import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/date_formatter.dart';
import 'package:personal_finance_tracker/core/utils/padding_extention.dart';
import 'package:personal_finance_tracker/core/utils/validators.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/models/transaction_model.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:personal_finance_tracker/services/database_services.dart';
import 'package:personal_finance_tracker/widgets/Custome_Date_picker.dart';
import 'package:personal_finance_tracker/widgets/appButton.dart';
import 'package:personal_finance_tracker/widgets/appTextField.dart';
import 'package:personal_finance_tracker/widgets/transaction_type_toggle.dart';
import 'package:provider/provider.dart';

class TransactionScreen extends StatefulWidget {
 const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isIncome = true;
  DateTime? _selectedDate;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final DatabaseService db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final transaction = Provider.of<TransactionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Transaction',
          style: TextStyle(color: AppColors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              30.heightBox,

              AppTextField(
                title: "Title",
                hint: "Add transaction title",
                controller: _titleController,
                validator: Validators.title,
              ),
              8.heightBox,

              AppTextField(
                title: "Amount",
                hint: r"$ 0.00",
                controller: _amountController,
                validator: Validators.amount,
                keyboardType: TextInputType.number,
              ),
              14.heightBox,

           
              TransactionTypeToggle(
                onChanged: (value) {
                  setState(() {
                    isIncome = value;
                  });
                  print("Selected: ${isIncome ? 'Income' : 'Expense'}");
                },
              ),
              8.heightBox,

              CustomDatePicker(
                selectedDate: _selectedDate,
                onDateSelected: (newDate) {
                  setState(() {
                    _selectedDate = newDate;

                    _dateController.text = DateUtilsCustom.formatDate(newDate);
                  });
                },
              ),

              8.heightBox,

              AppTextField(
                title: "Category",
                hint: "Select a category",
                controller: _categoryController,
                validator: Validators.category,
              ),
              50.heightBox,

              AppButton(
                text: "Save Transaction",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final amount = double.tryParse(_amountController.text);
                    if (amount == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Enter a valid amount")),
                      );
                      return;
                    }

                    transaction.addTransaction(
                      //sending all data at once as model object
                      TransactionModel(
                        title: _titleController.text.trim(),
                        amount: amount,
                        isIncome: isIncome,
                        date: _dateController.text.trim(),
                        category: _categoryController.text.trim(),
                      ),
                    );

                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ).px16(),
        ),
      ),
    ).safeArea();
  }
}
