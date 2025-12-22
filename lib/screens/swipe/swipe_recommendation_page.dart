import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/product_provider.dart';
import '../../models/product.dart';

class SwipeRecommendationPage extends StatefulWidget {
  const SwipeRecommendationPage({super.key});

  @override
  State<SwipeRecommendationPage> createState() =>
      _SwipeRecommendationPageState();
}

class _SwipeRecommendationPageState extends State<SwipeRecommendationPage> {
  static const creamColor = Color(0xFFFDF4E3);
  static const lightBlue = Color(0xFF5EA8D9);
  static const darkBlue = Color(0xFF234B73);

  int _currentIndex = 0;
  Offset _cardOffset = Offset.zero;
  bool _isProcessing = false;

  //fit url's(example)
  static const List<String> _sampleImages = [
    'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1503341504253-dff4815485f1?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1552374196-c4e7ffc6e126?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1552374196-c4e7ffc6e126?w=800&auto=format&fit=crop',
  ];

  String _getImageUrl(int index) {
    if (index < _sampleImages.length) {
      return _sampleImages[index % _sampleImages.length];
    }
    return _sampleImages[0];
  }

  Future<void> _swipeLeft(List<Product> products) async {
    if (_isProcessing || _currentIndex >= products.length) return;
    
    setState(() {
      _isProcessing = true;
      _cardOffset = const Offset(-2, 0);
    });

    final product = products[_currentIndex];
    final productProvider = context.read<ProductProvider>();
    
    // Disliking
    await productProvider.addDislike(product);

    await Future.delayed(const Duration(milliseconds: 300));
    
    if (!mounted) return;
    
    setState(() {
      _currentIndex++;
      _cardOffset = Offset.zero;
      _isProcessing = false;
    });
  }

  Future<void> _swipeRight(List<Product> products) async {
    if (_isProcessing || _currentIndex >= products.length) return;
    
    setState(() {
      _isProcessing = true;
      _cardOffset = const Offset(2, 0);
    });

    final product = products[_currentIndex];
    final productProvider = context.read<ProductProvider>();
    
    // Liking
    await productProvider.toggleFavorite(product, false);

    await Future.delayed(const Duration(milliseconds: 300));
    
    if (!mounted) return;
    
    setState(() {
      _currentIndex++;
      _cardOffset = Offset.zero;
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final productProvider = context.watch<ProductProvider>();
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),

              Center(
                child: Text(
                  'FitSwipe',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: uid == null
                    ? Center(
                        child: Text(
                          'Login required.',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : StreamBuilder<List<Product>>(
                        stream: productProvider.streamAllProducts(),
                        builder: (context, snap) {
                          final products = snap.data ?? [];
                          if (snap.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (snap.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snap.error}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }
                          
                          // Eğer products değiştiyse ve currentIndex geçersizse, sıfırla
                          if (products.isNotEmpty && _currentIndex >= products.length) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                setState(() {
                                  _currentIndex = 0;
                                });
                              }
                            });
                          }

                          return Column(
                            children: [
                              Expanded(
                                child: products.isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.inventory_2_outlined,
                                              size: 60,
                                              color: colorScheme.onSurface.withOpacity(0.5),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'No products yet.\nAdd products from Home screen.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: colorScheme.onSurface.withOpacity(0.7),
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : _currentIndex >= products.length
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.check_circle_outline,
                                                  size: 60,
                                                  color: colorScheme.primary,
                                                ),
                                                const SizedBox(height: 16),
                                                Text(
                                                  'You\'ve swiped all products!',
                                                  style: TextStyle(
                                                    color: colorScheme.primary,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : _buildProductCard(products[_currentIndex], products, colorScheme, isDark),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    iconSize: 50,
                                    onPressed: _isProcessing || products.isEmpty || _currentIndex >= products.length
                                        ? null
                                        : () => _swipeLeft(products),
                                    icon: Icon(
                                      Icons.close,
                                      color: _isProcessing || products.isEmpty || _currentIndex >= products.length
                                          ? colorScheme.onSurface.withOpacity(0.3)
                                          : Colors.red,
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                  IconButton(
                                    iconSize: 50,
                                    onPressed: _isProcessing || products.isEmpty || _currentIndex >= products.length
                                        ? null
                                        : () => _swipeRight(products),
                                    icon: Icon(
                                      Icons.favorite,
                                      color: _isProcessing || products.isEmpty || _currentIndex >= products.length
                                          ? colorScheme.onSurface.withOpacity(0.3)
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product currentProduct, List<Product> products, ColorScheme colorScheme, bool isDark) {
    final imageUrl = currentProduct.imageUrl ?? _getImageUrl(_currentIndex);
    
    return Center(
      child: SizedBox(
        width: 230,
        height: 400,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Arka plan kartları
            if (_currentIndex + 1 < products.length)
              Transform.rotate(
                angle: -0.12,
                child: Container(
                  width: 220,
                  height: 390,
                  decoration: BoxDecoration(
                    color: isDark 
                        ? colorScheme.primary.withOpacity(0.6)
                        : darkBlue.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            if (_currentIndex + 2 < products.length)
              Transform.rotate(
                angle: 0.12,
                child: Container(
                  width: 220,
                  height: 390,
                  decoration: BoxDecoration(
                    color: isDark
                        ? colorScheme.secondaryContainer
                        : lightBlue,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            // Ana kart
            AnimatedSlide(
              offset: _cardOffset,
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOut,
              child: Container(
                width: 210,
                height: 380,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: isDark 
                          ? Colors.black54 
                          : Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Görsel
                      Expanded(
                        flex: 3,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: colorScheme.surfaceVariant,
                              child: Icon(
                                Icons.image_outlined,
                                size: 60,
                                color: colorScheme.onSurface.withOpacity(0.5),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                      // Ürün bilgileri
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currentProduct.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                currentProduct.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              if (currentProduct.minPrice != null && 
                                  currentProduct.maxPrice != null)
                                Text(
                                  '₺${currentProduct.minPrice!.toStringAsFixed(0)} - ₺${currentProduct.maxPrice!.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.primary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
