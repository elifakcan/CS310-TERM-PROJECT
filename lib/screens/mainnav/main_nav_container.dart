import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../favorites/favorites_page.dart';
import '../dislikes/dislikes_page.dart';
import '../shoppingbag/shoppingbag_page.dart';
import '../category_menu/category_menu_part1_page.dart';
import '../swipe/swipe_recommendation_page.dart';

class MainNavContainer extends StatefulWidget {
  final int initialIndex;
  const MainNavContainer({super.key, this.initialIndex = 0});

  @override
  State<MainNavContainer> createState() => _MainNavContainerState();
}

class _MainNavContainerState extends State<MainNavContainer> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = const [
    HomePage(),               // index 0
    FavoritesPage(),          // index 1
    CategoryMenuPart1Page(),  // index 2
    SwipeRecommendationPage(),// index 3 (MENU’nün sağında)
    ShoppingBagScreen(),      // index 4
    DislikesPage(),           // index 5
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFFFFF9EF),
        selectedItemColor: const Color(0xFF143A66),
        unselectedItemColor: const Color(0xFF143A66),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
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
                color: Color(0xFF143A66),
              ),
            ),
            label: '',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Swipe',
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
    );
  }
}
