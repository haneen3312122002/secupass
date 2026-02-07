import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:secupass/features/NavBar_page/presentation/cubit/nav_cubit.dart';
import 'package:secupass/features/NavBar_page/presentation/cubit/nav_state.dart';
import 'package:secupass/features/home_screen/presentation/screen/home_screen.dart';
import 'package:secupass/features/notefications_page/presentation/screens/notifications_page.dart';
import 'package:secupass/features/settings_page/presentation/screens/settings_page.dart';
import 'package:secupass/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  final List<Widget> _screens = [
    const HomePage(),
    const NotificationsPage(),
    const SettingsPage(),
  ];

  late List<PersistentBottomNavBarItem> _items;
  // Make the theme preference a state variable to trigger rebuilds
  bool? _isDarkTheme;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  //  Method to load the theme preference
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();

    // Get the system brightness
    final Brightness platformBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final bool isSystemDark = platformBrightness == Brightness.dark;

    // Get the user's saved preference, defaulting to the system theme
    // if no preference is found.
    final bool? savedTheme = prefs.getBool('isDarkTheme');

    // Update the state with the determined theme preference
    if (mounted) {
      setState(() {
        _isDarkTheme = savedTheme ?? isSystemDark;
      });
    }
  }

  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: language.home,
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.notification_important),
        title: language.notifications,
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings),
        title: language.settings,
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // If the theme preference is still loading, show a placeholder.
    if (_isDarkTheme == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Now that the theme preference is loaded, proceed with building the UI.
    _items = _navBarsItems(context);

    return BlocBuilder<NavBarCubit, NavBarState>(
      builder: (context, state) {
        final controller = PersistentTabController(initialIndex: state.index);
        return PersistentTabView(
          context,
          controller: controller,
          screens: _screens,
          items: _items,
          onItemSelected: (index) {
            context.read<NavBarCubit>().updateIndex(index);
          },
          navBarStyle: NavBarStyle.style9,
          // ✅ Use the state variable _isDarkTheme for the background color
          backgroundColor: Colors.blue,
        );
      },
    );
  }
}
