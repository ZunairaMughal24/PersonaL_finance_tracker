import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:montage/core/constants/app_images.dart';
import 'package:montage/widgets/pulse_effect.dart';

class CustomKeypad extends StatefulWidget {
  final String amount;
  final String amountResult;
  final String note;
  final DateTime selectedDate;
  final String currency;
  final bool isIncome;
  final bool hasActiveExpression;
  final bool hasImage;
  final Function(String) onKeyPressed;
  final VoidCallback onBackPressed;
  final VoidCallback onClear;
  final VoidCallback onComplete;
  final VoidCallback onEqualPressed;
  final VoidCallback onCameraTap;
  final Function(String) onNoteChanged;
  final Function(DateTime) onDateChanged;
  final bool isListening;
  final VoidCallback? onMicTap;
  final VoidCallback? onToggleLocale;
  final String currentLocale;

  const CustomKeypad({
    super.key,
    required this.amount,
    required this.amountResult,
    required this.note,
    required this.selectedDate,
    required this.currency,
    required this.isIncome,
    required this.hasActiveExpression,
    this.hasImage = false,
    required this.onKeyPressed,
    required this.onBackPressed,
    required this.onClear,
    required this.onComplete,
    required this.onEqualPressed,
    required this.onCameraTap,
    required this.onNoteChanged,
    required this.onDateChanged,
    this.isListening = false,
    this.onMicTap,
    this.onToggleLocale,
    this.currentLocale = 'en_US',
  });

  @override
  State<CustomKeypad> createState() => _CustomKeypadState();
}

class _CustomKeypadState extends State<CustomKeypad> {
  late TextEditingController _noteController;
  final FocusNode _noteFocusNode = FocusNode();
  bool _isNoteFocused = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.note);
    _noteFocusNode.addListener(() {
      setState(() {
        _isNoteFocused = _noteFocusNode.hasFocus;
      });
    });
  }

  @override
  void didUpdateWidget(CustomKeypad oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.note != widget.note && _noteController.text != widget.note) {
      _noteController.text = widget.note;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: const Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != widget.selectedDate) {
      widget.onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withValues(alpha: 0.05),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _KeypadHeader(
              amount: widget.amount,
              amountResult: widget.amountResult,
            ),
            _KeypadNoteField(
              controller: _noteController,
              onChanged: widget.onNoteChanged,
              focusNode: _noteFocusNode,
              onCameraTap: widget.onCameraTap,
              hasImage: widget.hasImage,
              isListening: widget.isListening,
              onMicTap: widget.onMicTap,
              onToggleLocale: widget.onToggleLocale,
              currentLocale: widget.currentLocale,
            ),
            if (!_isNoteFocused)
              _KeypadGrid(
                selectedDate: widget.selectedDate,
                hasActiveExpression: widget.hasActiveExpression,
                onKeyPressed: widget.onKeyPressed,
                onBackPressed: widget.onBackPressed,
                onComplete: widget.onComplete,
                onEqualPressed: widget.onEqualPressed,
                onDateSelect: () => _selectDate(context),
              ),
          ],
        ),
      ),
    );
  }
}

class _KeypadHeader extends StatelessWidget {
  final String amount;
  final String amountResult;
  const _KeypadHeader({required this.amount, required this.amountResult});

  @override
  Widget build(BuildContext context) {
    bool hasOperators = RegExp(r'[+\-*/]').hasMatch(amount);

    String formatNumber(String s) {
      if (s == "-") return "-";
      try {
        return s.replaceAllMapped(
          RegExp(r'\d+'),
          (Match m) => NumberFormat("#,###").format(int.parse(m[0]!)),
        );
      } catch (_) {
        return s;
      }
    }

    String formattedAmount = formatNumber(amount);
    String formattedResult = formatNumber(amountResult);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.badge_outlined,
              color: Colors.white.withValues(alpha: 0.4),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (hasOperators)
                  Text(
                    formattedResult,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    amount == "0" ? "0" : formattedAmount,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KeypadNoteField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final FocusNode? focusNode;
  final VoidCallback onCameraTap;
  final bool hasImage;
  final bool isListening;
  final VoidCallback? onMicTap;
  final VoidCallback? onToggleLocale;
  final String currentLocale;

  const _KeypadNoteField({
    required this.controller,
    required this.onChanged,
    this.focusNode,
    required this.onCameraTap,
    this.hasImage = false,
    this.isListening = false,
    this.onMicTap,
    this.onToggleLocale,
    this.currentLocale = 'en_US',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            "Note : ",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 16,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              focusNode: focusNode,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: "Enter a note...",
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (onMicTap != null)
            GestureDetector(
              onTap: onMicTap,
              onLongPress: onToggleLocale,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isListening)
                    PulseEffect(
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.green.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isListening 
                          ? AppColors.green.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isListening ? Icons.mic : Icons.mic_none_rounded,
                      color: isListening ? AppColors.green : Colors.white.withValues(alpha: 0.4),
                      size: 20,
                    ),
                  ),

                ],
              ),
            ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onCameraTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white.withValues(alpha: 0.4),
                  size: 22,
                ),
                if (hasImage)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KeypadGrid extends StatelessWidget {
  final DateTime selectedDate;
  final bool hasActiveExpression;
  final Function(String) onKeyPressed;
  final VoidCallback onBackPressed;
  final VoidCallback onComplete;
  final VoidCallback onEqualPressed;
  final VoidCallback onDateSelect;

  const _KeypadGrid({
    required this.selectedDate,
    required this.hasActiveExpression,
    required this.onKeyPressed,
    required this.onBackPressed,
    required this.onComplete,
    required this.onEqualPressed,
    required this.onDateSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('keypad_grid'),
      children: [
        Row(
          children: [
            _buildKey('7'),
            _buildKey('8'),
            _buildKey('9'),
            _buildDateKey(context),
          ],
        ),
        Row(
          children: [
            _buildKey('4'),
            _buildKey('5'),
            _buildKey('6'),
            _buildOperatorKey('+', '+'),
            _buildOperatorKey('-', '−'),
          ],
        ),
        Row(
          children: [
            _buildKey('1'),
            _buildKey('2'),
            _buildKey('3'),
            _buildOperatorKey('*', '×'),
            _buildOperatorKey('/', '÷'),
          ],
        ),
        Row(
          children: [
            _buildKey('.'),
            _buildKey('0'),
            _buildActionKey(
              icon: Icons.backspace_outlined,
              onTap: onBackPressed,
            ),
            _buildDynamicCompleteKey(),
          ],
        ),
      ],
    );
  }

  Widget _buildKey(String value) {
    return Expanded(
      flex: 1,
      child: _KeypadButton(label: value, onTap: () => onKeyPressed(value)),
    );
  }

  Widget _buildOperatorKey(String value, String label) {
    return Expanded(
      flex: 1,
      child: _KeypadButton(
        label: label,
        onTap: () => onKeyPressed(value),
        labelStyle: const TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildDateKey(BuildContext context) {
    final bool isToday =
        DateFormat('yyyy-MM-dd').format(selectedDate) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    return Expanded(
      flex: 2,
      child: _KeypadButton(
        onTap: onDateSelect,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppImages.calendar,
              colorFilter: ColorFilter.mode(
                isToday ? AppColors.primaryLight : Colors.white,
                BlendMode.srcIn,
              ),
              height: 19,
            ),
            const SizedBox(width: 8),
            Text(
              isToday ? "Today" : DateFormat('dd MMM').format(selectedDate),
              style: TextStyle(
                color: isToday ? AppColors.primaryLight : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionKey({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      flex: 1,
      child: _KeypadButton(icon: icon, onTap: onTap),
    );
  }

  Widget _buildDynamicCompleteKey() {
    final bool showEqual = hasActiveExpression;
    return Expanded(
      flex: 2,
      child: _KeypadButton(
        icon: showEqual ? null : Icons.check,
        label: showEqual ? '=' : null,
        iconSize: 28,
        onTap: showEqual ? onEqualPressed : onComplete,
        backgroundColor: AppColors.primaryColor.withValues(alpha: 0.2),
        labelStyle: showEqual
            ? const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              )
            : null,
      ),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final Widget? child;
  final VoidCallback onTap;
  final TextStyle? labelStyle;
  final Color? backgroundColor;
  final double iconSize;

  const _KeypadButton({
    this.label,
    this.icon,
    this.child,
    required this.onTap,
    this.labelStyle,
    this.backgroundColor,
    this.iconSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.2),
              offset: const Offset(0, 2),
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: backgroundColor ?? AppColors.background.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 50,
              alignment: Alignment.center,
              child:
                  child ??
                  (label != null
                      ? Text(
                          label!,
                          style:
                              labelStyle ??
                              const TextStyle(
                                fontSize: 23,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                        )
                      : Icon(icon, color: Colors.white, size: iconSize)),
            ),
          ),
        ),
      ),
    );
  }
}



