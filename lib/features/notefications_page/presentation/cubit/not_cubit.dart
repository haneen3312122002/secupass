import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:secupass/features/home_screen/data/models/nots.dart';
import 'package:secupass/features/home_screen/domain/usecases/nots/add_not.dart';
import 'package:secupass/features/home_screen/domain/usecases/nots/get_nots.dart';
import 'package:secupass/features/home_screen/domain/usecases/nots/update_nots.dart';
import 'package:secupass/features/notefications_page/presentation/cubit/not_state.dart';
import 'package:timezone/data/latest.dart' as tzData;
import 'package:timezone/timezone.dart' as tz;

class NotCubit extends Cubit<NotState> {
  final FlutterLocalNotificationsPlugin plugin;
  final AddNotUseCase add;
  final GetNotsUseCase get;
  final UpdateNotsUseCase update;

  NotCubit(this.plugin,
      {required this.add, required this.get, required this.update})
      : super(NotInitial(msg: 'no notifications')) {
    tzData.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Amman'));
  }
// Method to schedule a notification with proper permission handling
  Future<void> _scheduleNotification({
    required int? id,
    required String title,
    required String body,
    required DateTime date,
  }) async {
    const androidDetailes = AndroidNotificationDetails(
      'reminder_channel_id',
      'reminders',
      channelDescription: 'Channel for important reminders',
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'New Reminder!',
    );
    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetailes);

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    bool exactAlarmGranted =
        await androidImplementation?.canScheduleExactNotifications() ?? false;

    if (exactAlarmGranted) {
      await plugin.zonedSchedule(
        id!,
        title,
        body,
        tz.TZDateTime.from(date, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      print('<<<<<<<<<<<<<<<<<<<<NOT ADDED - Exact alarm scheduled (ID: $id)');
    } else {
      final bool? requested =
          await androidImplementation?.requestExactAlarmsPermission();
      if (requested == true) {
        await plugin.zonedSchedule(
          id!,
          title,
          body,
          tz.TZDateTime.from(date, tz.local),
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
        print(
            '<<<<<<<<<<<<<<<<<<<<NOT ADDED - Exact alarm scheduled after request (ID: $id)');
      } else {
        print('User denied exact alarm permission.');
        emit(NotError(
            'Exact alarm permission denied. Notification might not be precise. '
            'Please enable "Alarms & reminders" permission in app settings '
            'to ensure notifications are delivered on time.'));

        await plugin.zonedSchedule(
          id!,
          title,
          body,
          tz.TZDateTime.from(date, tz.local),
          notificationDetails,
          androidScheduleMode:
              AndroidScheduleMode.inexactAllowWhileIdle, // Fallback
        );
        print(
            '<<<<<<<<<<<<<<<<<<<<NOT ADDED - Inexact alarm scheduled as fallback (ID: $id)');
      }
    }
  }

  void addNot({
    required int? id,
    required String title,
    required String body,
    required int Selecteddays,
  }) async {
    try {
      final DateTime scheduledDate;
      if (Selecteddays == 1) {
        scheduledDate = DateTime.now().add(const Duration(minutes: 1));
        print('one minute');
      } else {
        scheduledDate = DateTime.now().add(Duration(days: Selecteddays));
      }

      await add.call(id, title, body,
          scheduledDate); // تأكد أن add.call لا تحتاج لـ ID هنا

      await _scheduleNotification(
        id: id, // استخدم ID فريد هنا
        title: title,
        body: body,
        date: scheduledDate,
      );

      await loadNots(); // إعادة تحميل القائمة بعد الإضافة والجدولة
    } catch (e) {
      print('Error adding notification: $e');
      emit(NotError(e.toString()));
    }
  }

  Future<List<dynamic>> loadNots() async {
    emit(NotLoading());

    try {
      final List<dynamic> allNots = await get.call();

      final DateTime now = DateTime.now();
      final List<dynamic> pastOrCurrentNots = allNots.where((not) {
        if (not is NotModel) {
          return not.date.isBefore(now) || not.date.isAtSameMomentAs(now);
        }
        return false;
      }).toList();

      if (pastOrCurrentNots.isEmpty) {
        emit(NotInitial(msg: 'no notifications'));
      } else {
        emit(NotLoaded(pastOrCurrentNots));
      }
      return pastOrCurrentNots;
    } catch (e) {
      print('Error loading notifications: $e');
      emit(NotError(e.toString()));
      return [];
    }
  }

  void updateNot({
    required int id, // ID الإشعار المراد تحديثه
    required String title,
    required String body,
    required int Selecteddays,
  }) async {
    try {
      if (id == null) {
        emit(NotError('Cannot update notification: ID is missing.'));
        return;
      }

      final DateTime updatedScheduledDate;
      if (Selecteddays == 1) {
        updatedScheduledDate = DateTime.now().add(const Duration(minutes: 1));
        print('one minute');
      } else {
        updatedScheduledDate = DateTime.now().add(Duration(days: Selecteddays));
      }

      // 1. تحديث الإشعار في قاعدة البيانات
      await update.call(
          id: id, date: updatedScheduledDate, title: title, body: body);

      // 2. إلغاء الإشعار القديم (مهم لتجنب تكرار الإشعارات)
      await plugin.cancel(id); // إلغاء الإشعار باستخدام الـ ID الخاص به

      // 3. جدولة الإشعار الجديد باستخدام الدالة المنفصلة
      await _scheduleNotification(
        id: id, // استخدم نفس الـ ID لتحديثه أو ID جديد إذا أردت إشعارًا منفصلاً
        title: title,
        body: body,
        date: updatedScheduledDate,
      );

      await loadNots(); // إعادة تحميل القائمة بعد التحديث والجدولة
    } catch (e) {
      emit(NotError(e.toString()));
    }
  }

  // إذا كنت تريد حذف إشعارات، قد تحتاج لـ clear notifications
  Future<void> clearAllNotifications() async {
    await plugin.cancelAll();
  }
}
