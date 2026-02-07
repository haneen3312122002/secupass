// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'Secupass';

  @override
  String get auth_welcome_message => 'Welcome to SecuPass!';

  @override
  String get first_run_prompt => 'Create a new PIN to secure the app:';

  @override
  String get pin_save_button => 'Save PIN';

  @override
  String get pin_input_prompt => 'Please enter your PIN:';

  @override
  String get pin_input_button => 'Login';

  @override
  String get invalid_pin_error => 'Invalid PIN. Please try again.';

  @override
  String get pin_validation_error => 'Please enter a valid 4-digit PIN.';

  @override
  String get pin_added_success => 'PIN added successfully!';

  @override
  String get last_update => 'Last Updated';

  @override
  String get no_accounts_found => 'No accounts found.';

  @override
  String get app_name => 'App Name';

  @override
  String get app_name_hint => 'e.g., Facebook, Google';

  @override
  String get user_name => 'Username or Email';

  @override
  String get user_name_hint => 'Enter your username or email';

  @override
  String get user_name_details => 'Username';

  @override
  String get password => 'Password';

  @override
  String get password_hint => 'Enter your password';

  @override
  String get encrypted_password => 'Password (Encrypted)';

  @override
  String get num_of_days => 'Remind me to change the password after:';

  @override
  String get add_account => 'Add Account';

  @override
  String get next_update => 'Next Update Due';

  @override
  String get update => 'Update';

  @override
  String get delete => 'Delete';

  @override
  String get update_account => 'Update Account';

  @override
  String get not_body => 'Change your password for:';

  @override
  String get home => 'Home';

  @override
  String get notifications => 'Notifications';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get language_arabic => 'Arabic';

  @override
  String get language_english => 'English';

  @override
  String get dark_mode => 'Dark Mode';

  @override
  String get notifications_title => 'Notifications';

  @override
  String get permission_denied_message => 'Notification or exact alarm permission denied. Please enable them in settings to receive reminders.';

  @override
  String get open_settings => 'Open Settings';

  @override
  String get generic_error_message => 'An error occurred. Please try again.';

  @override
  String get no_notifications_found => 'No notifications found.';

  @override
  String get loading_notifications => 'Loading notifications...';

  @override
  String get notification_load_error => 'Failed to load notifications. Please try again later.';

  @override
  String get error_loading_accounts => 'Failed to load accounts. Please try again.';

  @override
  String get add_account_title => 'Add New Account';

  @override
  String get add_account_button => 'Add Account';

  @override
  String notification_body_template(Object appName) {
    return 'Change your password for: $appName';
  }

  @override
  String get status_success_title => 'Success!';

  @override
  String get status_error_title => 'Error!';

  @override
  String get return_to_home_button => 'Return to Home';

  @override
  String get account_details_title => 'Account Details';

  @override
  String get error_loading_details => 'Failed to load account details.';

  @override
  String get no_details_available => 'No details available yet.';

  @override
  String get delete_dialog_title => 'Confirm Deletion';

  @override
  String get delete_dialog_message => 'Are you sure you want to delete this account? This action cannot be undone.';

  @override
  String get cancel_button => 'Cancel';

  @override
  String get notification_date_prefix => 'Date:';

  @override
  String get unknown_date => 'Unknown Date';

  @override
  String get unknown_app_name => 'Unknown App';

  @override
  String get not_available => 'N/A';
}
