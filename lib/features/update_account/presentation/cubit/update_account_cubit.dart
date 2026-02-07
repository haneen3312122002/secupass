import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';
import 'package:secupass/features/home_screen/domain/usecases/accoun/update_usecase.dart';
import 'package:secupass/features/update_account/presentation/cubit/account_uodate_state.dart';

class UpdateAccountCubit extends Cubit<UpdateAccountState> {
  UpdateAccountCubit(this.update, this.account)
      : super(UpdateAccountInit(account, account.selectedDays));
  final UpdateAccountUseCase update;
  AccountEntitiy account;

  updateAccount(AccountEntitiy account) async {
    emit(UpdateAccountSaving());
    try {
      await update.call(account.id, account);
      emit(UpdateAccountSaved('Account updated successfully!'));
    } catch (e) {
      emit(UpdateAccountError('error'));
    }
  }

  void changeSelectedDays(int days) {
    emit(UpdateAccountState(updatedSelectedDays: days));
  }
}
