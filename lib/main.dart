import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes/app_routes.dart';

// AUTH
import 'screens/welcome/welcome_page.dart';
import 'screens/login/login_page.dart';
import 'screens/signup/sign_up_page.dart';

// MAIN NAV CONTAINER
import 'screens/mainnav/main_nav_container.dart';

// OTHER PAGES
import 'screens/settings/settings_page.dart';
import 'screens/settings/change_password_page.dart';
import 'screens/productdetail/productdetail_page.dart';
import 'screens/shoppingbag/shoppingbag_page.dart';
import 'screens/swipe/swipe_recommendation_page.dart';   // ⭐ YENİ EKLENEN
import 'utils/cart_provider.dart';

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
          // AUTH
          AppRoutes.welcome: (context) => const WelcomePage(),
          AppRoutes.login: (context) => const LoginPage(),
          AppRoutes.signup: (context) => const SignUpPage(),

          // MAIN NAVIGATION (BOTTOM BAR)
          AppRoutes.home: (context) => const MainNavContainer(initialIndex: 0),

          // SETTINGS
          AppRoutes.settings: (context) => const SettingsPage(),
          AppRoutes.changePassword: (context) => const ChangePasswordPage(),

          // PRODUCT DETAIL
          AppRoutes.productDetail: (context) => const ProductDetailScreen(),

          // SHOPPING BAG
          AppRoutes.shoppingBag: (context) => const ShoppingBagScreen(),

          // ⭐ SWIPE PAGE (MENÜNÜN ÜSTÜNDEKİ BUTON)
          AppRoutes.swipe: (context) => const SwipeRecommendationPage(),
        },
      ),
    );
  }
}
