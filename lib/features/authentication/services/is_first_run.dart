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
