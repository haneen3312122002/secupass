import 'package:secupass/features/home_screen/domain/entities/pin_entity.dart';

abstract class PinRep {
  Future<void> addPin(PinEntity pin);
  Future<void> updatePin(PinEntity pin);
  Future<bool> verifyPin(int pin);
  Future<bool> isPinSet();
}
