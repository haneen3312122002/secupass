import 'package:secupass/features/home_screen/data/data_sourses/accounts_local_datasourse.dart';
import 'package:secupass/features/home_screen/data/models/account_model.dart';
import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';
import 'package:secupass/features/home_screen/domain/reps/account_rep.dart';

class AccountRepimpl extends AccountRep {
  final AccountsLocalDatasourse ds;
  AccountRepimpl(this.ds);
  @override
  Future<void> addAccount(AccountEntitiy account) async {
    final model = AccountModel(
      id: account.id,
      appName: account.appName,
      photoPath: account.photoPath,
      encPass: account.encPass,
      userName: account.userName,
      lastUpdate: account.lastUpdate,
      selectedDays: account.selectedDays,
    );
    await ds.addAccount(model);
  }

  @override
  Future<void> deleteAccount(int id) async {
    await ds.deleteAccount(id);
  }

  @override
  Future<List<AccountEntitiy>> getAccounts() async {
    final models = await ds.getAccounts();
    return models
        .map((model) => AccountEntitiy(
              id: model.id,
              appName: model.appName,
              photoPath: model.photoPath,
              encPass: model.encPass,
              userName: model.userName,
              lastUpdate: model.lastUpdate,
              selectedDays: model.selectedDays,
            ))
        .toList();
  }

  @override
  Future<void> updateAccount(int? id, AccountEntitiy account) async {
    final model = AccountModel(
        id: account.id,
        appName: account.appName,
        photoPath: account.photoPath,
        encPass: account.encPass,
        userName: account.userName,
        lastUpdate: account.lastUpdate,
        selectedDays: account.selectedDays);

    await ds.updateAccount(id, model);
  }

  @override
  Future<AccountModel?> getAccountDetailes(int? id) async {
    return await ds.getAccountDetailes(id);
  }
}
