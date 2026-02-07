import 'package:secupass/features/home_screen/domain/reps/nots_rep.dart';

class DeleteNotUseCase {
  final NotsRep rep;
  DeleteNotUseCase(this.rep);
  Future<void> call(int id) => rep.deleteNot(id);
}
