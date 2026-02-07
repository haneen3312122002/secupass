import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secupass/core/widgets/add_button.dart';
import 'package:secupass/core/widgets/listview.dart';
import 'package:secupass/features/add_account_screen.dart/presentation/screens/add_account.dart';
import 'package:secupass/features/home_screen/presentation/cubit/get_accounts_cubit.dart';
import 'package:secupass/features/home_screen/presentation/cubit/get_accounts_state.dart';
import 'package:secupass/image_fitch/bloc/photo_bloc.dart';
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
            // Assuming state.msg is already a localized message provided by the cubit,
            // or you want to display it as is if it's dynamic from the backend.
            // If it's a fixed phrase like "No accounts yet", then `language.no_accounts_found` is better.
            // For robustness, if `state.msg` is not guaranteed to be localized,
            // you might want to map specific `state.msg` values to localized keys.
            // For now, I'll use `no_accounts_found` as a general empty state message.
            // If `state.msg` is truly dynamic, keep it. But for a "no accounts" scenario,
            // a pre-defined localized message is usually best.
            return Center(child: Text(language.no_accounts_found));
          }
          // Fallback for any unhandled state, ensuring a localized message
          return Center(child: Text(language.no_accounts_found));
        },
      ),
    );
  }
}
