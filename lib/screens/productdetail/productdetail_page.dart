import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/product.dart';
import '../../utils/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      backgroundColor: const Color(0xFFF5EEDC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EEDC),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "FitSwipe",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Color(0xFF1A3C61),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A3C61)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Image.network(product.imageUrl, height: 250),
          const SizedBox(height: 20),
          
          Text(product.name,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600)),
          
          Text("${product.price} ₺",
              style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold)),
          
          const SizedBox(height: 10),
          Text(product.sizes.join(" | "),
              style: const TextStyle(fontSize: 16)),
          
          Text(product.color, style: const TextStyle(fontSize: 16)),
          
          const SizedBox(height: 10),
          Text("Composition:\n${product.composition}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14)),
          
          const SizedBox(height: 20),
          
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A3C61)),
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false)
                  .addToCart(product);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text("${product.name} added to shopping bag!")),
              );
            },
            child: const Text(
              "Add to Shopping Bag",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
