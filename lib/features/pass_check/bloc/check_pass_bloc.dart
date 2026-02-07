import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';
import 'package:secupass/features/pass_check/bloc/check_pass_event.dart';
import 'package:secupass/features/pass_check/bloc/check_pass_state.dart';

class CheckPassBloc extends Bloc<CheckPassEvent, CheckPassState> {
  final AccountEntitiy account;

  CheckPassBloc(this.account) : super(checkPassInitState(0, Colors.grey)) {
    on<checkPassStrengthEvent>((event, emit) async {
      final String pass = event.pass;

      emit(checkPassLoadingState());

      try {
        // التحقق من الشروط الأساسية (مخففة للتجربة)
        final error = validatePassword(pass);
        if (error != null) {
          emit(checkPassErrorState(error));
          return;
        }

        // فحص إذا تم تسريب الباسورد
        final isPosted = await isPassPosted(pass);
        final strength = calculateStrength(pass);

        if (isPosted) {
          // إذا مسربة → اللون أحمر + تحذير
          emit(checkPassLoadedState(
            strength,
            Colors.red,
            warning:
                '⚠ Password found in a data breach! Change it immediately.',
          ));
        } else {
          // إذا غير مسربة → النتيجة الطبيعية
          final color = getStrengthColor(strength);
          emit(checkPassLoadedState(strength, color));
        }
      } catch (e) {
        emit(checkPassErrorState('Unexpected error: ${e.toString()}'));
      }
    });
  }

  String? validatePassword(String pass) {
    if (pass.isEmpty) {
      return 'Password cannot be empty.';
    }
    if (pass.length < 12) {
      return 'Password must be at least 12 characters long.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(pass)) {
      return 'Password must contain at least one uppercase letter.';
    }
    if (!RegExp(r'[a-z]').hasMatch(pass)) {
      return 'Password must contain at least one lowercase letter.';
    }
    if (!RegExp(r'[0-9]').hasMatch(pass)) {
      return 'Password must contain at least one number.';
    }
    if (!RegExp(r'[!@#\$&*~%^()\-_=+{};:,<.>?]').hasMatch(pass)) {
      return 'Password must contain at least one special character.';
    }
    return null; // ✅ إذا اجتاز كل الشروط
  }

  Future<bool> isPassPosted(String pass) async {
    final bytes = utf8.encode(pass);
    final sha1hash = sha1.convert(bytes).toString().toUpperCase();
    final prefix = sha1hash.substring(0, 5);
    final suffix = sha1hash.substring(5);

    final url = Uri.parse('https://api.pwnedpasswords.com/range/$prefix');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final lines = response.body.split('\n');
      for (var line in lines) {
        final parts = line.split(':');
        if (parts[0].trim() == suffix) {
          return true; // تم تسريبه
        }
      }
      return false;
    } else {
      throw Exception('Failed to check password leak.');
    }
  }

  double calculateStrength(String pass) {
    double score = 0;
    if (pass.length >= 12) score += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(pass)) score += 0.2;
    if (RegExp(r'[a-z]').hasMatch(pass)) score += 0.2;
    if (RegExp(r'[0-9]').hasMatch(pass)) score += 0.2;
    if (RegExp(r'[!@#\$&*~%^()\-_=+{};:,<.>?]').hasMatch(pass)) score += 0.15;
    return score.clamp(0.0, 1.0);
  }

  Color getStrengthColor(double strength) {
    if (strength < 0.4) return Colors.red;
    if (strength < 0.7) return Colors.orange;
    return Colors.green;
  }
}

// تعديل حالة checkPassLoadedState لإضافة التحذير
