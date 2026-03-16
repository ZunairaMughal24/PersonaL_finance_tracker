import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double blur;
  final double borderRadius;
  final BorderRadiusGeometry? customBorderRadius;
  final List<Color>? gradientColors;
  final bool showBottomBorder;
  final double borderOpacity;
  final EdgeInsetsGeometry padding;
  final BoxConstraints? constraints;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.blur = 15,
    this.borderRadius = 24,
    this.customBorderRadius,
    this.gradientColors,
    this.showBottomBorder = true,
    this.borderOpacity = 0.1,
    this.padding = EdgeInsets.zero,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      constraints: constraints,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: customBorderRadius ?? BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: customBorderRadius ?? BorderRadius.circular(borderRadius),
              border: showBottomBorder 
                  ? Border.all(
                      color: Colors.white.withValues(alpha: borderOpacity),
                      width: 1.5,
                    )
                  : Border(
                      top: BorderSide(color: Colors.white.withValues(alpha: borderOpacity), width: 1.5),
                      left: BorderSide(color: Colors.white.withValues(alpha: borderOpacity), width: 1.5),
                      right: BorderSide(color: Colors.white.withValues(alpha: borderOpacity), width: 1.5),
                    ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    gradientColors ??
                    [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.white.withValues(alpha: 0.02),
                    ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
