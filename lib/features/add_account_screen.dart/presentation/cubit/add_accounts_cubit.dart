import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secupass/features/add_account_screen.dart/presentation/cubit/add_accounts_state.dart';
import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';
import 'package:secupass/features/home_screen/domain/usecases/accoun/add_uecase.dart';

class AddAccountsCubit extends Cubit<AddAccountsState> {
  AddAccountsCubit(this.addAccountUseCase) : super(InitState());
  final AddAccountUseCase addAccountUseCase;
//init state dose not added because it only show the page
  addAccount(AccountEntitiy account) async {
    emit(AddingState()); //the adding is start
    try {
      await addAccountUseCase.call(account);
      emit(AddedState('Account added successfully!'));
    } catch (e) {
      emit(ErrorSatate('Failed to add account. $e'));
    }
  }

  void setSelectedDays(int days) {
    emit(AddAccountsState(selectedDays: days));
  }
}
