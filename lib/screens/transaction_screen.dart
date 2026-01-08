import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/category_utils.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:personal_finance_tracker/viewmodels/transaction_form_view_model.dart';
import 'package:personal_finance_tracker/widgets/transaction_type_toggle.dart';
import 'package:personal_finance_tracker/widgets/custom_keypad.dart';
import 'package:personal_finance_tracker/widgets/category_selector.dart';
import 'package:personal_finance_tracker/core/utils/toast_utility.dart';
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
  final ScrollController _scrollController = ScrollController();

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
    _scrollController.dispose();
    super.dispose();
  }

  void _saveTransaction(BuildContext context) {
    final vm = Provider.of<TransactionFormViewModel>(context, listen: false);
    final error = vm.validate();

    if (error != null) {
      ToastUtils.show(context, error);
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
              leading: Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: TransactionTypeToggle(
                            isIncome: vm.isIncome,
                            onChanged: (val) => vm.toggleType(val),
                          ),
                        ),
                        14.heightBox,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Select Category",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                color: AppColors.white.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        CategorySelector(
                          selectedCategory: vm.selectedCategory,
                          categories: vm.isIncome
                              ? CategoryUtils.incomeCategories
                              : CategoryUtils.expenseCategories,
                          isIncome: vm.isIncome,
                          onCategorySelected: (cat) {
                            vm.setCategory(cat);
                            vm.toggleKeypad(true);
                            Future.delayed(
                              const Duration(milliseconds: 300),
                              () {
                                if (_scrollController.hasClients) {
                                  double scrollAmount = 120.0;
                                  _scrollController.animateTo(
                                    scrollAmount,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOut,
                                  );
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                if (vm.showKeypad)
                  CustomKeypad(
                    amount: vm.amountExpression,
                    note: vm.title,
                    selectedDate: vm.selectedDate,
                    currency: vm.selectedCurrency,
                    isIncome: vm.isIncome,
                    onKeyPressed: vm.onKeyPressed,
                    onBackPressed: vm.onBackspace,
                    onClear: vm.onClear,
                    onComplete: () => _saveTransaction(context),
                    onNoteChanged: (val) => vm.setTitle(val),
                    onDateChanged: (val) => vm.setDate(val),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
