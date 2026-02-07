class NotState {}

class NotInitial extends NotState {
  String msg;
  NotInitial({required this.msg});
}

class NotLoading extends NotState {}

class NotLoaded extends NotState {
  List<dynamic> nots;
  NotLoaded(this.nots);
}

class NotError extends NotState {
  final String message;
  NotError(this.message);
}
