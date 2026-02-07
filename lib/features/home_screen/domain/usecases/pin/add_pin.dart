import 'package:secupass/features/home_screen/domain/entities/pin_entity.dart';
import 'package:secupass/features/home_screen/domain/reps/pin_rep.dart';

class AddPinUseCase {
  final PinRep rep;
  AddPinUseCase(this.rep);

  Future<void> call(PinEntity pin) => rep.addPin(pin);
}
