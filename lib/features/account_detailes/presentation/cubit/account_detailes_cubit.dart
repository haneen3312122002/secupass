/// A Cubit responsible for loading and managing the state of
/// a single account details screen.
///
/// Responsibilities:
/// - Requests account details by ID from the domain layer
///   using `GetAccountDetailesUseCase`.
/// - Emits loading, success, or error states based on the result.
/// - Handles "account not found" and unexpected errors gracefully.
///
/// State flow:
/// - AccountDetailesLoading:
///   Emitted when the request starts.
/// - AccountDetailesLoaded:
///   Emitted when the account is successfully retrieved.
/// - AccountDetailesError:
///   Emitted when the account does not exist or an exception occurs.
///
/// Architecture:
/// - Follows Clean Architecture principles.
/// - Keeps business logic inside the domain layer (UseCase),
///   while the Cubit only coordinates state changes for the UI.
///
/// This Cubit is used by the account details screen to reactively
/// render loading indicators, data, or error messages.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secupass/features/account_detailes/presentation/cubit/account_detailes_state.dart';
import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';
import 'package:secupass/features/home_screen/domain/usecases/accoun/get_account_detailes.dart';

class AccountDetailesCubit extends Cubit<AccountDetailesState> {
  final GetAccountDetailesUseCase getAccountDetailesUseCase;

  AccountDetailesCubit(this.getAccountDetailesUseCase)
      : super(AccountDetailesLoading());

  Future<void> loadAccountDetailes(int id) async {
    emit(AccountDetailesLoading());
    try {
      // get account details by id
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
