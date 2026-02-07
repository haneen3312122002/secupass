import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Secupass'**
  String get app_title;

  /// No description provided for @auth_welcome_message.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SecuPass!'**
  String get auth_welcome_message;

  /// No description provided for @first_run_prompt.
  ///
  /// In en, this message translates to:
  /// **'Create a new PIN to secure the app:'**
  String get first_run_prompt;

  /// No description provided for @pin_save_button.
  ///
  /// In en, this message translates to:
  /// **'Save PIN'**
  String get pin_save_button;

  /// No description provided for @pin_input_prompt.
  ///
  /// In en, this message translates to:
  /// **'Please enter your PIN:'**
  String get pin_input_prompt;

  /// No description provided for @pin_input_button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get pin_input_button;

  /// No description provided for @invalid_pin_error.
  ///
  /// In en, this message translates to:
  /// **'Invalid PIN. Please try again.'**
  String get invalid_pin_error;

  /// No description provided for @pin_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 4-digit PIN.'**
  String get pin_validation_error;

  /// No description provided for @pin_added_success.
  ///
  /// In en, this message translates to:
  /// **'PIN added successfully!'**
  String get pin_added_success;

  /// No description provided for @last_update.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get last_update;

  /// No description provided for @no_accounts_found.
  ///
  /// In en, this message translates to:
  /// **'No accounts found.'**
  String get no_accounts_found;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'App Name'**
  String get app_name;

  /// No description provided for @app_name_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Facebook, Google'**
  String get app_name_hint;

  /// No description provided for @user_name.
  ///
  /// In en, this message translates to:
  /// **'Username or Email'**
  String get user_name;

  /// No description provided for @user_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your username or email'**
  String get user_name_hint;

  /// No description provided for @user_name_details.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get user_name_details;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get password_hint;

  /// No description provided for @encrypted_password.
  ///
  /// In en, this message translates to:
  /// **'Password (Encrypted)'**
  String get encrypted_password;

  /// No description provided for @num_of_days.
  ///
  /// In en, this message translates to:
  /// **'Remind me to change the password after:'**
  String get num_of_days;

  /// No description provided for @add_account.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get add_account;

  /// No description provided for @next_update.
  ///
  /// In en, this message translates to:
  /// **'Next Update Due'**
  String get next_update;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @update_account.
  ///
  /// In en, this message translates to:
  /// **'Update Account'**
  String get update_account;

  /// No description provided for @not_body.
  ///
  /// In en, this message translates to:
  /// **'Change your password for:'**
  String get not_body;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @language_arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get language_arabic;

  /// No description provided for @language_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language_english;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @notifications_title.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications_title;

  /// No description provided for @permission_denied_message.
  ///
  /// In en, this message translates to:
  /// **'Notification or exact alarm permission denied. Please enable them in settings to receive reminders.'**
  String get permission_denied_message;

  /// No description provided for @open_settings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get open_settings;

  /// No description provided for @generic_error_message.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get generic_error_message;

  /// No description provided for @no_notifications_found.
  ///
  /// In en, this message translates to:
  /// **'No notifications found.'**
  String get no_notifications_found;

  /// No description provided for @loading_notifications.
  ///
  /// In en, this message translates to:
  /// **'Loading notifications...'**
  String get loading_notifications;

  /// No description provided for @notification_load_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications. Please try again later.'**
  String get notification_load_error;

  /// No description provided for @error_loading_accounts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load accounts. Please try again.'**
  String get error_loading_accounts;

  /// No description provided for @add_account_title.
  ///
  /// In en, this message translates to:
  /// **'Add New Account'**
  String get add_account_title;

  /// No description provided for @add_account_button.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get add_account_button;

  /// No description provided for @notification_body_template.
  ///
  /// In en, this message translates to:
  /// **'Change your password for: {appName}'**
  String notification_body_template(Object appName);

  /// No description provided for @status_success_title.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get status_success_title;

  /// No description provided for @status_error_title.
  ///
  /// In en, this message translates to:
  /// **'Error!'**
  String get status_error_title;

  /// No description provided for @return_to_home_button.
  ///
  /// In en, this message translates to:
  /// **'Return to Home'**
  String get return_to_home_button;

  /// No description provided for @account_details_title.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get account_details_title;

  /// No description provided for @error_loading_details.
  ///
  /// In en, this message translates to:
  /// **'Failed to load account details.'**
  String get error_loading_details;

  /// No description provided for @no_details_available.
  ///
  /// In en, this message translates to:
  /// **'No details available yet.'**
  String get no_details_available;

  /// No description provided for @delete_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get delete_dialog_title;

  /// No description provided for @delete_dialog_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this account? This action cannot be undone.'**
  String get delete_dialog_message;

  /// No description provided for @cancel_button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel_button;

  /// No description provided for @notification_date_prefix.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get notification_date_prefix;

  /// No description provided for @unknown_date.
  ///
  /// In en, this message translates to:
  /// **'Unknown Date'**
  String get unknown_date;

  /// No description provided for @unknown_app_name.
  ///
  /// In en, this message translates to:
  /// **'Unknown App'**
  String get unknown_app_name;

  /// No description provided for @not_available.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get not_available;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
