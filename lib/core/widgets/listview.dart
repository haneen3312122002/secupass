import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Should import PersistentNavBarNavigator from this package
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:secupass/features/account_detailes/presentation/screens/account_detailes.dart';
import 'package:secupass/features/home_screen/domain/entities/account_entity.dart'; // Ensure AccountEntitiy is imported
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:secupass/image_fitch/bloc/photo_bloc.dart';
import 'package:secupass/image_fitch/bloc/photo_state.dart';
import 'package:secupass/image_fitch/screen/photo_screen.dart';
import 'package:secupass/l10n/app_localizations.dart'; // Import localization package

class CustomListView extends StatelessWidget {
  // It's better to specify the list type more precisely, like List<AccountEntitiy>
  final List<dynamic> accounts;

  const CustomListView({super.key, required this.accounts});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final language = AppLocalizations.of(context)!; // Get localization instance

    return ListView.builder(
      // Since this ListView will be inside SingleChildScrollView in HomePage,
      // shrinkWrap and NeverScrollableScrollPhysics are important to prevent scroll conflicts.
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: accounts.length,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemBuilder: (context, index) {
        final account = accounts[index]
            as AccountEntitiy; // Ensure type casting to AccountEntitiy

        // Format last update date
        String formattedLastUpdate =
            language.unknown_date; // Localized "Unknown"
        if (account.lastUpdate != null) {
          formattedLastUpdate = DateFormat('yyyy/MM/dd HH:mm')
              .format(account.lastUpdate!); // Use null-safe access
        }

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          shadowColor: Colors.deepPurple.withOpacity(0.2),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 8 : 10,
            ),
            leading: CircleAvatar(
                radius: isSmallScreen ? 22 : 26,
                backgroundColor: Colors.deepPurple.shade700,
                child: BlocBuilder<PhotoBloc, PhotoState>(
                    builder: (context, state) {
                  if (state is PhotoLoadedState) {
                    return LogoAvatar(
                      imageUrl: account.photoPath,
                      isIcon: false,
                    );
                  } else if (state is PhotoErrorState) {
                    return LogoAvatar(
                      isIcon: true,
                      icon: Icon(Icons.error_outline, color: Colors.red),
                    );
                  }
                  return Icon(Icons.app_blocking);
                })),
            title: Text(
              account.appName ??
                  language.unknown_app_name, // Localized "Unknown app name"
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple.shade800,
              ),
            ),
            subtitle: Text(
              '${language.last_update}: $formattedLastUpdate', // Localized "Last update:"
              style: TextStyle(
                fontSize: isSmallScreen ? 11 : 13,
                color: Colors.grey[600],
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.deepPurple.shade300,
              size: isSmallScreen ? 14 : 18,
            ),
            onTap: () {
              // Main modification here
              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                context,
                settings: const RouteSettings(
                    name: '/account_details'), // Can use a route name
                screen:
                    AccountDetailes(accountId: account.id!), // Pass account ID
                withNavBar:
                    false, // Hide bottom navigation bar on details screen
                pageTransitionAnimation: PageTransitionAnimation
                    .cupertino, // Elegant transition effect
              );
            },
          ),
        );
      },
    );
  }
}
