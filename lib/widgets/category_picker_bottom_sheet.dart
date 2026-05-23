import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/providers/category_provider.dart';
import 'package:montage/widgets/app_bottom_sheet.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:provider/provider.dart';

class CategoryPickerBottomSheet extends StatelessWidget {
  final String? selectedCategory;
  final bool? isIncome;

  const CategoryPickerBottomSheet({
    super.key,
    this.selectedCategory,
    this.isIncome,
  });

  static Future<String?> show({
    required BuildContext context,
    String? selectedCategory,
    bool? isIncome,
  }) {
    return AppBottomSheet.show<String>(
      context: context,
      child: CategoryPickerBottomSheet(
        selectedCategory: selectedCategory,
        isIncome: isIncome,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catProvider = context.watch<CategoryProvider>();

    // Get merged categories (static + custom)
    final categories = isIncome == null
        ? catProvider.getAllCategoriesForFilter()
        : catProvider.getMergedCategories(isIncome!);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Text(
            "Select Category",
          ).h4(color: Colors.white, weight: FontWeight.bold),
        ),
        20.heightBox,
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.45,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final name = cat['name'] as String;
              final isSelected =
                  selectedCategory == name ||
                  (selectedCategory == null && name == 'All');

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () => Navigator.pop(context, name),
                  borderRadius: BorderRadius.circular(16),
                  child: GlassContainer(
                    borderRadius: 16,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    gradientColors: isSelected
                        ? [
                            AppColors.primaryColor.withValues(alpha: 0.15),
                            AppColors.primaryColor.withValues(alpha: 0.05),
                          ]
                        : [
                            Colors.white.withValues(alpha: 0.05),
                            Colors.white.withValues(alpha: 0.02),
                          ],
                    showShadow: false,
                    showBottomBorder: false,
                    child: Row(
                      children: [
                        Icon(
                          cat['icon'] as IconData,
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.white70,
                          size: 22,
                        ),
                        16.widthBox,
                        Expanded(
                          child: Text(name).bodyLarge(
                            color: isSelected ? Colors.white : Colors.white70,
                            weight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primaryColor,
                            size: 20,
                          )
                        else
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white.withValues(alpha: 0.2),
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
