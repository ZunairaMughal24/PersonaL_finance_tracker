import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/constants/app_images.dart';
import 'package:montage/core/themes/app_text_theme.dart';
import 'package:montage/core/utils/date_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const CustomDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    var textValue = selectedDate == null
        ? ''
        : DateUtilsCustom.formatDate(selectedDate!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date",
          style: AppTextTheme.body(
            fontSize: 16,
            weight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
        TextFormField(
          readOnly: true,
          style: AppTextTheme.body(color: Colors.white),
          controller: TextEditingController(text: textValue),

          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) onDateSelected(picked);
          },
          decoration: InputDecoration(
            hintText: "Select Date",
            hintStyle: AppTextTheme.body(color: AppColors.grey),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SvgPicture.asset(
                AppImages.calendar,
                colorFilter: const ColorFilter.mode(
                  AppColors.grey,
                  BlendMode.srcIn,
                ),
                height: 20,
              ),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
