import 'package:secupass/features/home_screen/domain/entities/not_entity.dart';

class NotModel extends NotEntity {
  final int? id;
  final String title;
  final String body;
  final DateTime date;

  NotModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
  }) : super(id: id, title: title, body: body, date: date);

  factory NotModel.fromJson(Map<String, dynamic> json) {
    return NotModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'date': date.toIso8601String(),
    };
  }
}
