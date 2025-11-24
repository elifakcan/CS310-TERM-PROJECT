
import 'package:flutter/material.dart';

class CategoryMenuPart1Page extends StatefulWidget {
  const CategoryMenuPart1Page({super.key});

  @override
  State<CategoryMenuPart1Page> createState() => _CategoryMenuPart1PageState();
}

class _CategoryMenuPart1PageState extends State<CategoryMenuPart1Page> {
  
  static const creamColor = Color(0xFFFDF4E3);
  static const lightBlue = Color(0xFF5EA8D9);
  static const darkBlue = Color(0xFF234B73);

 
  int selectedIndex = 0;

  static const _categoriesPart1 = [
    'DRESS',
    'JACKETS',
    'COATS | TRENCH COATS',
    'CARDIGANS',
    'BLAZERS',
    'TOP | BODY',
    'T-SHIRTS',
    'JEANS',
    'TROUSERS',
    'KNITWEAR',
  ];

  void _onCategoryTap(BuildContext context, String category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening $category...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
             
              const Center(
                child: Text(
                  'FitSwipe',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),

            
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTabItem('Woman', 0),
                  const SizedBox(width: 18),
                  _buildTabItem('Man', 1),
                  const SizedBox(width: 18),
                  _buildTabItem('Children', 2),
                ],
              ),

              const SizedBox(height: 24),

              
              Expanded(
                child: ListView.builder(
                  itemCount: _categoriesPart1.length,
                  itemBuilder: (context, index) {
                    final label = _categoriesPart1[index];
                    final bool isLight = index.isEven;
                    final Color bgColor = isLight ? lightBlue : darkBlue;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => _onCategoryTap(context, label),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bgColor,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

            
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _buildTabItem(String label, int index) {
    final bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () {
        setState(() => selectedIndex = index);
      },
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          decoration:
          isSelected ? TextDecoration.underline : TextDecoration.none,
          color: Colors.black87,
        ),
      ),
    );
  }

 
  Widget _buildBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: darkBlue,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.home, color: Colors.white, size: 22),
        ),
        const Icon(Icons.search, color: darkBlue, size: 28),
        const Text(
          'MENU',
          style: TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const Icon(Icons.shopping_bag, color: darkBlue, size: 28),
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: lightBlue,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 22),
        ),
      ],
    );
  }
}
