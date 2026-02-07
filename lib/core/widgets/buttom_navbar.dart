/// consistent styling and animation across the app.
///
/// Features:
/// - Applies unified padding, height, and border radius.
/// - Supports animated press feedback.
/// - Allows flexible width based on screen size or layout needs.
/// - Accepts a custom child widget.
///

import 'package:flutter/material.dart';
import 'package:custom_button_builder/custom_button_builder.dart';

class MyCustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double width;
  final Color color;

  MyCustomButton(this.child, this.onPressed, this.width,
      {super.key, this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: CustomButton(
        onPressed: onPressed,
        animate: true,
        backgroundColor: color,
        borderRadius: 30,
        width: width, // bassed on screen width
        height: 48,
        child: child,
      ),
    );
  }
}
