class DeleteAccountState {}

class DeletingAccountState extends DeleteAccountState {}

class DeleteInitAccountState extends DeleteAccountState {}

class DeletedAccountState extends DeleteAccountState {
  String msg;
  DeletedAccountState(this.msg);
}

class DeleteAccountErrorState extends DeleteAccountState {
  String erorrMsg;
  DeleteAccountErrorState(this.erorrMsg);
}
