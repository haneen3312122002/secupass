// features/account_detailes/presentation/cubit/account_detailes_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secupass/features/account_detailes/presentation/cubit/account_detailes_state.dart';
// Remove the following import as AccountModel is a data layer concern, not domain/presentation here
// import 'package:secupass/features/home_screen/data/models/account_model.dart';
// import 'package:secupass/features/account_detailes/presentation/screens/account_detailes.dart'; // This import is still likely unnecessary
import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';
import 'package:secupass/features/home_screen/domain/usecases/accoun/get_account_detailes.dart';

class AccountDetailesCubit extends Cubit<AccountDetailesState> {
  final GetAccountDetailesUseCase getAccountDetailesUseCase;

  AccountDetailesCubit(this.getAccountDetailesUseCase)
      : super(AccountDetailesLoading());

  Future<void> loadAccountDetailes(int id) async {
    emit(AccountDetailesLoading());
    try {
      // Correctly call the injected use case and expect an AccountEntitiy?
      final AccountEntitiy? accountDetail = await getAccountDetailesUseCase(id);

      if (accountDetail != null) {
        // Emit the single AccountEntitiy
        emit(AccountDetailesLoaded(accountDetail));
      } else {
        // Emit error if account not found
        emit(AccountDetailesError('الحساب غير موجود بهذا المعرف (ID).'));
      }
    } catch (e) {
      // Emit error with the actual exception message
      emit(AccountDetailesError(
          'حدث خطأ أثناء تحميل تفاصيل الحساب: ${e.toString()}'));
    }
  }
}
