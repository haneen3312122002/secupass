import 'package:flutter/material.dart';

class ErrorDisplayWidget extends StatelessWidget {
  final String error;
  const ErrorDisplayWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 80),
          const SizedBox(height: 20),
          Text(
            error,
            style: const TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // العودة إلى الشاشة السابقة (مثلاً، شاشة إدخال PIN)
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text(
              'back',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
