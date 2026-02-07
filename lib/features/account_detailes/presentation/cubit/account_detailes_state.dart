import 'package:secupass/features/home_screen/data/models/account_model.dart';
import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';

class AccountDetailesState {}

class AccountDetailesLoading extends AccountDetailesState {}

class AccountDetailesLoaded extends AccountDetailesState {
  // This state should hold a single AccountEntitiy for details of one account
  final AccountEntitiy accountDetail;
  AccountDetailesLoaded(this.accountDetail);

  // Optional: Add for Equatable if you are using it for state comparison
  // @override
  // List<Object?> get props => [accountDetail];
}

class AccountDetailesError extends AccountDetailesState {
  String errorMsg;
  AccountDetailesError(this.errorMsg);
}
