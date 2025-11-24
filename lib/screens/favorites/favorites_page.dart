import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../utils/product.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  static const _blue = Color.fromARGB(255, 154, 197, 247);
  static const _bg   = Color(0xFFFFF9EF);

  // 9 örnek görsel (3x3)
  List<String> get _images => const [
    'https://images.unsplash.com/photo-1521575107034-e0fa0b594529?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1582582494700-83b517a4a2b8?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1516642499105-492ff3ac521b?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1521334726092-b509a19597c6?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1539533113208-f6df8cc8b543?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1520975922284-7b6836cc5de1?w=800&auto=format&fit=crop',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'FitSwipe',
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: _blue,
          ),
        ),
        iconTheme: const IconThemeData(color: _blue),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          const Icon(Icons.favorite, color: _blue, size: 28),
          const SizedBox(height: 8),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _BorderedGrid(
                images: _images,
                lineColor: _blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BorderedGrid extends StatelessWidget {
  const _BorderedGrid({
    required this.images,
    required this.lineColor,
  });

  final List<String> images;
  final Color lineColor;

  @override
  Widget build(BuildContext context) {
    const cross = 3;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: lineColor, width: 1.2),
          left: BorderSide(color: lineColor, width: 1.2),
        ),
      ),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cross,
          childAspectRatio: 1,
        ),
        itemCount: images.length,
        itemBuilder: (context, i) {
          final img = images[i];

          final product = Product(
            id: '$i',
            name: 'Sample Product $i',
            price: 199.99,
            imageUrl: img,
            sizes: ['S', 'M', 'L'],
            color: 'Blue',
            composition: 'Cotton 100%',
          );

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.productDetail,
                arguments: product,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: lineColor, width: 1.2),
                  bottom: BorderSide(color: lineColor, width: 1.2),
                ),
              ),
              child: ClipRect(
                child: Image.network(
                  img,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
