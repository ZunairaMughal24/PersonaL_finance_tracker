import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/providers/category_provider.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/viewmodels/transaction_form_view_model.dart';
import 'package:montage/widgets/transaction_type_toggle.dart';
import 'package:montage/widgets/category_selector.dart';
import 'package:montage/widgets/custom_keypad.dart';
import 'package:montage/core/utils/toast_utility.dart';
import 'package:montage/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:montage/widgets/app_background.dart';
import 'package:montage/widgets/transaction/custom_category_dialog.dart';
import 'package:montage/widgets/transaction/category_editor_dialog.dart';
import 'package:montage/viewmodels/speech_view_model.dart';

class EditTransactionScreen extends StatelessWidget {
  const EditTransactionScreen({super.key, required this.transaction});
  final TransactionModel transaction;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TransactionFormViewModel(transaction: transaction),
        ),
      ],
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
          child: AppBackground(
            style: BackgroundStyle.deepFluid,
            appBar: const CustomAppBar(
              title: "Edit Transaction",
            ),
            child: SafeArea(
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity == null) return;
                  if (details.primaryVelocity! < -200) {
                    vm.toggleType(false);
                  } else if (details.primaryVelocity! > 200) {
                    vm.toggleType(true);
                  }
                },
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: TransactionTypeToggle(
                                isIncome: vm.isIncome,
                                onChanged: (val) => vm.toggleType(val),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "SELECT CATEGORY",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2.0,
                                    color: AppColors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            CategorySelector(
                              selectedCategory: vm.selectedCategory,
                              categories: context.watch<CategoryProvider>()
                                  .getMergedCategories(vm.isIncome),
                              isIncome: vm.isIncome,
                              onAddCategory: () {
                                final catProvider = context.read<CategoryProvider>();
                                showDialog(
                                  context: context,
                                  barrierColor: Colors.black54,
                                  builder: (context) => CategoryEditorDialog(
                                    isIncome: vm.isIncome,
                                    onSubmitted: (customName, customIcon, {Color? color}) {
                                      catProvider.addCustomCategory(customName, customIcon, vm.isIncome, color: color);
                                      vm.setCategory(customName);
                                      vm.toggleKeypad(true);
                                    },
                                  ),
                                );
                              },
                              onCategoryLongPress: (catName) => vm.handleCategoryAction(
                                context: context, 
                                catName: catName, 
                                catProvider: context.read<CategoryProvider>()
                              ),
                              onCategorySelected: (cat) {
                                if (cat == "Other") {
                                  showDialog(
                                    context: context,
                                    builder: (context) => CustomCategoryDialog(
                                      initialCategory: vm.selectedCategory,
                                      onSubmitted: (customName) {
                                        vm.setCategory(customName);
                                        vm.toggleKeypad(true);
                                      },
                                    ),
                                  );
                                } else {
                                  vm.setCategory(cat);
                                  vm.toggleKeypad(true);
                                }
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
                      Consumer<SpeechViewModel>(
                        builder: (context, speechVm, _) => CustomKeypad(
                          amount: vm.amountExpression,
                          amountResult: vm.amountResult,
                          note: vm.title,
                          selectedDate: vm.selectedDate,
                          currency: vm.selectedCurrency,
                          isIncome: vm.isIncome,
                          hasActiveExpression: vm.hasActiveExpression,
                          hasImage: vm.imagePath != null,
                          isListening: speechVm.isListening,
                          currentLocale: speechVm.currentLocale,
                          onKeyPressed: vm.onKeyPressed,
                          onBackPressed: vm.onBackspace,
                          onClear: vm.onClear,
                          onComplete: () => vm.updateTransaction(
                            provider: context.read<TransactionProvider>(),
                            key: widget.transactionKey,
                            onSuccess: () => context.pop(),
                            onError: (error) => ToastUtils.show(context, error),
                          ),
                          onEqualPressed: vm.onEqualPressed,
                          onCameraTap: () => vm.pickImage(context),
                          onNoteChanged: (val) => vm.setTitle(val),
                          onDateChanged: (val) => vm.setDate(val),
                          onMicTap: () => speechVm.toggleListening((result) {
                            vm.setTitle(result);
                          }),
                          onToggleLocale: () => speechVm.toggleLocale(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
