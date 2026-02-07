import 'package:secupass/features/home_screen/domain/reps/pin_rep.dart';

class VerifyPinUseCase {
  final PinRep repository;
  VerifyPinUseCase(this.repository);

  Future<bool> call(int pin) async {
    return await repository.verifyPin(pin);
  }

  Future<bool> isPinSet() async {
    return await repository.isPinSet();
  }
}
