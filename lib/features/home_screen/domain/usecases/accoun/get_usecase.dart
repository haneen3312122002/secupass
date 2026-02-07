import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';
import 'package:secupass/features/home_screen/domain/reps/account_rep.dart';

class GetAccountsUseCase {
  final AccountRep rep;
  GetAccountsUseCase(this.rep);
  Future<List<AccountEntitiy>> call() => rep.getAccounts();
}
