import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secupass/core/widgets/error_widget.dart';
import 'package:secupass/core/widgets/loading_widget.dart';
import 'package:secupass/core/widgets/pin_input.dart';
import 'package:secupass/core/widgets/success_widget.dart';
import 'package:secupass/features/NavBar_page/presentation/screens/nav_bar.dart';
import 'package:secupass/features/authentication/bloc/auth_bloc.dart';
import 'package:secupass/features/authentication/bloc/auth_state.dart';
import 'package:secupass/l10n/app_localizations.dart';

// This is the main authentication screen that handles both the first run scenario (setting a new PIN) and subsequent runs (verifying the existing PIN).
enum PinInputType { create, verify }

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.app_title),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthPinVerifiedState) {
            // Navigate to the main app screen after successful authentication
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => CustomNavBar()),
              (route) => false,
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            Widget content;

            if (state is AuthLoadingState) {
              // Show loading indicator while processing
              content = const LoadingWidget();
            } else if (state is AuthFirstAppRunState) {
              // Show PIN creation screen on first run
              content = const PinInputScreen(inputType: PinInputType.create);
            } else if (state is AuthInputPinState) {
              // Show PIN verification screen on subsequent runs
              content = const PinInputScreen(inputType: PinInputType.verify);
            } else if (state is AuthInvalidPinState) {
              // Show PIN verification screen with error message if the PIN is invalid
              content = PinInputScreen(
                inputType: PinInputType.verify,
                errorText: localization.invalid_pin_error,
              );
            } else if (state is AuthenticatedState) {
              // Show success screen after successful authentication
              content = const SuccessWidget();
            } else if (state is AuthenticationErrorState) {
              // Show error screen if there was an authentication error
              content = ErrorDisplayWidget(error: state.error);
            } else {
              // Default content (should not reach here)
              content = Center(child: Text(localization.auth_welcome_message));
            }
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: content,
              ),
            );
          },
        ),
      ),
    );
  }
}

//................................................


//.................................................


