import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    // Renkleri dark mode’a göre ayarla
    final Color bgColor = isDarkMode ? Colors.black : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        title: Text(
          'Settings',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DARK MODE SWITCH
            SwitchListTile(
              title: Text('Dark Mode', style: TextStyle(color: textColor)),
              value: isDarkMode,
              onChanged: (value) {
                setState(() => isDarkMode = value);
              },
            ),

            // NOTIFICATIONS SWITCH
            SwitchListTile(
              title:
                  Text('Notifications', style: TextStyle(color: textColor)),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() => notificationsEnabled = value);
              },
            ),

            const SizedBox(height: 20),

            // CHANGE PASSWORD BUTTON
            ListTile(
              leading: Icon(Icons.lock, color: textColor),
              title: Text('Change Password',
                  style: TextStyle(color: textColor)),
              trailing:
                  Icon(Icons.arrow_forward_ios, color: textColor),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.changePassword);
              },
            ),

            const Spacer(),

            // LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBlue,
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.welcome,
                    (route) => false,
                  );
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
