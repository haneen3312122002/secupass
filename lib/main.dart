import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Required for localization delegates

// Core dependencies for BLoC setup
import 'package:secupass/database_helper.dart';
import 'package:secupass/features/authentication/bloc/auth_bloc.dart';
import 'package:secupass/features/authentication/bloc/auth_event.dart';
import 'package:secupass/features/authentication/screen/auth_screen.dart';
import 'package:secupass/features/home_screen/data/data_sourses/accounts_local_datasourse.dart';
import 'package:secupass/features/home_screen/data/data_sourses/nots_datasourse.dart';
import 'package:secupass/features/home_screen/data/data_sourses/pin_datasourse.dart';
import 'package:secupass/features/home_screen/data/rep_imple/account_repimpl.dart';
import 'package:secupass/features/home_screen/data/rep_imple/not_rep_impl.dart';
import 'package:secupass/features/home_screen/data/rep_imple/pin_rep_impl.dart';
import 'package:secupass/features/home_screen/domain/reps/account_rep.dart'; // Use the abstract AccountRep
import 'package:secupass/features/home_screen/domain/reps/pin_rep.dart';
import 'package:secupass/features/home_screen/domain/usecases/accoun/add_uecase.dart';
import 'package:secupass/features/home_screen/domain/usecases/accoun/delete_usecase.dart';
import 'package:secupass/features/home_screen/domain/usecases/accoun/get_account_detailes.dart';
import 'package:secupass/features/home_screen/domain/usecases/accoun/get_usecase.dart';
import 'package:secupass/features/home_screen/domain/usecases/accoun/update_usecase.dart';
import 'package:secupass/features/home_screen/domain/usecases/nots/add_not.dart';
import 'package:secupass/features/home_screen/domain/usecases/nots/delete_not.dart';
import 'package:secupass/features/home_screen/domain/usecases/nots/get_nots.dart';
import 'package:secupass/features/home_screen/domain/usecases/nots/update_nots.dart';

// BLoCs/Cubits
import 'package:secupass/features/NavBar_page/presentation/cubit/nav_cubit.dart';
import 'package:secupass/features/NavBar_page/presentation/screens/nav_bar.dart'; // Your CustomNavBar
import 'package:secupass/features/account_detailes/presentation/cubit/account_detailes_cubit.dart';
import 'package:secupass/features/account_detailes/presentation/cubit/delete_%20account_cubit.dart';
import 'package:secupass/features/add_account_screen.dart/presentation/cubit/add_accounts_cubit.dart';
import 'package:secupass/features/home_screen/domain/usecases/pin/add_pin.dart';
import 'package:secupass/features/home_screen/domain/usecases/pin/update_pin.dart';
import 'package:secupass/features/home_screen/domain/usecases/pin/verify_pin.dart';
import 'package:secupass/features/home_screen/presentation/cubit/get_accounts_cubit.dart';
import 'package:secupass/features/home_screen/presentation/screen/home_screen.dart';
import 'package:secupass/features/notefications_page/presentation/cubit/not_cubit.dart';
import 'package:secupass/features/pass_check/bloc/check_pass_bloc.dart';
import 'package:secupass/features/settings_page/presentation/bloc/set_bloc.dart';
import 'package:secupass/features/settings_page/presentation/bloc/set_state.dart';
import 'package:secupass/image_fitch/bloc/photo_bloc.dart';

// Localization
import 'package:secupass/l10n/app_localizations.dart';
import 'package:secupass/test_server.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin plugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  startDebugServer();

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // Language initialization
  String? savedLanguage = prefs.getString('language');
  savedLanguage ??=
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;

  // Theme initialization
  bool? savedIsDarkTheme = prefs.getBool('isDarkTheme');
  bool initialIsDarkTheme;
  if (savedIsDarkTheme != null) {
    initialIsDarkTheme = savedIsDarkTheme;
  } else {
    // Get device's current theme brightness
    final Brightness brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    initialIsDarkTheme = brightness == Brightness.dark;
  }

  const AndroidInitializationSettings initAndroidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initAndroidSettings,
  );
  plugin.initialize(initializationSettings);

  runApp(MyApp(
    initLanguage: savedLanguage,
    initIsDarkTheme: initialIsDarkTheme,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp(
      {super.key, required this.initLanguage, required this.initIsDarkTheme});
  final String initLanguage;
  final bool initIsDarkTheme;

  @override
  Widget build(BuildContext context) {
    // Instantiate all data sources, repositories, and use cases here
    final DataBaseHelper db = DataBaseHelper();
    final NotsLocalDatasourse nds = NotsLocalDatasourse(db);
    final AccountsLocalDatasourse ds = AccountsLocalDatasourse(db);

    final NotRepimpl nrep = NotRepimpl(nds);
    final AccountRepimpl rep = AccountRepimpl(ds);

    final AddNotUseCase nadd = AddNotUseCase(nrep);
    final GetNotsUseCase nget = GetNotsUseCase(nrep);
    final DeleteNotUseCase ndelete = DeleteNotUseCase(nrep);
    final UpdateNotsUseCase nupdate = UpdateNotsUseCase(nrep);

    final GetAccountsUseCase getAccountsUseCase = GetAccountsUseCase(rep);
    final AddAccountUseCase addAccountUseCase = AddAccountUseCase(rep);
    final GetAccountDetailesUseCase getAccountDetailesUseCase =
        GetAccountDetailesUseCase(rep);
    final DeleteAccountUseCase deleteAccountUseCase = DeleteAccountUseCase(rep);
    final UpdateAccountUseCase updateAccountUseCase = UpdateAccountUseCase(rep);
    final PinLocalDataSource pinDs = PinLocalDataSource(db);
    final PinRepImpl pinRep = PinRepImpl(pinDs);
    final UpdatePinUseCase updatePinUseCase = UpdatePinUseCase(pinRep);
    final AddPinUseCase addPinUseCase = AddPinUseCase(pinRep);
    final VerifyPinUseCase verifyPinUseCase = VerifyPinUseCase(pinRep);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UpdateAccountUseCase>(
            create: (_) => updateAccountUseCase),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => LanguageBloc(initLanguage)),
          BlocProvider(
              create: (_) => ThemeBloc(initIsDarkTheme)), // Provide ThemeBloc
          BlocProvider(create: (_) => GetAccountsCubit(getAccountsUseCase)),
          BlocProvider(create: (_) => PhotoBloc()),

          BlocProvider(create: (_) => AddAccountsCubit(addAccountUseCase)),
          BlocProvider(
              create: (_) =>
                  AuthBloc(addPinUseCase, updatePinUseCase, verifyPinUseCase)
                    ..add(AuthFirstAppRunEvent())),

          BlocProvider(
            create: (_) =>
                NotCubit(plugin, add: nadd, get: nget, update: nupdate),
          ),
          BlocProvider(
              create: (_) => AccountDetailesCubit(getAccountDetailesUseCase)),
          BlocProvider(create: (_) => DeleteAccountCubit(deleteAccountUseCase)),
          BlocProvider(create: (_) => NavBarCubit()),
        ],
        child: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, languageState) {
            Locale locale = const Locale('en');
            if (languageState is ArabicState) {
              locale = const Locale('ar');
            } else if (languageState is EnglishState) {
              locale = const Locale('en');
            } else if (languageState is LanguageInitState) {
              locale = Locale(languageState.language);
            }

            return BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                ThemeMode themeMode = ThemeMode.system; // Default to system

                if (themeState is DarkThemeState) {
                  themeMode = ThemeMode.dark;
                } else if (themeState is LightThemeState) {
                  themeMode = ThemeMode.light;
                }

                // Save theme preference
                SharedPreferences.getInstance().then((prefs) {
                  prefs.setBool('isDarkTheme', themeMode == ThemeMode.dark);
                });

                return MaterialApp(
                  title: 'SecuPass',
                  locale: locale,
                  supportedLocales: const [
                    Locale('en'),
                    Locale('ar'),
                  ],
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.deepPurple,
                      // brightness: Brightness.light, // <-- REMOVE OR COMMENT THIS LINE
                    ),
                    useMaterial3: true,
                    // brightness: Brightness.light, // <-- REMOVE OR COMMENT THIS LINE
                  ),
                  darkTheme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.deepPurple,
                      brightness: Brightness
                          .dark, // <-- KEEP THIS ONE for dark theme color scheme consistency
                    ),
                    useMaterial3: true,
                    // brightness: Brightness.dark, // <-- REMOVE OR COMMENT THIS LINE
                  ),
                  themeMode:
                      themeMode, // Apply the theme mode from the Bloc state
                  initialRoute: '/', // Set the initial route to the root
                  routes: {
                    '/': (context) => AuthPage(),
                    // The root route is your CustomNavBar
                    'home': (context) => CustomNavBar(),
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
