import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/category_utils.dart';
import 'package:personal_finance_tracker/models/transaction_model.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:personal_finance_tracker/viewmodels/transaction_form_view_model.dart';
import 'package:personal_finance_tracker/widgets/transaction_type_toggle.dart';
import 'package:personal_finance_tracker/widgets/category_selector.dart';
import 'package:personal_finance_tracker/widgets/custom_keypad.dart';
import 'package:personal_finance_tracker/core/utils/toast_utility.dart';
import 'package:personal_finance_tracker/widgets/custom_app_bar.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionFormViewModel>(
      builder: (context, vm, child) {
        return GestureDetector(
          onTap: () => vm.toggleKeypad(false),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: AppColors.background,
            appBar: CustomAppBar(title: "Edit Transaction"),
            body: Stack(
              children: [
                // New Background Image (from Sign In screens):
                // Positioned.fill(
                //   child: Image.network(
                //     'https://images.unsplash.com/photo-1614850523459-c2f4c699c52e?q=80&w=2187&auto=format&fit=crop',
                //     fit: BoxFit.cover,
                //   ),
                // ),
                // Old Background Image (dark abstract - recommended for transaction screens):
                Positioned.fill(
                  child: Image.network(
                    'https://images.unsplash.com/photo-1635776062127-d379bfcba9f8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80',
                    fit: BoxFit.cover,
                  ),
                ),
                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.background.withOpacity(0.7),
                          AppColors.background.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  10,
                                  20,
                                  0,
                                ),
                                child: TransactionTypeToggle(
                                  isIncome: vm.isIncome,
                                  onChanged: (val) => vm.toggleType(val),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "SELECT CATEGORY",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2.0,
                                      color: AppColors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
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
                                        double scrollAmount = 140.0;
                                        _scrollController.animateTo(
                                          scrollAmount,
                                          duration: const Duration(
                                            milliseconds: 500,
                                          ),
                                          curve: Curves.easeOut,
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
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
                          onComplete: () => vm.updateTransaction(
                            provider: context.read<TransactionProvider>(),
                            key: widget.transactionKey,
                            onSuccess: () => context.pop(),
                            onError: (error) => ToastUtils.show(context, error),
                          ),
                          onNoteChanged: (val) => vm.setTitle(val),
                          onDateChanged: (val) => vm.setDate(val),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
