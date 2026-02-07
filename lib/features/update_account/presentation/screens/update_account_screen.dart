/// UpdateAccount
///
/// Screen responsible for editing an existing account and saving changes.
///
/// What this screen does:
/// - Pre-fills inputs (app name, username, password) with the current account data.
/// - Decrypts the stored encrypted password only for editing purposes.
/// - Re-checks password strength while the user types (using `CheckPassBloc`).
/// - Allows changing the reminder period (days) using `GroupButton`
///   and stores the selected value in `UpdateAccountCubit`.
///
/// Password strength (CheckPassBloc):
/// - Each time the password changes, an event is dispatched:
///   `checkPassStrengthEvent(password.text)`
/// - UI reacts to the bloc state:
///   - Loading: shows progress indicator
///   - Loaded: shows a strength bar + optional warning
///   - Error: shows an error message
///
/// Reminder days selector (GroupButton):
/// - Works as a radio group (single selection).
/// - Selected value comes from `UpdateAccountState.updatedSelectedDays`.
/// - On selection, calls `changeSelectedDays(val)` to update the cubit state.
///
/// Save/update logic:
/// - The Update button is enabled only if something changed:
///   app name / username / password / selected days.
/// - Password is encrypted before saving.
/// - If password changed, `lastUpdate` is refreshed to DateTime.now()
///   otherwise it keeps the old lastUpdate.
/// - Triggers `PhotoBloc` to update the app image/logo based on app name.
/// - Updates the related notification via `NotCubit.updateNot()`.
///
/// State management (UpdateAccountCubit):
/// - UpdateAccountSaving: disables button and shows loader.
/// - UpdateAccountSaved: navigates to success StatusPage.
/// - UpdateAccountError: navigates to error StatusPage.
///
/// Localization:
/// - All visible text uses AppLocalizations.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:secupass/core/widgets/buttom_navbar.dart';
import 'package:secupass/core/widgets/textfeilds.dart';
import 'package:secupass/encrypt_helper.dart';
import 'package:secupass/features/add_account_screen.dart/presentation/screens/add_status.dart';
import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';
import 'package:secupass/features/notefications_page/presentation/cubit/not_cubit.dart';
import 'package:secupass/features/pass_check/bloc/check_pass_bloc.dart';
import 'package:secupass/features/pass_check/bloc/check_pass_event.dart';
import 'package:secupass/features/pass_check/bloc/check_pass_state.dart';
import 'package:secupass/features/update_account/presentation/cubit/account_uodate_state.dart';
import 'package:secupass/features/update_account/presentation/cubit/update_account_cubit.dart';
import 'package:secupass/image_fitch/bloc/photo_bloc.dart';
import 'package:secupass/image_fitch/bloc/photo_event.dart';
import 'package:secupass/l10n/app_localizations.dart';

class UpdateAccount extends StatefulWidget {
  const UpdateAccount(this.account, {super.key});
  final AccountEntitiy account;

  @override
  State<UpdateAccount> createState() => _UpdateAccountState();
}

class _UpdateAccountState extends State<UpdateAccount> {
  late TextEditingController appName;
  late TextEditingController password;
  late TextEditingController userName;

  @override
  void initState() {
    super.initState();
    appName = TextEditingController(text: widget.account.appName);
    userName = TextEditingController(text: widget.account.userName);
    password = TextEditingController(
      text: EncryptionHelper.decrypt(widget.account.encPass),
    );

    appName.addListener(() => setState(() {}));
    userName.addListener(() => setState(() {}));
    password.addListener(() {
      // كل ما يكتب المستخدم باسورد، أرسل حدث فحص
      context.read<CheckPassBloc>().add(checkPassStrengthEvent(password.text));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => CheckPassBloc(widget.account),
      child: Scaffold(
        appBar: AppBar(
          title: Text(language.update_account),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              MyFeilds(appName, userName, password),
              const SizedBox(height: 10),
              // عرض نتيجة فحص الباسورد
              BlocBuilder<CheckPassBloc, CheckPassState>(
                builder: (context, state) {
                  if (state is checkPassLoadingState) {
                    return const CircularProgressIndicator();
                  } else if (state is checkPassLoadedState) {
                    return Column(
                      children: [
                        LinearProgressIndicator(
                          value: state.len,
                          color: state.color,
                          minHeight: 8,
                        ),
                        if (state.warning != null) ...[
                          const SizedBox(height: 5),
                          Text(
                            state.warning!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ]
                      ],
                    );
                  } else if (state is checkPassErrorState) {
                    return Text(
                      state.error,
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 20),
              Text(
                language.num_of_days,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              BlocSelector<UpdateAccountCubit, UpdateAccountState, int>(
                selector: (state) => state.updatedSelectedDays,
                builder: (context, selectedDays) {
                  return GroupButton(
                    isRadio: true,
                    buttons: const [1, 30, 60, 90],
                    controller: GroupButtonController(
                      selectedIndex: [1, 30, 60, 90].indexOf(selectedDays),
                    ),
                    onSelected: (val, index, isSelected) {
                      context
                          .read<UpdateAccountCubit>()
                          .changeSelectedDays(val);
                    },
                    options: GroupButtonOptions(
                      spacing: 12,
                      runSpacing: 10,
                      borderRadius: BorderRadius.circular(10),
                      buttonHeight: 40,
                      buttonWidth: MediaQuery.of(context).size.width * 0.22,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      unselectedColor: Theme.of(context).colorScheme.surface,
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              BlocConsumer<UpdateAccountCubit, UpdateAccountState>(
                builder: (context, state) {
                  final originalDecryptedPass =
                      EncryptionHelper.decrypt(widget.account.encPass);

                  final bool isChanged = appName.text !=
                          widget.account.appName ||
                      userName.text != widget.account.userName ||
                      password.text != originalDecryptedPass ||
                      state.updatedSelectedDays != widget.account.selectedDays;

                  if (state is UpdateAccountSaving) {
                    return MyCustomButton(
                      const CircularProgressIndicator(color: Colors.white),
                      null,
                      double.infinity,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.7),
                    );
                  }

                  return MyCustomButton(
                    Text(language.update,
                        style: const TextStyle(color: Colors.white)),
                    isChanged
                        ? () {
                            final photoBloc = BlocProvider.of<PhotoBloc>(
                              context,
                            );
                            photoBloc.add(GetPhotoEvent(appName.text.trim()));

                            final newEncryptedPass =
                                EncryptionHelper.encrypt(password.text);

                            DateTime finalLastUpdate;
                            if (newEncryptedPass != widget.account.encPass) {
                              finalLastUpdate = DateTime.now();
                            } else {
                              finalLastUpdate = widget.account.lastUpdate;
                            }

                            AccountEntitiy accountToSave = AccountEntitiy(
                              id: widget.account.id,
                              appName: appName.text,
                              photoPath: photoBloc.state.imagePath,
                              encPass: newEncryptedPass,
                              lastUpdate: finalLastUpdate,
                              selectedDays: state.updatedSelectedDays,
                              userName: userName.text,
                            );

                            context
                                .read<UpdateAccountCubit>()
                                .updateAccount(accountToSave);
                            context.read<NotCubit>().updateNot(
                                  body:
                                      'Please change the password for ${widget.account.appName}',
                                  title: accountToSave.userName,
                                  Selecteddays: state.updatedSelectedDays,
                                  id: widget.account.id!,
                                );
                          }
                        : null,
                    double.infinity,
                    color: isChanged
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceVariant,
                  );
                },
                listener: (context, state) {
                  if (state is UpdateAccountError) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StatusPage(
                              isSuccess: false, message: state.errorMsg)),
                    );
                  }
                  if (state is UpdateAccountSaved) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StatusPage(isSuccess: true, message: state.msg)),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    appName.dispose();
    password.dispose();
    userName.dispose();
    super.dispose();
  }
}
