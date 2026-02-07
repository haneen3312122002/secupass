class AddAccountsState {
  final int selectedDays;

  AddAccountsState({this.selectedDays = 30});
}

class InitState extends AddAccountsState {}

class AddingState extends AddAccountsState {}

class AddedState extends AddAccountsState {
  final String msg;
  AddedState(this.msg);
}

class ErrorSatate extends AddAccountsState {
  final String errorMsg;
  ErrorSatate(this.errorMsg);
}
