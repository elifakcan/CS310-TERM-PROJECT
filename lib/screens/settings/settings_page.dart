import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/prefs_provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<PrefsProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 DARK MODE (SharedPreferences)
            SwitchListTile(
              title: Text(
                'Dark Mode',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              value: prefs.isDarkMode,
              onChanged: (_) {
                context.read<PrefsProvider>().toggleTheme();
              },
            ),

            const SizedBox(height: 20),

            // 🔹 CHANGE PASSWORD
            ListTile(
              leading: Icon(Icons.lock, color: theme.colorScheme.onSurface),
              title: Text(
                'Change Password',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: theme.colorScheme.onSurface,
              ),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.changePassword);
              },
            ),

            const Spacer(),

            // 🔹 LOGOUT (ADIM 16)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBlue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  await context.read<AuthProvider>().logout();
                  // Navigator stack'ini tamamen temizle ve WelcomePage'e git
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.welcome,
                      (route) => false,
                    );
                  }
                },
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
