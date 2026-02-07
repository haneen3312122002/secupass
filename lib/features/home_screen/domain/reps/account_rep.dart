import 'package:secupass/features/home_screen/data/models/account_model.dart';
import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';

abstract class AccountRep {
  Future<void> addAccount(AccountEntitiy account);
  Future<void> deleteAccount(int id);
  Future<void> updateAccount(int? id, AccountEntitiy account);
  Future<List<AccountEntitiy>> getAccounts();
  Future<AccountModel?> getAccountDetailes(int id);
}
