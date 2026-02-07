import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';

class UpdateAccountState {
  final int updatedSelectedDays;

  UpdateAccountState({this.updatedSelectedDays = 30});
}

class UpdateAccountInit extends UpdateAccountState {
  AccountEntitiy account;
  final int updatedSelectedDays;

  UpdateAccountInit(this.account, this.updatedSelectedDays);
}

class UpdateAccountSaving extends UpdateAccountState {}

class UpdateAccountSaved extends UpdateAccountState {
  String msg;
  UpdateAccountSaved(this.msg);
}

class UpdateAccountError extends UpdateAccountState {
  String errorMsg;
  UpdateAccountError(this.errorMsg);
}
