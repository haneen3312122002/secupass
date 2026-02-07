import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';

class GetAccountsState {}

class LoadingAccounts extends GetAccountsState {}

class LoadedAccounts extends GetAccountsState {
  final List<AccountEntitiy> accounts;
  LoadedAccounts(this.accounts);
}

class ErrorAccounts extends GetAccountsState {
  final String errorMsg;
  ErrorAccounts(this.errorMsg);
}

class NoAccounts extends GetAccountsState {
  final String msg;
  NoAccounts(this.msg);
}
