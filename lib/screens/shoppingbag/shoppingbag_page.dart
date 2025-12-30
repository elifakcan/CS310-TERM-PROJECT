import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/cart_provider.dart';

class ShoppingBagScreen extends StatelessWidget {
  const ShoppingBagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Back butonunu gizle
        title: Text(
          "My Bag",
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
      ),
      body: cart.cartItems.isEmpty
          ? Center(
              child: Text(
                "Your shopping bag is empty",
                style: TextStyle(
                  fontSize: 18,
                  color: colorScheme.onSurface,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cart.cartItems[index];

                      return ListTile(
                        leading: item.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.imageUrl!,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 50,
                                      width: 50,
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
                                height: 50,
                                width: 50,
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
                          item.title,
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                        subtitle: Text(
                          item.price != null
                              ? "₺${item.price!.toStringAsFixed(0)}"
                              : "Fiyat belirtilmemiş",
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            cart.removeFromCart(item);
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Total
                Container(
                  padding: const EdgeInsets.all(16),
                  color: colorScheme.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Total: ${cart.totalPrice.toStringAsFixed(2)} ₺",
                        style: TextStyle(
                          fontSize: 20,
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
