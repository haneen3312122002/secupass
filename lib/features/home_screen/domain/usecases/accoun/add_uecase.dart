import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';
import 'package:secupass/features/home_screen/domain/reps/account_rep.dart';

class AddAccountUseCase {
  final AccountRep rep;
  AddAccountUseCase(this.rep);
  Future<void> call(AccountEntitiy account) => rep.addAccount(account);
}
