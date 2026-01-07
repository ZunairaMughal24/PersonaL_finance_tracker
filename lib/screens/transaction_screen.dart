import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/constants/category_constants.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:personal_finance_tracker/viewmodels/transaction_form_view_model.dart';
import 'package:personal_finance_tracker/widgets/appButton.dart';
import 'package:personal_finance_tracker/widgets/transaction_type_toggle.dart';
import 'package:personal_finance_tracker/widgets/custom_keypad.dart';
import 'package:personal_finance_tracker/widgets/category_selector.dart';
import 'package:personal_finance_tracker/widgets/transaction/amount_display.dart';
import 'package:personal_finance_tracker/widgets/transaction/transaction_date_picker.dart';
import 'package:personal_finance_tracker/widgets/transaction/transaction_title_field.dart';
import 'package:provider/provider.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionFormViewModel(),
      child: const _TransactionScreenContent(),
    );
  }
}

class _TransactionScreenContent extends StatefulWidget {
  const _TransactionScreenContent();

  @override
  State<_TransactionScreenContent> createState() =>
      _TransactionScreenContentState();
}

class _TransactionScreenContentState extends State<_TransactionScreenContent> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();

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

  void _saveTransaction(BuildContext context) {
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
    ).addTransaction(vm.getTransactionModel());

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
                'Add Transaction',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            key: const ValueKey('TransactionFormContent'),
                            children: [
                              AmountDisplay(
                                amount: vm.amount,
                                currency: vm.selectedCurrency,
                                isIncome: vm.isIncome,
                                onTap: () => vm.toggleKeypad(true),
                              ),
                            ],
                          ),
                        ),

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
                          onDateChanged: (date) => vm.setDate(date),
                        ),

                        const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: AppButton(
                            text: "Save Transaction",
                            onPressed: () => _saveTransaction(context),
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
