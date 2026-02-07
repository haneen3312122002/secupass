import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secupass/l10n/app_localizations.dart';
// No need to import 'nav_bar.dart' directly if navigating by named route
// import 'package:secupass/features/NavBar_page/presentation/screens/nav_bar.dart';

class StatusPage extends StatefulWidget {
  final bool isSuccess;
  final String message;

  const StatusPage({
    super.key,
    required this.isSuccess,
    required this.message,
  });

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          // This callback is triggered when a pop event is attempted.
          // Since canPop is false, didPop will always be false,
          // so no action is needed here.
          // This is the correct, modern way to handle this behavior.
        },
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: Icon(
                        widget.isSuccess ? Icons.check_circle : Icons.error,
                        size: 150,
                        color: widget.isSuccess
                            ? Colors.green[600]
                            : Colors.red[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    widget.isSuccess
                        ? language.status_success_title
                        : language.status_error_title,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: widget.isSuccess
                          ? Colors.green[700]
                          : Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton.icon(
                    onPressed: () {
                      // === THE CLEANEST NAVIGATION TO THE ROOT ===
                      // This replaces the current route (StatusPage) with the named root route '/'.
                      // It's the most common and reliable way to go back to a main screen
                      // that serves as the app's root with a persistent navigation bar.
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacementNamed('home');
                    },
                    icon: const Icon(Icons.home),
                    label: Text(language.return_to_home_button),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor:
                          widget.isSuccess ? Colors.green : Colors.red,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
    // ❌ منع الرجوع للخلف
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
