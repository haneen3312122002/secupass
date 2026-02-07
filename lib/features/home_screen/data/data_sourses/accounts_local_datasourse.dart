/// Local data source responsible for interacting with the local database
/// to manage account-related data.
///
/// Responsibilities:
/// - Acts as a thin layer between the database helper and the repository.
/// - Performs CRUD operations for accounts (Create, Read, Update, Delete).
/// - Converts raw database maps into `AccountModel` objects.
///
/// Methods:
/// - addAccount: Inserts a new account into the local database.
/// - getAccountDetailes: Retrieves a single account by its ID.
/// - getAccounts: Retrieves all saved accounts.
/// - updateAccount: Updates an existing account by ID.
/// - deleteAccount: Removes an account from the database.
///
/// Architecture notes:
/// - This class belongs to the data layer in Clean Architecture.
/// - Contains no business logic; it only handles data persistence.
/// - Keeps database access centralized and easy to maintain.

import 'package:secupass/database_helper.dart';
import 'package:secupass/features/home_screen/data/models/account_model.dart';

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
