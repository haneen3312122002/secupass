// data/models/pin_model.dart
import 'package:secupass/features/home_screen/domain/entities/pin_entity.dart';

// PinModel
class PinModel extends PinEntity {
  PinModel({  int? id, required int pin}) : super(id: id, pin: pin);

  factory PinModel.fromJson(Map<String, dynamic> json) {
    return PinModel(
      id: json['id'],
      pin: json['pin'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'pin': pin,
    };
    if (id != null) data['id'] = id;
    return data;
  }
}
