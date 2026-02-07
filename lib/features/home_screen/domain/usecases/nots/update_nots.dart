import 'package:secupass/features/home_screen/domain/reps/nots_rep.dart';

class UpdateNotsUseCase {
  final NotsRep rep;
  UpdateNotsUseCase(this.rep);
  Future<void> call(
          {required int id,
          required DateTime date,
          required String title,
          required String body}) =>
      rep.updateNot(id, date, title, body);
}
