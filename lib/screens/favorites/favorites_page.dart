import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../routes/app_routes.dart';
import '../../providers/product_provider.dart';
import '../../models/product.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final productProvider = context.watch<ProductProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Back butonunu gizle
        iconTheme: IconThemeData(color: colorScheme.primary),
        title: Text(
          'Favorites',
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
      ),
      body: uid == null
          ? Center(
        child: Text(
          'Login required.',
          style: TextStyle(color: colorScheme.primary, fontSize: 16),
        ),
      )
          : StreamBuilder<List<Product>>(
        stream: productProvider.streamMyFavorites(),
        builder: (context, snap) {
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

          final products = snap.data ?? [];
          if (products.isEmpty) {
            return Center(
              child: Text(
                'No favorites yet.',
                style: TextStyle(color: colorScheme.primary, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            physics: const BouncingScrollPhysics(),
            shrinkWrap: false,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final product = products[i];

              return Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.primary.withOpacity(0.15)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  leading: product.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 60,
                                color: colorScheme.surfaceVariant,
                                child: Icon(
                                  Icons.image_outlined,
                                  color: colorScheme.onSurface.withOpacity(0.5),
                                ),
                              );
                            },
                          ),
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.image_outlined,
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                  title: Text(
                    product.title,
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '${product.description}\n'
                      '${product.price != null ? '₺${product.price!.toStringAsFixed(0)}' : ''}',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  ),
                  isThreeLine: true,
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      tooltip: 'Remove from favorites',
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 28,
                      ),
                      onPressed: () async {
                        final productTitle = product.title;
                        final productCopy = product; // Ürünü kopyala
                        final productProviderRef = context.read<ProductProvider>();
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        
                        // Önce SnackBar'ı göster
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text('$productTitle removed from favorites'),
                            backgroundColor: Colors.orange,
                            duration: const Duration(seconds: 3),
                            action: SnackBarAction(
                              label: 'Undo',
                              textColor: Colors.white,
                              onPressed: () async {
                                // Undo: Ürünü tekrar favorilere ekle
                                // Provider referansını baştan aldık, context kullanmadan direkt kullan
                                try {
                                  await productProviderRef.toggleFavorite(productCopy, false);
                                } catch (e) {
                                  debugPrint('Undo error: $e');
                                }
                              },
                            ),
                          ),
                        );
                        
                        // Sonra ürünü kaldır
                        await productProviderRef.toggleFavorite(product, true);
                      },
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.productDetail,
                      arguments: product,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

