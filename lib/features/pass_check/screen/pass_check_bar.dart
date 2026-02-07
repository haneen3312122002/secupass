import 'package:flutter/material.dart';

class PasswordStrengthBar extends StatelessWidget {
  final double strength; // من 0.0 إلى 1.0

  const PasswordStrengthBar(
      {super.key, required this.strength, required this.color});

  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(5),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: strength.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
