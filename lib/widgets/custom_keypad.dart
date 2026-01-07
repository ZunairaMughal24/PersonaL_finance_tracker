import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';

class CustomKeypad extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onBackPressed;
  final VoidCallback onClear;
  final VoidCallback onComplete;

  const CustomKeypad({
    super.key,
    required this.onKeyPressed,
    required this.onBackPressed,
    required this.onClear,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          20.heightBox,

          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.8,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildKey(context, '1'),
              _buildKey(context, '2'),
              _buildKey(context, '3'),
              _buildKey(context, '4'),
              _buildKey(context, '5'),
              _buildKey(context, '6'),
              _buildKey(context, '7'),
              _buildKey(context, '8'),
              _buildKey(context, '9'),

              _buildActionKey(
                context,
                icon: Icons.backspace_outlined,
                onTap: onBackPressed,
                color: AppColors.red.withOpacity(0.8),
              ),
              _buildKey(context, '0'),
              _buildActionKey(
                context,
                icon: Icons.check_rounded,
                onTap: onComplete,
                color: AppColors.green,
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildKey(BuildContext context, String value) {
    return _KeypadButton(
      onTap: () => onKeyPressed(value),
      baseColor: const Color(0xFF232B4C), // Slightly darker, more professional
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildActionKey(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return _KeypadButton(
      onTap: onTap,
      baseColor: color.withOpacity(0.9),
      isAction: true,
      child: Icon(icon, size: 24, color: Colors.white),
    );
  }
}

class _KeypadButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? baseColor;
  final bool isAction;

  const _KeypadButton({
    required this.child,
    required this.onTap,
    this.baseColor,
    this.isAction = false,
  });

  @override
  State<_KeypadButton> createState() => _KeypadButtonState();
}

class _KeypadButtonState extends State<_KeypadButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.isAction ? Colors.white : AppColors.primaryLight;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        curve: Curves.easeOut,
        margin: EdgeInsets.only(
          top: _isPressed ? 4 : 0,
          bottom: _isPressed ? 0 : 4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!_isPressed)
              BoxShadow(
                color: (widget.baseColor ?? AppColors.primaryColor).withOpacity(
                  0.4,
                ),
                offset: const Offset(0, 4),
                blurRadius: 0,
              ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: widget.baseColor ?? AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.12),
                Colors.white.withOpacity(0.02),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Inner Glow
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                ),
              ),
              Center(child: widget.child),
            ],
          ),
        ),
      ),
    );
  }
}
