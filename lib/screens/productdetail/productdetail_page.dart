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
        title: Text(
          "FitSwipe",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: colorScheme.primary,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (canEdit)
            IconButton(
              icon: Icon(Icons.edit, color: colorScheme.primary),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            
            // Title
            Text(
              product.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Price range
            if (product.minPrice != null && product.maxPrice != null)
              Text(
                '₺${product.minPrice!.toStringAsFixed(0)} - ₺${product.maxPrice!.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 20,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            
            const SizedBox(height: 20),
            
            // Description
            Text(
              "Description",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface,
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
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(Icons.edit),
                  label: Text('Edit Product'),
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
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _descriptionController = TextEditingController(text: widget.product.description);
    _minPriceController =
        TextEditingController(text: widget.product.minPrice?.toString() ?? '');
    _maxPriceController =
        TextEditingController(text: widget.product.maxPrice?.toString() ?? '');
  }

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

      await widget.productProvider.updateProduct(
        widget.product.id,
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
                  if (_maxPriceController.text.isNotEmpty) {
                    final maxPrice =
                        double.tryParse(_maxPriceController.text);
                    if (maxPrice != null && price > maxPrice) {
                      return 'Min > Max';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
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
                  if (_minPriceController.text.isNotEmpty) {
                    final minPrice =
                        double.tryParse(_minPriceController.text);
                    if (minPrice != null && price < minPrice) {
                      return 'Max < Min';
                    }
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
