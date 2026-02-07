import 'package:secupass/features/home_screen/domain/entities/pin_entity.dart';
import 'package:secupass/features/home_screen/domain/reps/pin_rep.dart';

class UpdatePinUseCase {
  final PinRep rep;
  UpdatePinUseCase(this.rep);

  Future<void> call(PinEntity pin) => rep.updatePin(pin);
}
