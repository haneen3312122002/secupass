import 'package:secupass/features/home_screen/domain/reps/nots_rep.dart';

class AddNotUseCase {
  final NotsRep rep;
  AddNotUseCase(this.rep);
  Future<void> call(int? id, String title, String body, DateTime date) =>
      rep.addNot(id, title, body, date);
}
