/// AccountDetailsView
///
/// This screen is responsible for displaying the full details of a saved account
///  the functions:
/// - Display the app name + username.
/// - Decrypt the stored encrypted password once when the screen is initialized.
/// - Allow the user to toggle password visibility (show / hide).
/// - Handle decryption errors gracefully by showing an error message if needed.
/// - Show data: such as last update date and automatically calculated next update date.
///
/// Security considerations:
/// - The password is stored encrypted and only decrypted locally for display.
/// - Password visibility is disabled by default and requires explicit user action.

import 'package:flutter/material.dart';
import 'package:secupass/encrypt_helper.dart'; // Import your encryption helper
import 'package:secupass/features/home_screen/domain/entities/account_entity.dart';
import 'package:secupass/l10n/app_localizations.dart';

class AccountDetailsView extends StatefulWidget {
  final AccountEntitiy account;

  const AccountDetailsView({super.key, required this.account});

  @override
  _AccountDetailsViewState createState() => _AccountDetailsViewState();
}

class _AccountDetailsViewState extends State<AccountDetailsView> {
  String _decryptedPassword = '';
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Decrypt the password in initState and store it
    _decryptedPassword = EncryptionHelper.decrypt(widget.account.encPass);
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Name
          _buildDetailRow(
            context,
            label: language.app_name,
            value: widget.account.appName,
            icon: Icons.apps,
          ),
          const Divider(height: 32),

          // User Name
          _buildDetailRow(
            context,
            label: language.user_name_details,
            value: widget.account.userName,
            icon: Icons.person,
          ),
          const Divider(height: 32),

          // Encrypted Password with visibility toggle and error handling
          _buildPasswordDetailRow(
            context,
            label: language.encrypted_password,
            value: _decryptedPassword,
            isVisible: _isPasswordVisible,
            onToggleVisibility: _togglePasswordVisibility,
          ),
          const Divider(height: 32),

          // Last Update
          _buildDetailRow(
            context,
            label: language.last_update,
            value: widget.account.lastUpdate
                .toIso8601String()
                .substring(0, 10), // Formatting the date
            icon: Icons.access_time,
          ),
          const Divider(height: 32),

          // Next Update
          _buildDetailRow(
            context,
            label: language.next_update,
            value: _calculateNextUpdate(widget.account),
            icon: Icons.update,
          ),
        ],
      ),
    );
  }

//function to toggle password visibility (on / off)
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

//build a row for each detail with an icon, label and value
  Widget _buildDetailRow(BuildContext context,
      {required String label, required String value, required IconData icon}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//password row with visibility toggle and error handling (if decryption fails)
  Widget _buildPasswordDetailRow(BuildContext context,
      {required String label,
      required String value,
      required bool isVisible,
      required VoidCallback onToggleVisibility}) {
    final theme = Theme.of(context);
    final bool isError = value.contains('[Error');
    final String displayText = isVisible || isError ? value : '************';
    final Color displayColor =
        isError ? theme.colorScheme.error : theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayText,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: displayColor,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            onPressed: onToggleVisibility,
          ),
        ],
      ),
    );
  }

//function to calculate the next update date based on the last update and selected days, returns 'N/A' if selected days is 0
  String _calculateNextUpdate(AccountEntitiy account) {
    if (account.selectedDays == 0) return 'N/A';
    final nextUpdate =
        account.lastUpdate.add(Duration(days: account.selectedDays));
    return nextUpdate.toIso8601String().substring(0, 10);
  }
}
