import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secupass/image_fitch/bloc/photo_event.dart';
import 'package:secupass/image_fitch/bloc/photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final String imagePath;
  final String appName;
  PhotoBloc({this.imagePath = '', this.appName = ''})
      : super(PhotoLoadedState(imagePath)) {
    on<PhotoEvent>((event, emit) async {
      if (event is GetPhotoEvent) {
        emit(PhotoLoadingState());
        try {
          final logoUrl = getPhotoUrl(event.appName);
          emit(PhotoLoadedState(logoUrl));
          print('//..........................................');
          print(logoUrl);
          print('success');
        } catch (e) {
          emit(PhotoErrorState(imagePath));
        }
      }
    });
  }

  // هذه الدالة فقط تبني رابط الشعار ولا تحتاج طلب http
  String getPhotoUrl(String appName) {
    final String domain = appName.toString().toLowerCase();
    final fullDomain = domain.contains('.') ? domain : '$domain.com';
    return 'https://logo.clearbit.com/$fullDomain';
  }
}
