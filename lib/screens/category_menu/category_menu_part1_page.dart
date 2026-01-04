import 'package:flutter/material.dart';
import 'category_menu_part2_page.dart';
import 'category_products_page.dart';

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
           
            /// CATEGORY TABS (Woman / Man / Children)
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

            /// CATEGORY LIST
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
