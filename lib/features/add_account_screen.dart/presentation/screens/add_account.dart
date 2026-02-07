/// A screen responsible for creating and saving a new account securely.
///
/// Features:
/// - Collects app name, username/email, and password using reusable input fields.
/// - Integrates `CheckPassBloc` to evaluate password strength in real time.
/// - Allows the user to select a reminder period (30 / 60 / 90 days) using GroupButton.
/// - Encrypts the password before saving it locally.
/// - Fetches an app logo/image automatically before finalizing the account creation.
///
/// Add flow (step-by-step):
/// 1. User fills in all required fields (app name, username, password).
/// 2. Password strength is checked using `CheckPassBloc`.
/// 3. User selects reminder days via GroupButton.
/// 4. Account data is temporarily stored in `pendingAccount` without an image.
/// 5. `PhotoBloc` is triggered to fetch the app image.
/// 6. Once the image is loaded:
///    - The account is saved using `AddAccountsCubit`.
///    - A notification is scheduled using `NotCubit`.
///
/// State management:
/// - AddAccountsCubit:
///   - AddingState: shows loading indicator and disables the button.
///   - AddedState: navigates back to the main navigation screen.
///   - ErrorState: navigates to a status screen with an error message.
///
/// Architecture notes:
/// - Follows Clean Architecture principles.
/// - UI handles input and rendering only.
/// - Business logic (add, encrypt, notify) is handled by Cubits and helpers.
///
/// All user-facing text is fully localized.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:secupass/core/widgets/buttom_navbar.dart';
import 'package:secupass/core/widgets/grouped_button.dart';
import 'package:secupass/core/widgets/textfeilds.dart'; // MyFeilds is here
import 'package:secupass/encrypt_helper.dart';
import 'package:secupass/features/NavBar_page/presentation/screens/nav_bar.dart';
import 'package:secupass/features/add_account_screen.dart/presentation/cubit/add_accounts_cubit.dart';
import 'package:secupass/features/add_account_screen.dart/presentation/cubit/add_accounts_state.dart';
import 'package:secupass/features/add_account_screen.dart/presentation/screens/add_status.dart';
import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';
import 'package:secupass/features/notefications_page/presentation/cubit/not_cubit.dart';
import 'package:secupass/image_fitch/bloc/photo_bloc.dart';
import 'package:secupass/image_fitch/bloc/photo_event.dart';
import 'package:secupass/image_fitch/bloc/photo_state.dart';
import 'package:secupass/l10n/app_localizations.dart';

// Import the CheckPassBloc and its dependencies
import 'package:secupass/features/pass_check/bloc/check_pass_bloc.dart';

class AddAccount extends StatefulWidget {
  const AddAccount({super.key});

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  // Controllers
  final TextEditingController appName = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController userName = TextEditingController();
// Temporary variable to hold the account data before adding the photo
  AccountEntitiy? pendingAccount;

  @override
  void initState() {
    super.initState();
    appName.addListener(() => setState(() {}));
    userName.addListener(() => setState(() {}));
    password.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(language.add_account_title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            // Bloc لشيك الباسورد
            BlocProvider(
              create: (_) => CheckPassBloc(AccountEntitiy(
                appName: appName.text,
                photoPath: '',
                userName: userName.text,
                encPass: '',
                selectedDays: 0,
                lastUpdate: DateTime.now(),
              )),
              child: MyFeilds(appName, userName, password),
            ),
            const SizedBox(height: 20),

            Text(
              language.num_of_days,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            BlocSelector<AddAccountsCubit, AddAccountsState, int>(
              selector: (state) => state.selectedDays,
              builder: (context, selectedDays) {
                return GroupButton(
                  isRadio: true,
                  buttons: const [30, 60, 90],
                  controller: GroupButtonController(
                    selectedIndex: [30, 60, 90].indexOf(selectedDays),
                  ),
                  onSelected: (val, index, isSelected) {
                    context.read<AddAccountsCubit>().setSelectedDays(val);
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

            // نلف BlocConsumer بـ BlocListener للـ PhotoBloc
            BlocListener<PhotoBloc, PhotoState>(
              listener: (context, photoState) {
                if (photoState is PhotoLoadedState && pendingAccount != null) {
                  final accountToAdd = pendingAccount!.copyWith(
                    photoPath: photoState.imagePath,
                  );

                  context.read<AddAccountsCubit>().addAccount(accountToAdd);

                  context.read<NotCubit>().addNot(
                        id: accountToAdd.id,
                        title: accountToAdd.userName,
                        body: accountToAdd.appName,
                        Selecteddays: accountToAdd.selectedDays,
                      );

                  pendingAccount = null; // مسح بعد الإضافة
                }
              },
              child: BlocConsumer<AddAccountsCubit, AddAccountsState>(
                builder: (context, state) {
                  final bool isFormValid = userName.text.isNotEmpty &&
                      appName.text.isNotEmpty &&
                      password.text.isNotEmpty;

                  if (state is AddingState) {
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
                    Text(
                      language.add_account_button,
                      style: const TextStyle(color: Colors.white),
                    ),
                    isFormValid
                        ? () {
                            final selectedDays = context
                                .read<AddAccountsCubit>()
                                .state
                                .selectedDays;
                            final lastUpdate = DateTime.now();

                            // تخزين الحساب مؤقتًا بدون صورة
                            pendingAccount = AccountEntitiy(
                              appName: appName.text.toString(),
                              photoPath: '',
                              encPass: EncryptionHelper.encrypt(password.text),
                              userName: userName.text.trim(),
                              selectedDays: selectedDays,
                              lastUpdate: lastUpdate,
                            );

                            // طلب الصورة
                            BlocProvider.of<PhotoBloc>(context).add(
                              GetPhotoEvent(appName.text.toString()),
                            );
                          }
                        : null,
                    double.infinity,
                    color: isFormValid
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceVariant,
                  );
                },
                listener: (context, state) {
                  if (state is ErrorSatate) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => StatusPage(
                          isSuccess: false,
                          message: state.errorMsg,
                        ),
                      ),
                      (route) => false,
                    );
                  }
                  if (state is AddedState) {
                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      context,
                      settings: const RouteSettings(name: '/account_status'),
                      screen: CustomNavBar(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  }
                },
              ),
            ),
          ],
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
