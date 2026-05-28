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
  final bool showShadow;
  final double borderOpacity;
  final EdgeInsetsGeometry padding;
  final BoxConstraints? constraints;
  final Color? borderColor;

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
    this.showShadow = true,
    this.borderOpacity = 0.1,
    this.padding = EdgeInsets.zero,
    this.constraints,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      constraints: constraints,
      decoration: BoxDecoration(
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: customBorderRadius ?? BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius:
                  customBorderRadius ?? BorderRadius.circular(borderRadius),
              border: showBottomBorder
                  ? Border.all(
                      color:
                          borderColor ??
                          Colors.white.withValues(alpha: borderOpacity),
                      width: 0.8,
                    )
                  : Border(
                      top: BorderSide(
                        color:
                            borderColor ??
                            Colors.white.withValues(alpha: borderOpacity),
                        width: 0.8,
                      ),
                      left: BorderSide(
                        color:
                            borderColor ??
                            Colors.white.withValues(alpha: borderOpacity),
                        width: 0.8,
                      ),
                      right: BorderSide(
                        color:
                            borderColor ??
                            Colors.white.withValues(alpha: borderOpacity),
                        width: 0.8,
                      ),
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
