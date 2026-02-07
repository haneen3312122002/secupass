import 'dart:async';

import 'package:flutter/material.dart';
import 'package:secupass/features/NavBar_page/presentation/screens/nav_bar.dart';
import 'package:secupass/l10n/app_localizations.dart';

class SuccessWidget extends StatefulWidget {
  const SuccessWidget({super.key});

  @override
  State<SuccessWidget> createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => CustomNavBar()),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); //
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false, // منع العودة إلى الخلف
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            Text(
              localization.pin_added_success,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(), // مؤشر تحميل
          ],
        ),
      ),
    );
  }
}

//................................................
