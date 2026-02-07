import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secupass/features/account_detailes/presentation/cubit/delete_account_state.dart';
import 'package:secupass/features/home_screen/domain/usecases/accoun/delete_usecase.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit(this.delete) : super(DeleteInitAccountState());
  final DeleteAccountUseCase delete;
  Future<void> DeleteAccount(int id) async {
    emit(DeleteInitAccountState());
    try {
      delete.call(id);
      emit(DeletedAccountState('deleted'));
    } catch (e) {
      emit(DeleteAccountErrorState('error'));
    }
  }
}
