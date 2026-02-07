import 'package:flutter/cupertino.dart';

sealed class PhotoState {
  final String imagePath;

  PhotoState(this.imagePath);
}

class PhotoLoadingState extends PhotoState {
  PhotoLoadingState() : super('');
}

class PhotoLoadedState extends PhotoState {
  PhotoLoadedState(super.imagePath);
}

class PhotoErrorState extends PhotoState {
  PhotoErrorState(super.imagePath);
}
