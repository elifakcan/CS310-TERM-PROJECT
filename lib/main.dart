import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

import 'utils/cart_provider.dart';
import 'screens/productdetail/productdetail_page.dart';
import 'screens/shoppingbag/shoppingbag_page.dart';

void main() {
  runApp(const FitSwipeApp());
}

class FitSwipeApp extends StatelessWidget {
  const FitSwipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'FitSwipe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF143A66),
          useMaterial3: false,
        ),
        initialRoute: AppRoutes.welcome,
        routes: {
          AppRoutes.welcome: (context) => const WelcomePage(),
          AppRoutes.login: (context) => const LoginPage(),

          AppRoutes.favorites: (context) => const FavoritesPage(),
          AppRoutes.dislikes: (context) => const DislikesPage(),

          AppRoutes.settings: (context) => const SettingsPage(),
          AppRoutes.changePassword: (context) => const ChangePasswordPage(),

          AppRoutes.productDetail: (context) => const ProductDetailScreen(),
          AppRoutes.shoppingBag: (context) => const ShoppingBagScreen(),
        },
      ),
    );
  }
}
