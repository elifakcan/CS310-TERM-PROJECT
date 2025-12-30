import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/product_provider.dart';
import '../../models/product.dart';
import '../../routes/app_routes.dart';

class CategoryProductsPage extends StatelessWidget {
  final String category;
  final String? gender;

  const CategoryProductsPage({
    super.key,
    required this.category,
    this.gender,
  });

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
        title: Text(
          category,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),
      body: uid == null
          ? Center(
              child: Text(
                'Login required.',
                style: TextStyle(color: colorScheme.primary, fontSize: 16),
              ),
            )
          : StreamBuilder<List<Product>>(
              stream: productProvider.streamProductsByCategory(category, gender),
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
                          'No products found in this category.',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final p = products[i];

                    return Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.15),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        leading: p.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  p.imageUrl!,
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
                                        color:
                                            colorScheme.onSurface.withOpacity(0.5),
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
                          p.title,
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.description,
                                style: TextStyle(color: colorScheme.onSurface),
                              ),
                              if (p.brand != null)
                                Text(
                                  'Brand: ${p.brand}',
                                  style: TextStyle(
                                    color: colorScheme.onSurface.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              if (p.price != null)
                                Text(
                                  '₺${p.price!.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        isThreeLine: true,
                        trailing: StreamBuilder<bool>(
                          stream: productProvider.isFavorite(p.id),
                          builder: (context, favSnap) {
                            final isFav = favSnap.data ?? false;

                            return IconButton(
                              tooltip: isFav ? 'Unfavorite' : 'Favorite',
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: colorScheme.primary,
                              ),
                              onPressed: () async {
                                await productProvider.toggleFavorite(p, isFav);
                              },
                            );
                          },
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.productDetail,
                            arguments: p,
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

