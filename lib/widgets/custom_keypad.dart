import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';

class CustomKeypad extends StatefulWidget {
  final String amount;
  final String note;
  final DateTime selectedDate;
  final String currency;
  final bool isIncome;
  final Function(String) onKeyPressed;
  final VoidCallback onBackPressed;
  final VoidCallback onClear;
  final VoidCallback onComplete;
  final Function(String) onNoteChanged;
  final Function(DateTime) onDateChanged;

  const CustomKeypad({
    super.key,
    required this.amount,
    required this.note,
    required this.selectedDate,
    required this.currency,
    required this.isIncome,
    required this.onKeyPressed,
    required this.onBackPressed,
    required this.onClear,
    required this.onComplete,
    required this.onNoteChanged,
    required this.onDateChanged,
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
          color: AppColors.primaryLight.withOpacity(0.05),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _KeypadHeader(amount: widget.amount),
            _KeypadNoteField(
              controller: _noteController,
              onChanged: widget.onNoteChanged,
              focusNode: _noteFocusNode,
            ),
            if (!_isNoteFocused)
              _KeypadGrid(
                selectedDate: widget.selectedDate,
                onKeyPressed: widget.onKeyPressed,
                onBackPressed: widget.onBackPressed,
                onComplete: widget.onComplete,
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
  const _KeypadHeader({required this.amount});

  @override
  Widget build(BuildContext context) {
    String formattedAmount = amount.replaceAllMapped(
      RegExp(r'\d+'),
      (Match m) => NumberFormat("#,###").format(int.parse(m[0]!)),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.badge_outlined,
              color: Colors.white.withOpacity(0.4),
              size: 20,
            ),
          ),
          Text(
            amount == "0" ? "0" : formattedAmount,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Colors.white,
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
  const _KeypadNoteField({
    required this.controller,
    required this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.09),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            "Note : ",
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
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
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.camera_alt_outlined,
            color: Colors.white.withOpacity(0.4),
            size: 22,
          ),
        ],
      ),
    );
  }
}

class _KeypadGrid extends StatelessWidget {
  final DateTime selectedDate;
  final Function(String) onKeyPressed;
  final VoidCallback onBackPressed;
  final VoidCallback onComplete;
  final VoidCallback onDateSelect;

  const _KeypadGrid({
    required this.selectedDate,
    required this.onKeyPressed,
    required this.onBackPressed,
    required this.onComplete,
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
            _buildCompleteKey(),
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
            Icon(
              Icons.calendar_today,
              size: 16,
              color: isToday ? AppColors.primaryColor : Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              isToday ? "Today" : DateFormat('dd MMM').format(selectedDate),
              style: TextStyle(
                color: isToday ? AppColors.primaryColor : Colors.white,
                fontWeight: FontWeight.w500,
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

  Widget _buildCompleteKey() {
    return Expanded(
      flex: 2,
      child: _KeypadButton(
        icon: Icons.check,
        iconSize: 28,
        onTap: onComplete,
        backgroundColor: AppColors.primaryColor.withOpacity(0.2),
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
              color: AppColors.primaryColor.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: backgroundColor ?? AppColors.background.withOpacity(0.2),
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
