/// A reusable form widget that collects the main account inputs:
/// - App name
/// - Username / Email
/// - Password
///
/// UI behavior:
/// - Supports light/dark mode styling by dynamically adjusting colors.
/// - Password field includes a visibility toggle (show / hide).
/// - Includes a "Check" button next to the password field to validate strength.
/// - Displays a password strength bar and an optional warning message.
///
/// BLoC integration (CheckPassBloc):
/// - This widget does not calculate password strength by itself.
/// - When the user presses the check button, it dispatches:
///   `checkPassStrengthEvent(widget.pass.text)`
///   to `CheckPassBloc`.
/// - The UI then reacts to the bloc state:
///   - checkPassLoadingState: disables the button and shows a loading indicator.
///   - checkPassLoadedState: shows PasswordStrengthBar (len + color) and warning text (if any).
///   - checkPassErrorState: displays an error message.
///
/// This separation keeps the UI focused on rendering while the business logic
/// (password strength checking) stays inside the BLoC.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secupass/features/pass_check/bloc/check_pass_bloc.dart';
import 'package:secupass/features/pass_check/bloc/check_pass_event.dart';
import 'package:secupass/features/pass_check/bloc/check_pass_state.dart';
import 'package:secupass/features/pass_check/screen/pass_check_bar.dart';
import 'package:secupass/l10n/app_localizations.dart';

// Import the AccountEntitiy class to be able to create an instance of it

class MyFeilds extends StatefulWidget {
  final TextEditingController appname;
  final TextEditingController email;
  final TextEditingController pass;

  const MyFeilds(this.appname, this.email, this.pass, {super.key});

  @override
  _MyFeildsState createState() => _MyFeildsState();
}

class _MyFeildsState extends State<MyFeilds> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final fillColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final iconColor = isDarkMode ? Colors.white70 : Colors.black54;
    final labelColor = isDarkMode ? Colors.white : Colors.black54;
    final hintColor = isDarkMode ? Colors.grey[400] : Colors.black38;
    final borderColor = isDarkMode ? Colors.grey[600] : Colors.grey;
    final focusedBorderColor = isDarkMode ? Colors.blue[300] : Colors.blue;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        //  App Name Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: widget.appname,
            keyboardType: TextInputType.text,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              labelText: language.app_name,
              labelStyle: TextStyle(color: labelColor),
              hintText: language.app_name_hint,
              hintStyle: TextStyle(color: hintColor),
              prefixIcon: Align(
                widthFactor: 1.0,
                child: Icon(Icons.apps, color: iconColor),
              ),
              fillColor: fillColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    width: 1, style: BorderStyle.solid, color: borderColor!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                    color: focusedBorderColor!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    width: 1, style: BorderStyle.solid, color: borderColor!),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
        const SizedBox(height: 16.0),

        //  Email/Username Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: widget.email,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              labelText: language.user_name,
              labelStyle: TextStyle(color: labelColor),
              hintText: language.user_name_hint,
              hintStyle: TextStyle(color: hintColor),
              prefixIcon: Align(
                widthFactor: 1.0,
                child: Icon(Icons.person, color: iconColor),
              ),
              fillColor: fillColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    width: 1, style: BorderStyle.solid, color: borderColor!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                    color: focusedBorderColor!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    width: 1, style: BorderStyle.solid, color: borderColor!),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
        const SizedBox(height: 16.0),

        //  Password Field with Visibility Toggle and Check Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.pass,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !_isPasswordVisible,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: language.password,
                    labelStyle: TextStyle(color: labelColor),
                    hintText: language.password_hint,
                    hintStyle: TextStyle(color: hintColor),
                    prefixIcon: Align(
                      widthFactor: 1.0,
                      child: Icon(Icons.lock, color: iconColor),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: iconColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    fillColor: fillColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.solid,
                          color: borderColor!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.solid,
                          color: focusedBorderColor!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.solid,
                          color: borderColor!),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              BlocBuilder<CheckPassBloc, CheckPassState>(
                builder: (context, state) {
                  final isChecking = state is checkPassLoadingState;
                  final buttonIcon = isChecking
                      ? const CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white)
                      : Icon(Icons.check, color: iconColor);
                  return SizedBox(
                    width: 50,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDarkMode ? Colors.blue[600] : Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(0),
                      ),
                      onPressed: isChecking
                          ? null
                          : () {
                              // 💡 هنا يتم إرسال event إلى البلوك مع تمرير القيمة الحالية من حقل الإدخال
                              context.read<CheckPassBloc>().add(
                                    checkPassStrengthEvent(widget.pass.text),
                                  );
                            },
                      child: buttonIcon,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),

        //  Password Strength Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocBuilder<CheckPassBloc, CheckPassState>(
            builder: (context, state) {
              if (state is checkPassLoadedState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PasswordStrengthBar(
                      strength: state.len,
                      color: state.color,
                    ),
                    if (state.warning != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        state.warning!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                );
              } else if (state is checkPassErrorState) {
                return Text(
                  state.error,
                  style: TextStyle(color: theme.colorScheme.error),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),

        const SizedBox(height: 30.0),
      ],
    );
  }
}

// Placeholder for PasswordStrengthBar and AccountEntitiy for this example to be runnable
