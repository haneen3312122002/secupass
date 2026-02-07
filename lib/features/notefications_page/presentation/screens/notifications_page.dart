import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secupass/core/widgets/nots_listview.dart'; // Ensure this widget exists
import 'package:secupass/features/notefications_page/presentation/cubit/not_cubit.dart';
import 'package:secupass/features/notefications_page/presentation/cubit/not_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:secupass/l10n/app_localizations.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    // Request notification permissions when the page initializes.
    // This proactively asks for permission before trying to load notifications.
    _requestPermissions();
    // Load notifications after permissions are handled.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotCubit>().loadNots();
    });
  }

  Future<void> _requestPermissions() async {
    // Request general notification permission
    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }

    // On Android, specifically request exact alarm permission for scheduling.
    // This is crucial for precise, timely notifications.
    if (Theme.of(context).platform == TargetPlatform.android) {
      status = await Permission.scheduleExactAlarm.status;
      if (status.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(language.notifications_title), // Use localized title
        centerTitle: true,
      ),
      body: BlocConsumer<NotCubit, NotState>(
        listener: (context, state) {
          if (state is NotError) {
            // Check for specific exact alarm permission error message
            if (state.message.contains('Exact alarm permission denied') ||
                state.message.contains('Notification permission denied')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      language.permission_denied_message), // Localized message
                  action: SnackBarAction(
                    label: language.open_settings, // Localized button
                    onPressed: () {
                      openAppSettings(); // Opens app settings directly
                    },
                  ),
                  duration: const Duration(seconds: 8),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(language
                      .generic_error_message), // Localized generic error
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          }
        },
        builder: (context, state) {
          if (state is NotLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotLoaded) {
            if (state.nots.isEmpty) {
              return Center(
                  child: Text(
                      language.no_notifications_found)); // Localized message
            }
            return NotificationListView(notifications: state.nots);
          } else if (state is NotError) {
            // Display a user-friendly error message, as detailed one is in SnackBar
            return Center(child: Text(language.notification_load_error));
          }
          // Fallback to a message indicating no notifications, or a general state.
          return Center(child: Text(language.no_notifications_found));
        },
      ),
    );
  }
}
