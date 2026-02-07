import 'package:flutter/material.dart';
import 'package:secupass/features/home_screen/data/data_sourses/accounts_local_datasourse.dart';
import 'package:secupass/features/home_screen/data/data_sourses/nots_datasourse.dart';
import 'package:secupass/features/home_screen/data/models/account_model.dart';
import 'package:secupass/features/home_screen/data/models/nots.dart';
import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';
import 'package:secupass/features/home_screen/domain/reps/account_rep.dart';
import 'package:secupass/features/home_screen/domain/reps/nots_rep.dart';

class NotRepimpl extends NotsRep {
  final NotsLocalDatasourse ds;
  NotRepimpl(this.ds);
  @override
  Future<void> addNot(int? id, String title, String body, DateTime date) async {
    final model = NotModel(id: id, title: title, body: body, date: date);
    await ds.addNot(model);
  }

  @override
  Future<void> deleteNot(int id) async {
    await ds.deleteNot(id);
  }

  @override
  Future<List> getAllNots() async {
    return await ds.getNots();
  }

  @override
  Future<void> updateNot(
      int? id, DateTime date, String title, String body) async {
    await ds.updateNot(
        id, NotModel(id: id, title: title, body: body, date: date));
  }
}
