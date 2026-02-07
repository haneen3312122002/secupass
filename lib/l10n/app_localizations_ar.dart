// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get app_title => 'سيكيوباس';

  @override
  String get auth_welcome_message => 'مرحباً بك في سيكيوباس!';

  @override
  String get first_run_prompt => 'قم بإنشاء رمز PIN جديد لتأمين التطبيق:';

  @override
  String get pin_save_button => 'حفظ رمز PIN';

  @override
  String get pin_input_prompt => 'الرجاء إدخال رمز PIN الخاص بك:';

  @override
  String get pin_input_button => 'دخول';

  @override
  String get invalid_pin_error => 'رمز PIN غير صحيح. يرجى المحاولة مرة أخرى.';

  @override
  String get pin_validation_error => 'الرجاء إدخال رقم PIN مكون من 4 أرقام صحيحة.';

  @override
  String get pin_added_success => 'تمت إضافة رمز PIN بنجاح!';

  @override
  String get last_update => 'آخر تحديث';

  @override
  String get no_accounts_found => 'لا توجد حسابات';

  @override
  String get app_name => 'اسم التطبيق';

  @override
  String get app_name_hint => 'مثال: فيسبوك، جوجل';

  @override
  String get user_name => 'اسم المستخدم أو البريد الإلكتروني';

  @override
  String get user_name_hint => 'أدخل اسم المستخدم أو البريد الإلكتروني';

  @override
  String get user_name_details => 'اسم المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get password_hint => 'أدخل كلمة المرور';

  @override
  String get encrypted_password => 'كلمة المرور (مشفرة)';

  @override
  String get num_of_days => 'تذكيري بتغيير كلمة المرور بعد:';

  @override
  String get add_account => 'إضافة حساب';

  @override
  String get next_update => 'موعد التحديث القادم';

  @override
  String get update => 'تحديث';

  @override
  String get delete => 'حذف';

  @override
  String get update_account => 'تحديث الحساب';

  @override
  String get not_body => 'يرجى تغيير كلمة المرور لتطبيق:';

  @override
  String get home => 'الرئيسية';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get language_arabic => 'العربية';

  @override
  String get language_english => 'الإنجليزية';

  @override
  String get dark_mode => 'الوضع الليلي';

  @override
  String get notifications_title => 'الإشعارات';

  @override
  String get permission_denied_message => 'تم رفض إذن الإشعارات أو المنبه الدقيق. يرجى تمكينها من الإعدادات لاستلام التذكيرات.';

  @override
  String get open_settings => 'فتح الإعدادات';

  @override
  String get generic_error_message => 'حدث خطأ. يرجى المحاولة مرة أخرى.';

  @override
  String get no_notifications_found => 'لا توجد اشعارات بعد.';

  @override
  String get loading_notifications => 'جارٍ تحميل الإشعارات...';

  @override
  String get notification_load_error => 'فشل تحميل الإشعارات. يرجى المحاولة لاحقاً.';

  @override
  String get error_loading_accounts => 'فشل تحميل الحسابات. يرجى المحاولة مرة أخرى.';

  @override
  String get add_account_title => 'إضافة حساب جديد';

  @override
  String get add_account_button => 'إضافة حساب';

  @override
  String notification_body_template(Object appName) {
    return 'يرجى تغيير كلمة المرور لتطبيق: $appName';
  }

  @override
  String get status_success_title => 'تمت العملية بنجاح!';

  @override
  String get status_error_title => 'خطأ!';

  @override
  String get return_to_home_button => 'العودة إلى الرئيسية';

  @override
  String get account_details_title => 'تفاصيل الحساب';

  @override
  String get error_loading_details => 'فشل تحميل تفاصيل الحساب.';

  @override
  String get no_details_available => 'لا توجد تفاصيل متاحة بعد.';

  @override
  String get delete_dialog_title => 'تأكيد الحذف';

  @override
  String get delete_dialog_message => 'هل أنت متأكد أنك تريد حذف هذا الحساب؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get cancel_button => 'إلغاء';

  @override
  String get notification_date_prefix => 'التاريخ:';

  @override
  String get unknown_date => 'تاريخ غير معروف';

  @override
  String get unknown_app_name => 'تطبيق غير معروف';

  @override
  String get not_available => 'غير متوفر';
}
