import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ➜ SignUp'tan gelen argümanları al
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    final name = (args?['name'] ?? '').trim();
    final surname = (args?['surname'] ?? '').trim();
    final username = (args?['username'] ?? '').trim();

    final fullName = [name, surname].where((s) => s.isNotEmpty).join(' ');
    final displayText =
        fullName.isNotEmpty ? fullName : (username.isNotEmpty ? username : 'Name Surname');

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9EF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'FitSwipe',
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF143A66),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF143A66)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundColor: Color(0xFF143A66),
            child: Icon(Icons.person, size: 70, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            displayText,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF143A66),
            ),
          ),
          const SizedBox(height: 40),

          // 🔹 İkonları buton yapıp yönlendirme ekledim
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                tooltip: 'Dislikes',
                iconSize: 48,
                icon: const Icon(Icons.close, color: Color(0xFF143A66)),
                onPressed: () {
                  Navigator.pushNamed(context, '/dislikes'); // veya AppRoutes.dislikes
                },
              ),
              const SizedBox(width: 60),
              IconButton(
                tooltip: 'Favorites',
                iconSize: 48,
                icon: const Icon(Icons.favorite, color: Color(0xFF143A66)),
                onPressed: () {
                  Navigator.pushNamed(context, '/favorites'); // veya AppRoutes.favorites
                },
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFFFF9EF),
        selectedItemColor: const Color(0xFF143A66),
        unselectedItemColor: const Color(0xFF143A66),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}
