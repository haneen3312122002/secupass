import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';
import 'package:secupass/features/home_screen/domain/reps/account_rep.dart';

class GetAccountDetailesUseCase {
  final AccountRep rep; // Inject the repository

  GetAccountDetailesUseCase(this.rep); // Only inject the repository

  // The 'call' method takes the ID as an argument
  // It returns Future<AccountEntitiy?> because the repository returns an entity
  Future<AccountEntitiy?> call(int id) async {
    return await rep.getAccountDetailes(id);
  }
}
