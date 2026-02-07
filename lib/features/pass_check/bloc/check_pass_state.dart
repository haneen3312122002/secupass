import 'package:flutter/material.dart';

sealed class CheckPassState {}

class checkPassInitState extends CheckPassState {
  final double len;
  final Color color;
  checkPassInitState(this.len, this.color);
}

class checkPassLoadingState extends CheckPassState {}

class checkPassLoadedState extends CheckPassState {
  final double len;
  final Color color;
  final String? warning;
  checkPassLoadedState(this.len, this.color, {this.warning});
}

class checkPassErrorState extends CheckPassState {
  final String error;
  checkPassErrorState(this.error);
}
