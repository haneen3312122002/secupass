///
/// A reusable list widget that displays saved accounts in a clean card-based UI.
/// functions:
/// - Renders a  ListView
/// - Shows each account as a Card + ListTile with:
///   - App name
///   - Last update date (formatted with Intl)
///   - A leading avatar/logo loaded using `PhotoBloc`
/// - Adapts spacing/font sizes for small screens to avoid overflow.
///
/// Navigation:
/// - On tap, navigates to the account details screen using
///   `PersistentNavBarNavigator.pushNewScreenWithRouteSettings`,
///   and hides the bottom navigation bar for a full-screen details view.
///
/// Localization:
/// - Uses AppLocalizations to display translated fallback texts like
///   "Unknown app name" and "Unknown date".

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:secupass/features/account_detailes/presentation/screens/account_detailes.dart';
import 'package:secupass/features/home_screen/domain/entities/account_entity.dart'; // Ensure AccountEntitiy is imported
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:secupass/image_fitch/bloc/photo_bloc.dart';
import 'package:secupass/image_fitch/bloc/photo_state.dart';
import 'package:secupass/image_fitch/screen/photo_screen.dart';
import 'package:secupass/l10n/app_localizations.dart'; // Import localization package

class CustomListView extends StatelessWidget {
  final List<dynamic> accounts;

  const CustomListView({super.key, required this.accounts});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final language = AppLocalizations.of(context)!; // Get localization instance

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Disable scrolling
      itemCount: accounts.length, //all accounts in the list
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
