import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secupass/features/authentication/bloc/auth_bloc.dart';
import 'package:secupass/features/authentication/bloc/auth_event.dart';
import 'package:secupass/features/authentication/bloc/auth_state.dart';
import 'package:secupass/features/authentication/screen/auth_screen.dart';
import 'package:secupass/features/home_screen/domain/entities/pin_entity.dart';
import 'package:secupass/l10n/app_localizations.dart';

class PinInputScreen extends StatefulWidget {
  final PinInputType inputType;
  final String? errorText;

  const PinInputScreen({
    super.key,
    required this.inputType,
    this.errorText,
  });

  @override
  State<PinInputScreen> createState() => _PinInputScreenState();
}

class _PinInputScreenState extends State<PinInputScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  String? _localErrorText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitPin() {
    final localization = AppLocalizations.of(context)!;
    String pin = _controllers.map((c) => c.text).join();

    if (pin.length != 4 || pin.contains(RegExp(r'[^0-9]'))) {
      setState(() {
        _localErrorText = localization.pin_validation_error;
      });
      return;
    }

    setState(() {
      _localErrorText = null;
    });

    final int parsedPin = int.parse(pin);
    final authBloc = BlocProvider.of<AuthBloc>(context);

    if (widget.inputType == PinInputType.create) {
      final pinEntity = PinEntity(id: null, pin: parsedPin);
      authBloc.add(AddPinEvent(pin: pinEntity));
    } else {
      authBloc.add(AuthVerifyPinEvent(pin: parsedPin));
    }
  }

  void bruteForcePin() async {
    final bloc = BlocProvider.of<AuthBloc>(context);
    for (int pin = 0; pin <= 9999; pin++) {
      await Future.delayed(const Duration(microseconds: 1));
      bloc.add(AuthVerifyPinEvent(pin: pin));
      await Future.delayed(const Duration(milliseconds: 10));
      if (bloc.state is AuthPinVerifiedState) {
        if (kDebugMode) {
          print("✅ Correct PIN: $pin");
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    String promptText = widget.inputType == PinInputType.create
        ? localization.first_run_prompt
        : localization.pin_input_prompt;
    String buttonText = widget.inputType == PinInputType.create
        ? localization.pin_save_button
        : localization.pin_input_button;
    String? displayError = _localErrorText ?? widget.errorText;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            promptText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 30),
          _buildPinInputFields(),
          if (displayError != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                displayError,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitPin,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (widget.inputType == PinInputType.verify && kDebugMode)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: bruteForcePin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "Start PIN Brute Force",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPinInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: _controllers[i],
              focusNode: _focusNodes[i],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              obscureText: true,
              maxLength: 1,
              decoration: const InputDecoration(
                counterText: "",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty && i < 3) {
                  _focusNodes[i + 1].requestFocus();
                } else if (value.isEmpty && i > 0) {
                  _focusNodes[i - 1].requestFocus();
                }
              },
            ),
          ),
        );
      }),
    );
  }
}

//................................................
