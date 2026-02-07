/// Checks whether the app is being launched for the first time.
///
/// How it works:
/// - Reads a boolean value (`firstRun`) from SharedPreferences.
/// - If the value does not exist, it assumes this is the first launch.
/// - On the first launch only, it saves `false` to prevent repeating
///   first-run logic on future app launches.
///
/// Returns:
/// - `true`  → App is opened for the first time.
/// - `false` → App has been opened before.
///
/// Common use cases:
/// - Showing onboarding or introduction screens.
/// - Running one-time setup logic.
/// - Displaying welcome messages or tutorials.

import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isFirstRun() async {
  final prefs = await SharedPreferences.getInstance();
  bool firstRun = prefs.getBool('firstRun') ??
      true; // the app reunned for the first time by defualt
  if (firstRun) {
    //if yes:: set to false to not make it true again
    await prefs.setBool('firstRun', false);
  }
  return firstRun;
}
