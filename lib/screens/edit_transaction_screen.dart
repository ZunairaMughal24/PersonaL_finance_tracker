import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/constants/category_constants.dart';
import 'package:personal_finance_tracker/models/transaction_model.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:personal_finance_tracker/viewmodels/transaction_form_view_model.dart';
import 'package:personal_finance_tracker/widgets/appButton.dart';
import 'package:personal_finance_tracker/widgets/transaction_type_toggle.dart';
import 'package:personal_finance_tracker/widgets/category_selector.dart';
import 'package:personal_finance_tracker/widgets/custom_keypad.dart';
import 'package:personal_finance_tracker/widgets/transaction/amount_display.dart';
import 'package:personal_finance_tracker/widgets/transaction/transaction_date_picker.dart';
import 'package:personal_finance_tracker/widgets/transaction/transaction_title_field.dart';
import 'package:provider/provider.dart';

class EditTransactionScreen extends StatelessWidget {
  const EditTransactionScreen({super.key, required this.transaction});
  final TransactionModel transaction;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionFormViewModel(transaction: transaction),
      child: _EditTransactionScreenContent(
        transactionKey: transaction.key as int,
      ),
    );
  }
}

class _EditTransactionScreenContent extends StatefulWidget {
  final int transactionKey;
  const _EditTransactionScreenContent({required this.transactionKey});

  @override
  State<_EditTransactionScreenContent> createState() =>
      _EditTransactionScreenContentState();
}

class _EditTransactionScreenContentState
    extends State<_EditTransactionScreenContent> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<TransactionFormViewModel>(context, listen: false);
    _titleController = TextEditingController(text: vm.title);

    _titleController.addListener(() {
      Provider.of<TransactionFormViewModel>(
        context,
        listen: false,
      ).setTitle(_titleController.text);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _updateTransaction(BuildContext context) {
    final vm = Provider.of<TransactionFormViewModel>(context, listen: false);
    final error = vm.validate();

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    Provider.of<TransactionProvider>(
      context,
      listen: false,
    ).updateTransaction(widget.transactionKey, vm.getTransactionModel());

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionFormViewModel>(
      builder: (context, vm, child) {
        return GestureDetector(
          onTap: () => vm.toggleKeypad(false),
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text(
                'Edit Transaction',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Center(
                          child: Container(
                            width: 60,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        AmountDisplay(
                          amount: vm.amount,
                          currency: vm.selectedCurrency,
                          isIncome: vm.isIncome,
                          onTap: () => vm.toggleKeypad(true),
                        ),

                        const SizedBox(height: 20),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TransactionTypeToggle(
                            isIncome: vm.isIncome,

                            onChanged: (val) => vm.toggleType(val),
                          ),
                        ),
                        const SizedBox(height: 20),

                        TransactionTitleField(controller: _titleController),

                        const SizedBox(height: 20),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Category",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        CategorySelector(
                          selectedCategory: vm.selectedCategory,
                          categories: vm.isIncome
                              ? CategoryConstants.incomeCategories
                              : CategoryConstants.expenseCategories,
                          onCategorySelected: (cat) => vm.setCategory(cat),
                        ),

                        const SizedBox(height: 20),

                        TransactionDatePicker(
                          selectedDate: vm.selectedDate,
                          onDateChanged: (newDate) => vm.setDate(newDate),
                        ),

                        const SizedBox(height: 40),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: AppButton(
                            text: "Update Transaction",
                            onPressed: () => _updateTransaction(context),
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: vm.showKeypad ? 350 : 0,
                  curve: Curves.easeInOut,
                  child: vm.showKeypad
                      ? SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: CustomKeypad(
                            onKeyPressed: vm.onKeyPressed,
                            onBackPressed: vm.onBackspace,
                            onClear: vm.onClear,
                            onComplete: () => vm.toggleKeypad(false),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
