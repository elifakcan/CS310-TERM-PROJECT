import 'package:flutter/material.dart';
import 'category_products_page.dart';

class CategoryMenuPart2Page extends StatefulWidget {
  const CategoryMenuPart2Page({super.key});

  @override
  State<CategoryMenuPart2Page> createState() => _CategoryMenuPart2PageState();
}

class _CategoryMenuPart2PageState extends State<CategoryMenuPart2Page> {
  static const creamColor = Color(0xFFFDF4E3);
  static const lightBlue = Color(0xFF5EA8D9);
  static const darkBlue = Color(0xFF234B73);

  int selectedIndex = 0;

  static const _categoriesPart2 = [
    'SKIRTS',
    'SHOES',
    'BAGS',
    'ACCESSORIES',
    'SWEATSHIRTS',
  ];

  void _onCategoryTap(BuildContext context, String category) {
    final gender = selectedIndex == 0
        ? 'Woman'
        : selectedIndex == 1
            ? 'Man'
            : 'Children';
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryProductsPage(
          category: category,
          gender: gender,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Tabs
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

            /// Category list
            Expanded(
              child: ListView.builder(
                itemCount: _categoriesPart2.length,
                itemBuilder: (context, index) {
                  final label = _categoriesPart2[index];
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

            // Navigation is handled by parent CategoryMenuPage
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String label, int index) {
    final bool isSelected = index == selectedIndex;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}
