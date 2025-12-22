import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'routes/app_routes.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/prefs_provider.dart';
import 'utils/cart_provider.dart';

// Screens
import 'screens/auth_gate.dart';
import 'screens/welcome/welcome_page.dart';
import 'screens/login/login_page.dart';
import 'screens/signup/sign_up_page.dart';
import 'screens/mainnav/main_nav_container.dart';
import 'screens/settings/settings_page.dart';
import 'screens/settings/change_password_page.dart';
import 'screens/productdetail/productdetail_page.dart';
import 'screens/shoppingbag/shoppingbag_page.dart';
import 'screens/swipe/swipe_recommendation_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => PrefsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const FitSwipeApp(),
    ),
  );
}

class FitSwipeApp extends StatelessWidget {
  const FitSwipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrefsProvider>(
      builder: (context, prefsProvider, _) {
        return MaterialApp(
          title: 'FitSwipe',
          debugShowCheckedModeBanner: false,
          
          // Light Theme
          theme: ThemeData(
            primaryColor: const Color(0xFF143A66),
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFFFFF9EF), // lightCream
            useMaterial3: false,
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF143A66), // darkBlue
              surface: Colors.white,
              onSurface: Colors.black87,
              onPrimary: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF143A66),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black87),
              bodyMedium: TextStyle(color: Colors.black87),
              bodySmall: TextStyle(color: Colors.black54),
            ),
          ),
          
          // Dark Theme
          darkTheme: ThemeData(
            primaryColor: const Color(0xFF143A66),
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFF121212),
            useMaterial3: false,
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1E88E5), // lighter blue for dark mode
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
              onPrimary: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E1E1E),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              bodySmall: TextStyle(color: Colors.white70),
            ),
          ),
          
          // Theme mode'u PrefsProvider'dan al
          themeMode: prefsProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

          // AuthGate ile auth state kontrolü
          home: const AuthGate(),

          routes: {
            // AUTH
            AppRoutes.welcome: (context) => const WelcomePage(),
            AppRoutes.login: (context) => const LoginPage(),
            AppRoutes.signup: (context) => const SignUpPage(),

            // MAIN NAVIGATION
            AppRoutes.home: (context) => const MainNavContainer(initialIndex: 0),

            // SETTINGS
            AppRoutes.settings: (context) => const SettingsPage(),
            AppRoutes.changePassword: (context) => const ChangePasswordPage(),

            // PRODUCT DETAIL
            AppRoutes.productDetail: (context) => const ProductDetailScreen(),

            // SHOPPING BAG
            AppRoutes.shoppingBag: (context) => const ShoppingBagScreen(),

            // SWIPE
            AppRoutes.swipe: (context) => const SwipeRecommendationPage(),
          },
        );
      },
    );
  }
}
