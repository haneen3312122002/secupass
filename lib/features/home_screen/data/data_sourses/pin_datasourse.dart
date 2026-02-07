/// Local data source responsible for managing the application PIN
/// using the local database.
///
/// Responsibilities:
/// - Stores and updates the PIN securely in local storage.
/// - Verifies user-entered PINs against the stored value.
/// - Checks whether a PIN has already been set.
///
/// Methods:
/// - addPin: Saves a new PIN to the database.
/// - updatePin: Updates an existing PIN (requires a valid ID).
/// - verifyPin: Compares the entered PIN with the stored PIN.
/// - isPinSet: Determines if a PIN exists in the database.
///
/// Architecture notes:
/// - Part of the data layer in Clean Architecture.
/// - Contains no UI or business logic.
/// - Focused on persistence and verification of sensitive data.

import 'package:secupass/database_helper.dart';
import '../models/pin_model.dart';

class PinLocalDataSource {
  final DataBaseHelper db;
  PinLocalDataSource(this.db);

  Future<void> addPin(PinModel pin) async {
    await db.insertPin(pin.toJson());
  }

  Future<void> updatePin(PinModel pin) async {
    if (pin.id != null) {
      await db.updatePin(pin.id!, pin.toJson());
    } else {
      throw Exception("Cannot update pin without ID");
    }
  }

  Future<bool> verifyPin(int pin) async {
    return await db.verifyPin(pin);
  }

  Future<bool> isPinSet() async {
    return await db.isPinSet();
  }
}
