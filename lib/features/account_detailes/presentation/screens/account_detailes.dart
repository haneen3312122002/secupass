import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:secupass/core/widgets/account_detailes_listview.dart';
import 'package:secupass/core/widgets/buttom_navbar.dart';
import 'package:secupass/features/NavBar_page/presentation/screens/nav_bar.dart';
import 'package:secupass/features/account_detailes/presentation/cubit/account_detailes_cubit.dart';
import 'package:secupass/features/account_detailes/presentation/cubit/account_detailes_state.dart';
import 'package:secupass/features/account_detailes/presentation/cubit/delete_%20account_cubit.dart';
import 'package:secupass/features/account_detailes/presentation/cubit/delete_account_state.dart';
import 'package:secupass/features/add_account_screen.dart/presentation/screens/add_status.dart';
import 'package:secupass/features/pass_check/bloc/check_pass_bloc.dart';
import 'package:secupass/features/update_account/presentation/cubit/update_account_cubit.dart';
import 'package:secupass/features/home_screen/domain/usecases/accoun/update_usecase.dart';
import 'package:secupass/features/update_account/presentation/screens/update_account_screen.dart';
import 'package:secupass/l10n/app_localizations.dart';
import 'package:gohashlogin/gohashlogin.dart';

class AccountDetailes extends StatefulWidget {
  final int accountId;

  const AccountDetailes({super.key, required this.accountId});

  @override
  State<AccountDetailes> createState() => _AccountDetailesState();
}

class _AccountDetailesState extends State<AccountDetailes> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
          .read<AccountDetailesCubit>()
          .loadAccountDetailes(widget.accountId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double width = screenWidth * 0.4;
    final language = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(language.account_details_title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlocBuilder<AccountDetailesCubit, AccountDetailesState>(
                      builder: (context, state) {
                        if (state is AccountDetailesLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is AccountDetailesLoaded) {
                          return AccountDetailsView(
                              account: state.accountDetail);
                        } else if (state is AccountDetailesError) {
                          return Center(
                              child: Text(language.error_loading_details));
                        }
                        return Center(
                            child: Text(language.no_details_available));
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlocBuilder<AccountDetailesCubit, AccountDetailesState>(
                          builder: (context, state) {
                            if (state is AccountDetailesLoaded) {
                              final account = state.accountDetail;
                              return MyCustomButton(
                                Text(language.update,
                                    style:
                                        const TextStyle(color: Colors.white)),
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                            create: (context) =>
                                                UpdateAccountCubit(
                                              context
                                                  .read<UpdateAccountUseCase>(),
                                              account,
                                            ),
                                          ),
                                          BlocProvider(
                                            create: (context) =>
                                                CheckPassBloc(account),
                                          ),
                                        ],
                                        child: UpdateAccount(account),
                                      ),
                                    ),
                                  ).then((_) {
                                    context
                                        .read<AccountDetailesCubit>()
                                        .loadAccountDetailes(widget.accountId);
                                  });
                                },
                                width,
                                color: Colors.green,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
                          listener: (context, state) {
                            if (state is DeletedAccountState) {
                              PersistentNavBarNavigator
                                  .pushNewScreenWithRouteSettings(
                                context,
                                settings: const RouteSettings(
                                    name: '/account_status'),
                                screen: CustomNavBar(),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                              );
                            } else if (state is DeleteAccountErrorState) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StatusPage(
                                    isSuccess: false,
                                    message: state.erorrMsg,
                                  ),
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is DeletingAccountState) {
                              return MyCustomButton(
                                const CircularProgressIndicator(
                                    color: Colors.white),
                                null,
                                width,
                                color: Colors.red,
                              );
                            }
                            return MyCustomButton(
                              Text(language.delete,
                                  style: const TextStyle(color: Colors.white)),
                              () {
                                _confirmDeleteDialog(
                                    context, language, widget.accountId);
                              },
                              width,
                              color: Colors.red,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmDeleteDialog(
      BuildContext context, AppLocalizations language, int accountId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(language.delete_dialog_title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(language.delete_dialog_message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(language.cancel_button),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(language.delete),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<DeleteAccountCubit>().DeleteAccount(accountId);
              },
            ),
          ],
        );
      },
    );
  }
}
