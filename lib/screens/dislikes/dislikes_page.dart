import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class DislikesPage extends StatelessWidget {
  const DislikesPage({super.key});

  static const _blue = Color(0xFF143A66);
  static const _bg   = Color(0xFFFFF9EF);

  List<String> get _images => const [
    'https://images.unsplash.com/photo-1542060748-10c28b62716a?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1520974735194-8d95fc0f7aa0?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1538332576228-0b3b4c1ee8c6?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1503342452485-86ff0a3b42f2?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1551537482-f2075a1d41f2?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1516251193007-45ef944ab0c6?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1520975661595-645c67b343cc?w=800&auto=format&fit=crop',
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
          const Icon(Icons.close, color: _blue, size: 28),
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
          return Container(
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
          );
        },
      ),
    );
  }
}
