import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';
import 'package:secupass/features/home_screen/domain/reps/account_rep.dart';

class DeleteAccountUseCase {
  final AccountRep rep;
  DeleteAccountUseCase(this.rep);
  Future<void> call(int id) => rep.deleteAccount(id);
}
