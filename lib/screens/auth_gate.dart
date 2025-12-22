import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';
import 'mainnav/main_nav_container.dart';
import 'welcome/welcome_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Logged-in kullanıcı → Main App
    if (auth.isLoggedIn) {
      return const MainNavContainer(initialIndex: 0);
    }

    // Logged-out kullanıcı → Welcome/Login
    return const WelcomePage();
  }
}
