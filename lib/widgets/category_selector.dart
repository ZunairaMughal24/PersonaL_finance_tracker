import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final Function(String)? onCategoryLongPress;
  final List<Map<String, dynamic>> categories;
  final bool isIncome;
  final VoidCallback? onAddCategory;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.categories,
    required this.isIncome,
    this.onAddCategory,
    this.onCategoryLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // Static lists to identify what NOT to long-press
    final staticCats = isIncome
        ? ["salary", "business", "gifts", "investment", "other"]
        : ["food", "transport", "rent", "health", "shopping", "entertainment", "other"];

    final totalItems = categories.length + (onAddCategory != null ? 1 : 0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 7,
          crossAxisSpacing: 30,
          childAspectRatio: 0.75,
        ),
        itemCount: totalItems,
        itemBuilder: (context, index) {
          // "Add New"
          if (index == categories.length && onAddCategory != null) {
            return GestureDetector(
              onTap: onAddCategory,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Add New",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          final category = categories[index];
          final catName = category['name'] as String;
          final isSelected = selectedCategory == catName;
          final isStatic = staticCats.contains(catName.toLowerCase());

          final Color activeColor = isIncome ? AppColors.green : AppColors.red;

          return GestureDetector(
            onTap: () => onCategorySelected(catName),
            onLongPress: isStatic ? null : () => onCategoryLongPress?.call(catName),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? activeColor.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? activeColor.withValues(alpha: 0.5)
                          : Colors.white.withValues(alpha: 0.1),
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: activeColor.withValues(alpha: 0.2),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.7),
                    size: 22,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  catName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
