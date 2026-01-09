import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/themes/appTextTheme.dart';

extension TextThemeExtension on Text {
  Text h1({Color? color, FontWeight weight = FontWeight.w700}) => Text(
    data!,
    style: AppTextTheme.h1(color: color, weight: weight),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );

  Text h2({Color? color, FontWeight weight = FontWeight.w700}) => Text(
    data!,
    style: AppTextTheme.h2(color: color, weight: weight),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );

  Text h3({Color? color, FontWeight weight = FontWeight.w600}) => Text(
    data!,
    style: AppTextTheme.h3(color: color, weight: weight),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );

  Text h4({Color? color, FontWeight weight = FontWeight.w600}) => Text(
    data!,
    style: AppTextTheme.h4(color: color, weight: weight),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );

  Text bodyLarge({Color? color, FontWeight weight = FontWeight.w400}) => Text(
    data!,
    style: AppTextTheme.bodyLarge(color: color, weight: weight),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );

  Text bodyMedium({Color? color, FontWeight weight = FontWeight.w400}) => Text(
    data!,
    style: AppTextTheme.bodyMedium(color: color, weight: weight),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );

  Text bodySmall({Color? color, FontWeight weight = FontWeight.w400}) => Text(
    data!,
    style: AppTextTheme.bodySmall(color: color, weight: weight),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );

  Text labelLarge({Color? color, FontWeight weight = FontWeight.w500}) => Text(
    data!,
    style: AppTextTheme.labelLarge(color: color, weight: weight),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );

  Text labelMedium({Color? color, FontWeight weight = FontWeight.w500}) => Text(
    data!,
    style: AppTextTheme.labelMedium(color: color, weight: weight),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );

  Text labelSmall({Color? color, FontWeight weight = FontWeight.w500}) => Text(
    data!,
    style: AppTextTheme.labelSmall(color: color, weight: weight),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );

  Text caption({Color? color, FontWeight weight = FontWeight.w400}) => Text(
    data!,
    style: AppTextTheme.caption(color: color, weight: weight),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );

  Text mono({
    Color? color,
    FontWeight weight = FontWeight.w400,
    double? fontSize,
  }) => Text(
    data!,
    style: AppTextTheme.mono(
      color: color,
      weight: weight,
      fontSize: fontSize ?? 13,
    ),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );

  Text titleLarge({Color? color, FontWeight weight = FontWeight.w600}) => Text(
    data!,
    style: AppTextTheme.title(color: color, weight: weight),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );

  Text titleMedium({Color? color, FontWeight weight = FontWeight.w500}) => Text(
    data!,
    style: AppTextTheme.subtitle(color: color, weight: weight),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );
}
