//language:
sealed class LanguageState {}

class LanguageInitState extends LanguageState {
  final String language;
  LanguageInitState({required this.language});
}

class ArabicState extends LanguageState {
  final String language;
  ArabicState({required this.language});
}

class EnglishState extends LanguageState {
  final String language;
  EnglishState({required this.language});
}

//............................................
//theme
sealed class ThemeState {}

class DarkThemeState extends ThemeState {}

class LightThemeState extends ThemeState {}

//............................................
//secure
sealed class SecureTheAppState {}

class YesSecureTheAppState extends SecureTheAppState {}

class NoSecureTheAppState extends SecureTheAppState {}
//............................................
