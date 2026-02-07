import 'package:secupass/database_helper.dart';
import 'package:secupass/features/home_screen/data/models/account_model.dart';
import 'package:secupass/features/home_screen/data/models/nots.dart';
import 'package:sqflite/sqflite.dart';

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
