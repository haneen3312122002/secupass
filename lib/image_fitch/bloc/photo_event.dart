sealed class PhotoEvent {}

class GetPhotoEvent extends PhotoEvent {
  // final String imagePath;
  final String appName;

  GetPhotoEvent(this.appName);
}
