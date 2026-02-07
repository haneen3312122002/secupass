import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secupass/features/settings_page/presentation/bloc/set_event.dart';
import 'package:secupass/features/settings_page/presentation/bloc/set_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final String language;

  LanguageBloc(this.language) : super(LanguageInitState(language: language)) {
    on<LanguageEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      if (event is ArabicEvent) {
        prefs.setString('language', 'ar');
        emit(ArabicState(language: 'ar'));
      } else if (event is EnglishEvent) {
        prefs.setString('language', 'en');
        emit(EnglishState(language: 'en'));
      }
    });
  }
}

//.....................................
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final bool isDark;

  ThemeBloc(this.isDark)
      : super(isDark ? DarkThemeState() : LightThemeState()) {
    on<ThemeEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      if (event is DarkThemeEvent) {
        prefs.setBool('isDarkTheme', true);
        emit(DarkThemeState());
      } else if (event is LightThemeEvent) {
        prefs.setBool('isDarkTheme', false);
        emit(LightThemeState());
      }
    });
  }
}
