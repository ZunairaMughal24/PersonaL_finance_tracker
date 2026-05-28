import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/constants/app_images.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/glass_container.dart';

/// A shared, dumb search bar used by both Activity and History screens.
/// Knows nothing about providers or view models, just values and callbacks.
class TransactionSearchBar extends StatelessWidget {
  final FocusNode focusNode;
  final String hintText;
  final void Function(String) onChanged;
  final DateTimeRange? selectedDateRange;
  final void Function(DateTimeRange?) onDateRangeChanged;

  const TransactionSearchBar({
    super.key,
    required this.focusNode,
    required this.onChanged,
    required this.onDateRangeChanged,
    this.hintText = 'Search transactions...',
    this.selectedDateRange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassContainer(
        borderRadius: 12,
        blur: 12,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        gradientColors: [
          Colors.white.withValues(alpha: 0.12),
          AppColors.primaryColor.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.08),
        ],
        child: Row(
          children: [
            12.widthBox,
            Icon(
              Icons.search,
              color: Colors.white.withValues(alpha: 0.5),
              size: 20,
            ),
            8.widthBox,
            Expanded(
              child: TextField(
                focusNode: focusNode,
                onChanged: onChanged,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            Container(
              height: 40,
              width: 1,
              color: Colors.white.withValues(alpha: 0.1),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 44, minHeight: 40),
              onPressed: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  builder: (context, child) => Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: AppColors.primaryColor,
                        onPrimary: Colors.white,
                        surface: Color(0xFF1E2141),
                        onSurface: Colors.white,
                      ),
                    ),
                    child: child!,
                  ),
                );
                onDateRangeChanged(range);
              },
              icon: SvgPicture.asset(
                AppImages.calendar,
                colorFilter: ColorFilter.mode(
                  selectedDateRange != null
                      ? AppColors.primaryColor
                      : Colors.white.withValues(alpha: 0.5),
                  BlendMode.srcIn,
                ),
                height: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
