import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  static void _showEditProductDialog(
    BuildContext context,
    ProductProvider productProvider,
    Product product,
    ColorScheme colorScheme,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => _EditProductDialog(
        productProvider: productProvider,
        product: product,
        colorScheme: colorScheme,
        onSuccess: () {
          Navigator.of(dialogContext).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final productProvider = context.watch<ProductProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canEdit = uid != null && uid == product.createdBy;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.primary, // Mavi arka plan
        title: Text(
          "FitSwipe",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white, // Beyaz renk
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Beyaz icon
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (canEdit)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white), // Beyaz icon
              tooltip: 'Edit',
              onPressed: () => _showEditProductDialog(
                context,
                productProvider,
                product,
                colorScheme,
              ),
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.of(context).size.width;
          final isSmallScreen = screenWidth < 600;
          
          return SingleChildScrollView(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                
                // Product Image
                if (product.imageUrl != null)
                  Center(
                    child: Container(
                      width: isSmallScreen 
                          ? screenWidth - 32 
                          : constraints.maxWidth * 0.7,
                      height: isSmallScreen ? 300 : 400,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          product.imageUrl!,
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
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    height: isSmallScreen ? 200 : 300,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.image_outlined,
                      size: 60,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                
                // Title
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 22 : 28,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Brand and Category (if available)
                if (product.brand != null || product.category != null)
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      if (product.brand != null)
                        Chip(
                          label: Text(
                            product.brand!,
                            style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                          ),
                          backgroundColor: colorScheme.primaryContainer,
                        ),
                      if (product.category != null)
                        Chip(
                          label: Text(
                            product.category!,
                            style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                          ),
                          backgroundColor: colorScheme.secondaryContainer,
                        ),
                      if (product.outfitType != null)
                        Chip(
                          label: Text(
                            product.outfitType!,
                            style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                          ),
                          backgroundColor: colorScheme.tertiaryContainer,
                        ),
                    ],
                  ),
                
                const SizedBox(height: 16),
                
                // Price
                if (product.price != null)
                  Text(
                    '₺${product.price!.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 20 : 24,
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                
                const SizedBox(height: 24),
                
                // Description
                Text(
                  "Description",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 15 : 16,
                    color: colorScheme.onSurface,
                    height: 1.5,
                  ),
                ),
            
                const SizedBox(height: 24),
                
                // Edit Button (only for creator)
                if (canEdit)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 12 : 16,
                        ),
                      ),
                      icon: Icon(Icons.edit),
                      label: Text(
                        'Edit Product',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                        ),
                      ),
                      onPressed: () => _showEditProductDialog(
                        context,
                        productProvider,
                        product,
                        colorScheme,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EditProductDialog extends StatefulWidget {
  final ProductProvider productProvider;
  final Product product;
  final ColorScheme colorScheme;
  final VoidCallback onSuccess;

  const _EditProductDialog({
    required this.productProvider,
    required this.product,
    required this.colorScheme,
    required this.onSuccess,
  });

  @override
  State<_EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<_EditProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _descriptionController = TextEditingController(text: widget.product.description);
    _priceController =
        TextEditingController(text: widget.product.price?.toString() ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final price = double.parse(_priceController.text.trim());

      await widget.productProvider.updateProduct(
        widget.product.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: price,
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
        'Edit Product',
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
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price (₺)',
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
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.colorScheme.onPrimary,
                    ),
                  ),
                )
              : const Text('Update'),
        ),
      ],
    );
  }
}
