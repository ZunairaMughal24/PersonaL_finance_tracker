import 'dart:async';
import 'package:flutter/material.dart';

/// A reusable, premium swipe action container that handles gesture logic,
/// animations, and timers independently of business logic.
class FluidSwipeActionContainer extends StatefulWidget {
  final Widget child;
  final Widget? leftSwipeBackground;
  final Widget? rightSwipeBackground;
  final double maxSlideLeft;
  final double maxSlideRight;
  final double borderRadius;
  final Duration autoCloseDuration;
  final bool isDisabled;

  const FluidSwipeActionContainer({
    super.key,
    required this.child,
    this.leftSwipeBackground,
    this.rightSwipeBackground,
    this.maxSlideLeft = 0,
    this.maxSlideRight = 0,
    this.borderRadius = 16.0,
    this.autoCloseDuration = const Duration(seconds: 3),
    this.isDisabled = false,
  });

  @override
  State<FluidSwipeActionContainer> createState() =>
      _FluidSwipeActionContainerState();
}

class _FluidSwipeActionContainerState extends State<FluidSwipeActionContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragExtent = 0;
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _cancelAutoCloseTimer();
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (widget.isDisabled) return;
    _cancelAutoCloseTimer();
    setState(() {
      _dragExtent += details.delta.dx;
      _dragExtent = _dragExtent.clamp(
        -widget.maxSlideLeft - 20,
        widget.maxSlideRight + 20,
      );
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (widget.isDisabled) return;

    if (_dragExtent > widget.maxSlideRight / 2 && widget.maxSlideRight > 0) {
      _snapTo(1);
      _startAutoCloseTimer();
    } else if (_dragExtent < -widget.maxSlideLeft / 2 &&
        widget.maxSlideLeft > 0) {
      _snapTo(-1);
      _startAutoCloseTimer();
    } else {
      _snapTo(0);
    }
  }

  void _snapTo(int direction) {
    final double target = direction == 1
        ? widget.maxSlideRight
        : (direction == -1 ? -widget.maxSlideLeft : 0);

    final animation = Tween<double>(begin: _dragExtent, end: target).animate(
      CurvedAnimation(
        parent: _controller,
        curve: direction == 0 ? Curves.easeOutBack : Curves.elasticOut,
      ),
    );

    _runAnimation(animation);
  }

  void _runAnimation(Animation<double> animation) {
    _controller.reset();
    animation.addListener(() {
      setState(() => _dragExtent = animation.value);
    });
    _controller.forward();
  }

  void _startAutoCloseTimer() {
    _cancelAutoCloseTimer();
    _autoCloseTimer = Timer(widget.autoCloseDuration, () {
      if (mounted && _dragExtent != 0) {
        _snapTo(0);
      }
    });
  }

  void _cancelAutoCloseTimer() {
    _autoCloseTimer?.cancel();
    _autoCloseTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Bottom Layer: Right Swipe Actions (Reveals Left Panel)
        if (_dragExtent > 0 && widget.rightSwipeBackground != null)
          Positioned.fill(child: widget.rightSwipeBackground!),

        // Bottom Layer: Left Swipe Actions (Reveals Right Panel)
        if (_dragExtent < 0 && widget.leftSwipeBackground != null)
          Positioned.fill(child: widget.leftSwipeBackground!),

        // Top Layer: Content
        GestureDetector(
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          onTap: () {
            _cancelAutoCloseTimer();
            if (_dragExtent != 0) {
              _snapTo(0);
            }
          },
          child: Transform.translate(
            offset: Offset(_dragExtent, 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: widget.child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
