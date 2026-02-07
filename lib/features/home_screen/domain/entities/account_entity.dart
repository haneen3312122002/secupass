import 'package:equatable/equatable.dart';

class AccountEntitiy extends Equatable {
  final int? id;
  final String appName;
  final String? photoPath;
  final String encPass;
  final String userName;
  final DateTime lastUpdate; // This needs to be part of the comparison
  final DateTime? nextUpdate;
  final int selectedDays;

  AccountEntitiy({
    this.id,
    required this.appName,
    required this.selectedDays,
    required this.encPass,
    required this.userName,
    required this.photoPath,
    required this.lastUpdate,
  }) : nextUpdate = calcDstes(selectedDays, lastUpdate);

  static DateTime calcDstes(int selectedDays, DateTime lastUpdate) {
    return lastUpdate.add(Duration(days: selectedDays));
  }

  // ✅ copyWith method
  AccountEntitiy copyWith({
    int? id,
    String? appName,
    String? photoPath,
    String? encPass,
    String? userName,
    DateTime? lastUpdate,
    int? selectedDays,
  }) {
    return AccountEntitiy(
      id: id ?? this.id,
      appName: appName ?? this.appName,
      photoPath: photoPath ?? this.photoPath,
      encPass: encPass ?? this.encPass,
      userName: userName ?? this.userName,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      selectedDays: selectedDays ?? this.selectedDays,
    );
  }

  @override
  List<Object?> get props => [
        userName,
        id,
        appName,
        selectedDays,
        encPass,
        lastUpdate, // Add lastUpdate here!
        photoPath,
      ];
}
