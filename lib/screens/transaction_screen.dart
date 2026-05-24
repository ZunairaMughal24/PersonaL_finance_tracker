import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:montage/providers/category_provider.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';

import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/viewmodels/transaction_form_view_model.dart';
import 'package:montage/widgets/transaction_type_toggle.dart';
import 'package:montage/widgets/custom_keypad.dart';
import 'package:montage/widgets/category_selector.dart';
import 'package:montage/core/utils/toast_utility.dart';
import 'package:montage/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:montage/widgets/app_background.dart';
import 'package:montage/widgets/transaction/custom_category_dialog.dart';
import 'package:montage/widgets/transaction/category_editor_dialog.dart';
import 'package:montage/viewmodels/speech_view_model.dart';
import 'package:montage/widgets/shared/transaction_section_header.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionFormViewModel()),
      ],
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
            appBar: const CustomAppBar(title: "Add Transaction"),
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
                            const TransactionSectionHeader(
                              title: "TRANSACTION TYPE",
                              subtitle: "Choose between income or expense",
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: TransactionTypeToggle(
                                isIncome: vm.isIncome,
                                onChanged: (val) => vm.toggleType(val),
                              ),
                            ),
                            12.heightBox,
                            const TransactionSectionHeader(
                              title: "SELECT CATEGORY",
                            ),
                            CategorySelector(
                              selectedCategory: vm.selectedCategory,
                              categories: context
                                  .watch<CategoryProvider>()
                                  .getMergedCategories(vm.isIncome),
                              isIncome: vm.isIncome,
                              onAddCategory: () {
                                final catProvider = context
                                    .read<CategoryProvider>();
                                showDialog(
                                  context: context,
                                  barrierColor: Colors.black54,
                                  builder: (context) => CategoryEditorDialog(
                                    isIncome: vm.isIncome,
                                    onSubmitted:
                                        (
                                          customName,
                                          customIcon, {
                                          Color? color,
                                        }) {
                                          catProvider.addCustomCategory(
                                            customName,
                                            customIcon,
                                            vm.isIncome,
                                            color: color,
                                          );
                                          vm.setCategory(customName);
                                          vm.toggleKeypad(true);
                                        },
                                  ),
                                );
                              },
                              onCategoryLongPress: (catName) =>
                                  vm.handleCategoryAction(
                                    context: context,
                                    catName: catName,
                                    catProvider: context
                                        .read<CategoryProvider>(),
                                  ),
                              onCategorySelected: (cat) {
                                if (cat == "Other") {
                                  showDialog(
                                    context: context,
                                    barrierColor: Colors.black54,
                                    builder: (context) => CustomCategoryDialog(
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
                          onComplete: () => vm.saveTransaction(
                            provider: context.read<TransactionProvider>(),
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
