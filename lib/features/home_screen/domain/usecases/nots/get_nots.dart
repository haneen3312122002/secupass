import 'package:secupass/features/home_screen/domain/reps/nots_rep.dart';

class GetNotsUseCase {
  final NotsRep rep;
  GetNotsUseCase(this.rep);
  Future<List<dynamic>> call() => rep.getAllNots();
}
