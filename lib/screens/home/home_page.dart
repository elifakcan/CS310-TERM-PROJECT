import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';   // DOĞRU

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    final name = (args?['name'] ?? '').trim();
    final surname = (args?['surname'] ?? '').trim();
    final username = (args?['username'] ?? '').trim();

    final fullName = [name, surname].where((s) => s.isNotEmpty).join(' ');
    final displayText =
        fullName.isNotEmpty ? fullName : (username.isNotEmpty ? username : 'Name Surname');

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9EF),

      // ---------------- APPBAR ----------------
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
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
        ],
      ),

      // ---------------- BODY ----------------
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

          // --------- Swipe Buttons (X + ❤️) ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                tooltip: 'Dislike',
                iconSize: 54,
                icon: const Icon(Icons.close, color: Color(0xFF143A66)),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.dislikes);
                },
              ),
              const SizedBox(width: 70),
              IconButton(
                tooltip: 'Favorite',
                iconSize: 54,
                icon: const Icon(Icons.favorite, color: Color(0xFF143A66)),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.favorites);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
