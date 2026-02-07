import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secupass/core/widgets/buttom_navbar.dart';
import 'package:secupass/features/NavBar_page/presentation/screens/nav_bar.dart';
import 'package:secupass/features/authentication/bloc/auth_bloc.dart';
import 'package:secupass/features/authentication/bloc/auth_event.dart';
import 'package:secupass/features/authentication/bloc/auth_state.dart';
import 'package:secupass/features/home_screen/domain/entities/pin_entity.dart';
import 'package:secupass/l10n/app_localizations.dart';

// Enum لتحديد نوع إدخال PIN (إنشاء أو تحقق)
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
            // الانتقال إلى شاشة CustomNavBar عند التحقق من PIN بنجاح
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
              content = const LoadingWidget();
            } else if (state is AuthFirstAppRunState) {
              content = const PinInputScreen(inputType: PinInputType.create);
            } else if (state is AuthInputPinState) {
              content = const PinInputScreen(inputType: PinInputType.verify);
            } else if (state is AuthInvalidPinState) {
              content = PinInputScreen(
                inputType: PinInputType.verify,
                errorText: localization.invalid_pin_error,
              );
            } else if (state is AuthenticatedState) {
              content = const SuccessWidget();
            } else if (state is AuthenticationErrorState) {
              content = ErrorDisplayWidget(error: state.error);
            } else {
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

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

//.................................................

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
    // تركيز على أول حقل إدخال عند بناء الواجهة
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
    // بدء مؤقت للانتقال بعد 3 ثوانٍ
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
    _timer?.cancel(); // إلغاء المؤقت لمنع تسرب الذاكرة
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
