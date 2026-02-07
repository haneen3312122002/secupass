import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:secupass/features/home_screen/data/models/nots.dart'; // تأكد أن NotModel موجود في هذا المسار
import 'package:secupass/features/home_screen/domain/entities/not_entity.dart'; // NotEntity is used for type hinting, NotModel for casting
import 'package:secupass/l10n/app_localizations.dart'; // Import localization package

class NotificationListView extends StatelessWidget {
  final List<dynamic> notifications;

  const NotificationListView({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final language = AppLocalizations.of(context)!; // Get localization instance

    return ListView.builder(
      // Since this ListView will be inside SingleChildScrollView in NotificationsPage,
      // shrinkWrap and NeverScrollableScrollPhysics are important to prevent scroll conflicts.
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemBuilder: (context, index) {
        final not =
            notifications[index] as NotModel; // Ensure type casting to NotModel

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          shadowColor: Colors.deepOrange
              .withOpacity(0.2), // Suitable shadow color for notifications
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 8 : 10,
            ),
            leading: CircleAvatar(
              radius: isSmallScreen ? 22 : 26,
              backgroundColor: Colors.deepOrange
                  .shade700, // Suitable background color for notifications
              child: Icon(
                Icons.notifications_active, // Notification icon
                color: Colors.white,
                size: isSmallScreen ? 22 : 26,
              ),
            ),
            title: Text(
              not.title, // Notification title
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: Colors.deepOrange
                    .shade800, // Suitable text color for notifications
              ),
            ),
            // Here we combine subtitle and trailing to display notification data similar to an account
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  not.body, // Notification body
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11 : 13,
                    color: Colors.grey[700],
                  ),
                ),
                // Display date similar to "Last Update" in CustomListView
                Text(
                  // Localized "Date:" prefix
                  '${language.notification_date_prefix} ${DateFormat('yyyy/MM/dd HH:mm').format(not.date)}',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : 12,
                    color: Colors.grey[600], // Suitable text color
                  ),
                ),
              ],
            ),
            trailing: Icon(
              // Using an icon instead of text for consistency
              Icons.arrow_forward_ios_rounded,
              color: Colors.deepOrange.shade300, // Suitable icon color
              size: isSmallScreen ? 14 : 18,
            ),
            onTap: () {
              // You can open a notification details screen here if desired
              // For example: Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationDetailsPage(notification: not)));
            },
          ),
        );
      },
    );
  }
}
