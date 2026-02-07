import 'package:secupass/features/home_screen/data/models/account_model.dart';
import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';
import 'package:secupass/features/home_screen/domain/reps/account_rep.dart';

class UpdateAccountUseCase {
  final AccountRep rep;
  UpdateAccountUseCase(this.rep);
  Future<void> call(int? id, AccountEntitiy account) =>
      rep.updateAccount(id, account);
}
