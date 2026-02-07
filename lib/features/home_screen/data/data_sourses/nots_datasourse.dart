/// Local data source responsible for handling notification data
/// using the local database.
///
/// Responsibilities:
/// - Provides CRUD operations for notifications.
/// - Acts as an abstraction layer over `DataBaseHelper`.
/// - Converts database maps to `NotModel` and vice versa.
///
/// Methods:
/// - addNot: Inserts a new notification record.
/// - getNots: Retrieves all stored notifications.
/// - updateNot: Updates an existing notification by ID.
/// - deleteNot: Deletes a notification by ID.
///
/// Architecture notes:
/// - Part of the data layer in Clean Architecture.
/// - Contains no business logic.
/// - Keeps database-related code isolated and reusable.

import 'package:secupass/database_helper.dart';
import 'package:secupass/features/home_screen/data/models/nots.dart';

class NotsLocalDatasourse {
  final DataBaseHelper db;
  NotsLocalDatasourse(this.db);
  Future<void> addNot(NotModel not) async {
    await db.insertNot(not.toJson());
  }

  Future<void> deleteNot(int id) async {
    await db.deleteNot(id);
  }

  Future<List<NotModel>> getNots() async {
    final maps = await db.getNots();
    return maps.map((e) => NotModel.fromJson(e)).toList();
  }

  Future<void> updateNot(int? id, NotModel not) async {
    await db.updateNot(id, not.toJson());
  }
}
