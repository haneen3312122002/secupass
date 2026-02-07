import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secupass/features/settings_page/presentation/bloc/set_bloc.dart';
import 'package:secupass/features/settings_page/presentation/bloc/set_event.dart';
import 'package:secupass/features/settings_page/presentation/bloc/set_state.dart';
import 'package:secupass/l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        bool isArabic = false;
        if (languageState is ArabicState) {
          isArabic = true;
        } else if (languageState is EnglishState) {
          isArabic = false;
        } else if (languageState is LanguageInitState) {
          isArabic = languageState.language == 'ar';
        }

        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            bool isDarkTheme = themeState is DarkThemeState;

            return Scaffold(
              appBar: AppBar(
                title: Text(localization.settings),
                centerTitle: true,
              ),
              body: ListView(
                children: [
                  SwitchListTile(
                    title: Text(
                        '${localization.language}: ${isArabic ? localization.language_arabic : localization.language_english}'),
                    value: isArabic,
                    onChanged: (value) {
                      final bloc = context.read<LanguageBloc>();
                      if (value) {
                        bloc.add(ArabicEvent());
                      } else {
                        bloc.add(EnglishEvent());
                      }
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(localization.dark_mode),
                    value: isDarkTheme,
                    onChanged: (value) {
                      final bloc = context.read<ThemeBloc>();
                      if (value) {
                        bloc.add(DarkThemeEvent());
                      } else {
                        bloc.add(LightThemeEvent());
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
