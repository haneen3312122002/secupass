import 'package:flutter/material.dart';

class AnimatedAddButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  const AnimatedAddButton({
    super.key,
    required this.onPressed,
    this.size = 56.0,
    this.backgroundColor = const Color.fromARGB(255, 141, 196, 255),
    this.iconColor = Colors.white,
  });

  @override
  State<AnimatedAddButton> createState() => _AnimatedAddButtonState();
}

class _AnimatedAddButtonState extends State<AnimatedAddButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  bool _isOpened = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _rotationAnimation = Tween<double>(
            begin: 0, end: 0.125) // 45 درجة (ربع دورة)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _handleTap() {
    if (_isOpened) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _isOpened = !_isOpened;

    widget.onPressed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return FloatingActionButton(
            onPressed: _handleTap,
            backgroundColor: widget.backgroundColor,
            child: Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.1416, // راديان
              child: Icon(
                _isOpened ? Icons.close : Icons.add,
                color: widget.iconColor,
                size: widget.size * 0.5,
              ),
            ),
          );
        },
      ),
    );
  }
}
