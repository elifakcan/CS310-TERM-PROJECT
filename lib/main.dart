import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

import 'screens/welcome/welcome_page.dart';
import 'screens/login/login_page.dart';
import 'screens/signup/sign_up_page.dart';
import 'screens/home/home_page.dart';

import 'screens/favorites/favorites_page.dart';
import 'screens/dislikes/dislikes_page.dart';


import 'screens/settings/settings_page.dart';
import 'screens/settings/change_password_page.dart';

import 'screens/category_menu/category_menu_part1_page.dart';
import 'screens/category_menu/category_menu_part2_page.dart';


void main() {
  runApp(const FitSwipeApp());
}

class FitSwipeApp extends StatelessWidget {
  const FitSwipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitSwipe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF143A66),
        useMaterial3: false,
      ),

      
      initialRoute: AppRoutes.welcome,

      routes: {
        
        AppRoutes.welcome: (context) => const WelcomePage(),
        AppRoutes.login:   (context) => const LoginPage(),
        AppRoutes.signup:  (context) => const SignUpPage(),
        AppRoutes.home:    (context) => const HomePage(),

        
        AppRoutes.settings: (context) => const SettingsPage(),
        AppRoutes.changePassword: (context) => const ChangePasswordPage(),
        
        AppRoutes.categoryMenu1: (context) => const CategoryMenuPart1Page(),
        AppRoutes.categoryMenu2: (context) => const CategoryMenuPart2Page(),
      },
    );
  }
}
