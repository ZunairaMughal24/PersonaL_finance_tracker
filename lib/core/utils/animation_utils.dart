import 'package:flutter/material.dart';

class FadeScaleTransition extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const FadeScaleTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(scale: 0.8 + (value * 0.2), child: child),
        );
      },
      child: child,
    );
  }
}

class FadeSlideTransition extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Interval interval;
  final Offset offset;

  const FadeSlideTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.interval = const Interval(0.0, 1.0, curve: Curves.easeOut),
    this.offset = const Offset(0, 20),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: interval,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: offset * (1 - value),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
