import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';

class AccountModel extends AccountEntitiy {
  AccountModel({
    required int? id,
    required String appName,
    required String? photoPath,
    required String encPass,
    required String userName,
    required DateTime lastUpdate,
    required int selectedDays,
  }) : super(
            id: id,
            appName: appName,
            encPass: encPass,
            lastUpdate: lastUpdate,
            photoPath: photoPath,
            selectedDays: selectedDays,
            userName: userName);
  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
        id: map['id'],
        appName: map['appName'],
        photoPath: map['photoPath'],
        encPass: map['encPass'],
        userName: map['userName'],
        lastUpdate: DateTime.parse(map['lastUpdate']),
        selectedDays: map['selectedDays']);
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'appName': appName,
      'photoPath': photoPath,
      'encPass': encPass,
      'userName': userName,
      'lastUpdate': lastUpdate.toIso8601String(),
      'nextUpdate': nextUpdate!.toIso8601String(),
      'selectedDays': selectedDays,
    };
  }
}
