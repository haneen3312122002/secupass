import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';

class AccountDetailesState {}

class AccountDetailesLoading extends AccountDetailesState {}

class AccountDetailesLoaded extends AccountDetailesState {
  // This state should hold a single AccountEntitiy for details of one account
  final AccountEntitiy accountDetail;
  AccountDetailesLoaded(this.accountDetail);
}

class AccountDetailesError extends AccountDetailesState {
  String errorMsg;
  AccountDetailesError(this.errorMsg);
}
