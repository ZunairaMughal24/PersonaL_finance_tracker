import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/contants/appColors.dart';
import 'package:personal_finance_tracker/core/contants/utils/padding_extention.dart';
import 'package:personal_finance_tracker/core/contants/utils/validators.dart';
import 'package:personal_finance_tracker/core/contants/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/models/transaction_model.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:personal_finance_tracker/services/database_services.dart';
import 'package:personal_finance_tracker/widgets/appButton.dart';
import 'package:personal_finance_tracker/widgets/appTextField.dart';
import 'package:provider/provider.dart';

class EditTransactionScreen extends StatefulWidget {
  EditTransactionScreen({super.key});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
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

              /// Title
              AppTextField(
                title: "Title",
                hint: "Add transaction title",
                controller: _titleController,
                validator: Validators.title,
              ),
              8.heightBox,

              /// Amount
              AppTextField(
                title: "Amount",
                hint: r"$ 0.00",
                controller: _amountController,
                validator: Validators.amount,
                keyboardType: TextInputType.number,
              ),
              8.heightBox,

              /// Type (Income/Expense)
              AppTextField(
                title: "Type",
                hint: "Income / Expense",
                controller: _typeController,
                validator: Validators.type,
              ),
              8.heightBox,

              /// Date
              AppTextField(
                title: "Date",
                hint: "Select a date",
                controller: _dateController,
                validator: Validators.emptyValidator,
                prefixChild: const Icon(
                  Icons.calendar_month,
                  color: AppColors.grey,
                  size: 20,
                ),
              ),
              8.heightBox,

              /// Category
              AppTextField(
                title: "Category",
                hint: "Select a category",
                controller: _categoryController,
                validator: Validators.category,
               
              ),
              50.heightBox,

              /// Save Button
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
                    //function all
                      transaction.addTransaction(
                      //sending all data at once as model object
                      TransactionModel(
                        title: _titleController.text.trim(),
                        amount: amount,
                        isIncome: true,
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
