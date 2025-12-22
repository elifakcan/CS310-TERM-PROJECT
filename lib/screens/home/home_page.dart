import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../routes/app_routes.dart';
import '../../providers/product_provider.dart';
import '../../models/product.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static void _showDeleteConfirmDialog(
    BuildContext context,
    ProductProvider productProvider,
    Product product,
    ColorScheme colorScheme,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Delete Product',
          style: TextStyle(color: colorScheme.primary),
        ),
        content: Text('Are you sure you want to delete "${product.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await productProvider.deleteProduct(product.id);
              
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Product deleted'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  static void _showAddProductDialog(
    BuildContext context,
    ProductProvider productProvider,
    ColorScheme colorScheme,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => _AddProductDialog(
        productProvider: productProvider,
        colorScheme: colorScheme,
        onSuccess: () {
          Navigator.of(dialogContext).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

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
        title: Text(
          'FitSwipe',
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Favorites',
            icon: Icon(Icons.favorite, color: colorScheme.primary),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.favorites),
          ),
          IconButton(
            tooltip: 'Settings',
            icon: Icon(Icons.settings, color: colorScheme.primary),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        tooltip: 'Add Product',
        onPressed: uid == null
            ? null
            : () => _showAddProductDialog(context, productProvider, colorScheme),
        child: const Icon(Icons.add),
      ),

      body: uid == null
          ? Center(
        child: Text(
          'Login required to add/favorite products.',
          style: TextStyle(color: colorScheme.primary, fontSize: 16),
        ),
      )
          : StreamBuilder<List<Product>>(
        stream: productProvider.streamPublicProducts(),
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
                'No products yet. Tap + to add one.',
                style: TextStyle(color: colorScheme.primary, fontSize: 16),
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
                  border: Border.all(color: colorScheme.primary.withOpacity(0.15)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
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
                  child: Text(
                    '${p.description}\n'
                    '${(p.minPrice != null && p.maxPrice != null && p.minPrice != p.maxPrice) ? '₺${p.minPrice!.toStringAsFixed(0)} - ₺${p.maxPrice!.toStringAsFixed(0)}' : ''}',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  ),
                  isThreeLine: true,

                  
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Favorite toggle
                      StreamBuilder<bool>(
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
                      
                      // Delete button (sadece kendi ürünü için)
                      if (uid == p.createdBy)
                        IconButton(
                          tooltip: 'Delete',
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => _showDeleteConfirmDialog(
                            context,
                            productProvider,
                            p,
                            colorScheme,
                          ),
                        ),
                    ],
                  ),

                  // Ürün detayına git
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

class _AddProductDialog extends StatefulWidget {
  final ProductProvider productProvider;
  final ColorScheme colorScheme;
  final VoidCallback onSuccess;

  const _AddProductDialog({
    required this.productProvider,
    required this.colorScheme,
    required this.onSuccess,
  });

  @override
  State<_AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<_AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final minPrice = double.parse(_minPriceController.text.trim());
      final maxPrice = double.parse(_maxPriceController.text.trim());

      if (maxPrice < minPrice) {
        throw Exception('Max price cannot be less than min price');
      }

      await widget.productProvider.addPublicProduct(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        minPrice: minPrice,
        maxPrice: maxPrice,
      );

      if (mounted) {
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add New Product',
        style: TextStyle(color: widget.colorScheme.primary),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _minPriceController,
                      decoration: const InputDecoration(
                        labelText: 'Min Price (₺)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        final price = double.tryParse(value);
                        if (price == null || price <= 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _maxPriceController,
                      decoration: const InputDecoration(
                        labelText: 'Max Price (₺)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        final price = double.tryParse(value);
                        if (price == null || price <= 0) {
                          return 'Invalid';
                        }
                        if (_minPriceController.text.trim().isNotEmpty) {
                          final minPrice =
                              double.tryParse(_minPriceController.text.trim());
                          if (minPrice != null && price < minPrice) {
                            return 'Max < Min';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.colorScheme.primary,
            foregroundColor: widget.colorScheme.onPrimary,
          ),
          onPressed: _isLoading ? null : _handleSubmit,
          child: _isLoading
              ? SizedBox(
                  width: 19,
                  height: 19,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.colorScheme.onPrimary,
                    ),
                  ),
                )
              : const Text('Add'),
        ),
      ],
    );
  }
}
