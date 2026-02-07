import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secupass/features/home_screen/domain/usecases/accoun/get_usecase.dart';
import 'package:secupass/features/home_screen/presentation/cubit/get_accounts_state.dart';

class GetAccountsCubit extends Cubit<GetAccountsState> {
  GetAccountsCubit(this.getAccountsUseCase) : super(LoadingAccounts());
  GetAccountsUseCase getAccountsUseCase;

  loadAccounts() async {
    emit(LoadingAccounts());
    try {
      final accounts = await getAccountsUseCase();
      if (accounts.isEmpty) {
        emit(NoAccounts('no accounts'));
      } else {
        emit(LoadedAccounts(accounts));
      }
    } catch (e) {
      emit(ErrorAccounts('error: $e'));
    }
  }
}
