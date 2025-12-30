import 'package:flutter/material.dart';
import '../favorites/favorites_page.dart';
import '../dislikes/dislikes_page.dart';
import '../shoppingbag/shoppingbag_page.dart';
import '../category_menu/category_menu_page.dart';
import '../swipe/swipe_recommendation_page.dart';

class MainNavContainer extends StatefulWidget {
  final int initialIndex;
  const MainNavContainer({super.key, this.initialIndex = 0});

  @override
  State<MainNavContainer> createState() => _MainNavContainerState();

  // Home'dan erişilebilmesi için static method
  static void navigateToIndex(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_MainNavContainerState>();
    state?.navigateToIndex(index);
  }
}

class _MainNavContainerState extends State<MainNavContainer> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = const [
    SwipeRecommendationPage(),// index 0 - Ana sayfa (Swipe)
    FavoritesPage(),          // index 1
    CategoryMenuPage(),       // index 2
    ShoppingBagScreen(),      // index 3
    DislikesPage(),           // index 4
  ];

  // Bottom nav index'ini değiştirmek için public method
  void navigateToIndex(int index) {
    if (mounted && index >= 0 && index < _screens.length) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return PopScope(
      canPop: false, // Geri tuşuna basınca uygulamadan çıkmasın
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Swipe',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Likes',
          ),

          BottomNavigationBarItem(
            icon: Text(
              "MENU",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            label: '',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Bag',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.close),
            label: 'Dislikes',
          ),
        ],
      ),
      ),
    );
  }
}
