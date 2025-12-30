import 'package:flutter/material.dart';
import 'category_menu_part1_page.dart';
import 'category_menu_part2_page.dart';

/// Unified category menu page that uses PageView to switch between parts
/// This keeps the bottom navigation bar visible
class CategoryMenuPage extends StatefulWidget {
  const CategoryMenuPage({super.key});

  @override
  State<CategoryMenuPage> createState() => _CategoryMenuPageState();
}

class _CategoryMenuPageState extends State<CategoryMenuPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "FitSwipe",
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: const [
                  CategoryMenuPart1Page(),
                  CategoryMenuPart2Page(),
                ],
              ),
            ),
            // Navigation indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _currentPage == 0
                        ? null
                        : () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                    child: Text(
                      "← Back",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _currentPage == 0
                            ? colorScheme.onSurface.withOpacity(0.3)
                            : colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Page indicators
                  Row(
                    children: [
                      _buildPageIndicator(0),
                      const SizedBox(width: 8),
                      _buildPageIndicator(1),
                    ],
                  ),
                  const SizedBox(width: 24),
                  TextButton(
                    onPressed: _currentPage == 1
                        ? null
                        : () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                    child: Text(
                      "Next →",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _currentPage == 1
                            ? colorScheme.onSurface.withOpacity(0.3)
                            : colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isActive = _currentPage == index;

    return Container(
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? colorScheme.primary
            : colorScheme.onSurface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

