/// The main landing screen of the application that displays
/// all saved accounts.
///
/// Data flow (GetAccountsCubit):
/// - On initState, the screen triggers `loadAccounts()` to fetch
///   all stored accounts.
/// - The UI reacts to cubit states:
///   - LoadingAccounts: shows a loading indicator.
///   - LoadedAccounts: displays the accounts list using `CustomListView`.
///   - NoAccounts: shows an empty-state message.
///   - ErrorAccounts: shows a localized error message.
///
/// UI behavior:
/// - Uses `AnimatedAddButton` in the AppBar to navigate to
///   the AddAccount screen.
/// - Wraps the accounts list inside a `SingleChildScrollView`
///   to support flexible layouts.
/// - Displays friendly empty states when no data is available.
///
/// Localization:
/// - All user-facing text is localized using `AppLocalizations`.
///
/// This screen acts as the entry point for managing accounts
/// and provides quick access to adding new ones.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secupass/core/widgets/add_button.dart';
import 'package:secupass/core/widgets/listview.dart';
import 'package:secupass/features/add_account_screen.dart/presentation/screens/add_account.dart';
import 'package:secupass/features/home_screen/presentation/cubit/get_accounts_cubit.dart';
import 'package:secupass/features/home_screen/presentation/cubit/get_accounts_state.dart';
import 'package:secupass/l10n/app_localizations.dart'; // Import localization package

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<GetAccountsCubit>().loadAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final language =
        AppLocalizations.of(context)!; // Get the localization instance

    return Scaffold(
      appBar: AppBar(
        title: Text(language.app_title), // Use localized app title
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(15), // Use const if it's fixed
            child: AnimatedAddButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddAccount(), // <-- Navigate to AddAccount screen
                ),
              );
            }),
          )
        ],
      ),
      body: BlocBuilder<GetAccountsCubit, GetAccountsState>(
        builder: (context, state) {
          if (state is LoadingAccounts) {
            return Center(
                child:
                    CircularProgressIndicator()); // Removed const as it's not a const widget.
          } else if (state is LoadedAccounts) {
            if (state.accounts.isEmpty) {
              return Center(
                  child: Text(language.no_accounts_found)); // Localized message
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: CustomListView(accounts: state.accounts),
            );
          } else if (state is ErrorAccounts) {
            return Center(
                child: Text(language
                    .error_loading_accounts)); // Localized error message
          } else if (state is NoAccounts) {
            return Center(child: Text(language.no_accounts_found));
          }
          // Fallback for any unhandled state, ensuring a localized message
          return Center(child: Text(language.no_accounts_found));
        },
      ),
    );
  }
}
