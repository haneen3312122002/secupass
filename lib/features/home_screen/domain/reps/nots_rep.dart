abstract class NotsRep {
  Future<List<dynamic>> getAllNots();
  Future<void> addNot(int? id, String title, String body, DateTime date);
  Future<void> deleteNot(int id);
  Future<void> updateNot(int? id, DateTime date, String title, String body);
}
