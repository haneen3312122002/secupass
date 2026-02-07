//language:
sealed class LanguageEvent {}

class ArabicEvent extends LanguageEvent {}

class EnglishEvent extends LanguageEvent {}

//............................................
//theme
sealed class ThemeEvent {}

class DarkThemeEvent extends ThemeEvent {}

class LightThemeEvent extends ThemeEvent {}

//............................................
//secure
sealed class SecureTheAppEvent {}

class YesSecureTheAppEvent extends SecureTheAppEvent {}

class NoSecureTheAppEvent extends SecureTheAppEvent {}
//............................................
