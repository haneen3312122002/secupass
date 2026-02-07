import 'package:secupass/features/home_screen/data/data_sourses/pin_datasourse.dart';
import 'package:secupass/features/home_screen/domain/entities/pin_entity.dart';
import 'package:secupass/features/home_screen/domain/reps/pin_rep.dart';
import 'package:secupass/features/home_screen/data/models/pin_model.dart';

class PinRepImpl extends PinRep {
  final PinLocalDataSource ds;
  PinRepImpl(this.ds);

  @override
  Future<void> addPin(PinEntity pin) async {
    final model = PinModel(id: pin.id, pin: pin.pin); // بدون id
    await ds.addPin(model);
  }

  @override
  Future<void> updatePin(PinEntity pin) async {
    if (pin.id == null) {
      throw Exception("Pin ID is required for update.");
    }
    final model = PinModel(id: pin.id, pin: pin.pin); // مع id
    await ds.updatePin(model);
  }

  @override
  Future<bool> verifyPin(int pin) async {
    return await ds.verifyPin(pin);
  }

  @override
  Future<bool> isPinSet() async {
    return await ds.isPinSet();
  }
}
