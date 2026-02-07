import 'package:flutter/material.dart';

sealed class CheckPassEvent {}

class checkPassStrengthEvent extends CheckPassEvent {
  final String pass;
  checkPassStrengthEvent(this.pass);
}
