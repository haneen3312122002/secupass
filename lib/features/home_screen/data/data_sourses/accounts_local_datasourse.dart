import 'package:secupass/database_helper.dart';
import 'package:secupass/features/home_screen/data/models/account_model.dart';
import 'package:sqflite/sqflite.dart';

class AccountsLocalDatasourse {
  final DataBaseHelper db;
  AccountsLocalDatasourse(this.db);
  Future<void> addAccount(AccountModel account) async {
    await db.insertAccount(account.toMap());
  }

  Future<AccountModel?> getAccountDetailes(int? id) async {
    return await db.getAccountDetails(id);
  }

  Future<void> deleteAccount(int id) async {
    await db.deleteAccount(id);
  }

  Future<List<AccountModel>> getAccounts() async {
    final maps = await db.getAccounts();
    return maps.map((e) => AccountModel.fromMap(e)).toList();
  }

  Future<void> updateAccount(int? id, AccountModel account) async {
    await db.updateAccount(id, account.toMap());
  }
}
