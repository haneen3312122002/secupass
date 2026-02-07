import 'package:secupass/database_helper.dart';
import '../models/pin_model.dart';

class PinLocalDataSource {
  final DataBaseHelper db;
  PinLocalDataSource(this.db);

  Future<void> addPin(PinModel pin) async {
    await db.insertPin(pin.toJson());
  }

  Future<void> updatePin(PinModel pin) async {
    if (pin.id != null) {
      await db.updatePin(pin.id!, pin.toJson());
    } else {
      throw Exception("Cannot update pin without ID");
    }
  }

  Future<bool> verifyPin(int pin) async {
    return await db.verifyPin(pin);
  }

  Future<bool> isPinSet() async {
    return await db.isPinSet();
  }
}
