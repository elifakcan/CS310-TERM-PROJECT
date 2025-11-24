import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/cart_provider.dart';

class ShoppingBagScreen extends StatelessWidget {
  const ShoppingBagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5EEDC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EEDC),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Shopping Bag",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Color(0xFF1A3C61),
          ),
        ),
      ),
      body: cart.cartItems.isEmpty
          ? const Center(
              child: Text(
                "Your shopping bag is empty",
                style: TextStyle(fontSize: 18),
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
                        leading: Image.network(item.imageUrl, height: 50),
                        title: Text(item.name),
                        subtitle: Text("${item.price} ₺"),
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

                // Total + Checkout
                Container(
                  padding: const EdgeInsets.all(16),
                  color: const Color(0xFF1A3C61),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: ${cart.totalPrice.toStringAsFixed(2)} ₺",
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        onPressed: () {},
                        child: const Text(
                          "Checkout",
                          style: TextStyle(
                              color: Color(0xFF1A3C61), fontSize: 16),
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
