import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class CartProvider extends ChangeNotifier {
  final ProductService _productService;
  final FirebaseAuth _auth;
  final List<Product> _cartItems = [];
  String? _currentUserId;
  StreamSubscription<List<Product>>? _cartSubscription;

  List<Product> get cartItems => _cartItems;

  CartProvider({ProductService? productService, FirebaseAuth? auth})
      : _productService = productService ?? ProductService(),
        _auth = auth ?? FirebaseAuth.instance {
    // Test modunda auth null ise (mock auth verilmişse) authStateChanges dinleme
    if (_auth != null) {
      // İlk kullanıcı için cart'ı yükle
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        _currentUserId = currentUser.uid;
        _loadCart(currentUser.uid);
      }
      
      // Auth state değişikliklerini dinle
      _auth.authStateChanges().listen((User? user) {
        final newUserId = user?.uid;
        
        // Kullanıcı değiştiyse
        if (newUserId != _currentUserId) {
          // Eski subscription'ı iptal et
          _cartSubscription?.cancel();
          
          _currentUserId = newUserId;
          _cartItems.clear();
          
          // Yeni kullanıcı için cart'ı yükle
          if (newUserId != null) {
            _loadCart(newUserId);
          } else {
            notifyListeners();
          }
        }
      });
    }
  }

  /// Firestore'dan cart'ı yükle
  void _loadCart(String uid) {
    _cartSubscription = _productService.streamCartProducts(uid).listen(
      (products) {
        _cartItems.clear();
        _cartItems.addAll(products);
        notifyListeners();
      },
      onError: (error) {
        debugPrint('Cart load error: $error');
      },
    );
  }

  /// Cart'a ürün ekle
  Future<void> addToCart(Product product) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      debugPrint('Cannot add to cart: User not logged in');
      throw Exception('User not logged in');
    }
    
    try {
      await _productService.addToCart(uid, product);
      // Stream otomatik olarak güncellenecek, burada notifyListeners çağırmaya gerek yok
    } catch (e) {
      debugPrint('CartProvider: Error adding to cart: $e');
      rethrow; // Hatayı üst seviyeye fırlat
    }
  }

  /// Cart'tan ürün çıkar
  Future<void> removeFromCart(Product product) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      debugPrint('Cannot remove from cart: User not logged in');
      return;
    }
    
    try {
      await _productService.removeFromCart(uid, product.id);
      // Stream otomatik olarak güncellenecek, burada notifyListeners çağırmaya gerek yok
    } catch (e) {
      debugPrint('Error removing from cart: $e');
    }
  }

  double get totalPrice {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item.price ?? 0.0;
    }
    return total;
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _cartSubscription?.cancel();
    super.dispose();
  }
}
