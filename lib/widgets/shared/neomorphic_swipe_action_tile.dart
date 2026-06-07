import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';

class NeomorphicSwipeActionTile extends StatefulWidget {
  final Widget child;
  final List<Widget> actions;
  final double actionWidth;
  final VoidCallback? onTap;

  const NeomorphicSwipeActionTile({
    super.key,
    required this.child,
    required this.actions,
    this.actionWidth = 70.0,
    this.onTap,
  });

  @override
  State<NeomorphicSwipeActionTile> createState() =>
      _NeomorphicSwipeActionTileState();
}

class _NeomorphicSwipeActionTileState extends State<NeomorphicSwipeActionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  double _dragExtent = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _updateAnimation();
  }

  void _updateAnimation() {
    _animation = _controller.drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: Offset(-widget.actions.length * widget.actionWidth, 0),
      ),
    );
  }

  @override
  void didUpdateWidget(NeomorphicSwipeActionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.actions.length != widget.actions.length ||
        oldWidget.actionWidth != widget.actionWidth) {
      _updateAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.delta.dx;
      // Limit drag to the left only, and cap it at slightly more than action width for bounce feel
      _dragExtent = _dragExtent.clamp(
        -widget.actions.length * widget.actionWidth - 20,
        0,
      );
      _controller.value =
          _dragExtent.abs() / (widget.actions.length * widget.actionWidth);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_controller.value > 0.4) {
      _controller.forward();
      _dragExtent = -widget.actions.length * widget.actionWidth;
    } else {
      _controller.reverse();
      _dragExtent = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          // ── Background Actions Layer ──
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                // This gives the background container a soft, neomorphic shape
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: widget.actions.map((action) {
                  return SizedBox(
                    width: widget.actionWidth,
                    child: Center(child: action),
                  );
                }).toList(),
              ),
            ),
          ),

          // ── Foreground Sliding Card ──
          GestureDetector(
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            onTap: widget.onTap,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_dragExtent, 0),
                  child: child,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    // Neomorphic soft shadows to lift the card
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(5, 5),
                    ),
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(-5, -5),
                    ),
                  ],
                ),
                // CRUCIAL: The ClipRRect here ensures the card keeps its rounded corners
                // even as it slides over the action background.
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
