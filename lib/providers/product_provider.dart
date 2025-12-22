import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  String? _error;
  String? get error => _error;

  // =========================
  // PUBLIC PRODUCTS (READ)
  // =========================
  /// Kullanıcının kendi ürünlerini döndürür (Home screen için)
  Stream<List<Product>> streamPublicProducts() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _service.streamProductsForUser(uid);
  }

  /// Tüm kullanıcılar için ortak ürün havuzu (Swipe screen için)
  Stream<List<Product>> streamAllProducts() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _service.streamAllProducts();
  }

  // =========================
  // PUBLIC PRODUCTS (CREATE)
  // =========================
  Future<void> addPublicProduct({
    required String title,
    required String description,
    required double minPrice,
    required double maxPrice,
  }) async {
    _error = null;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      _error = "User not logged in.";
      notifyListeners();
      return;
    }

    final product = Product(
      id: '',
      title: title,
      description: description,
      minPrice: minPrice,
      maxPrice: maxPrice,
      createdBy: uid,
      createdAt: Timestamp.now(),
    );

    try {
      await _service.addProduct(product);
    } catch (e) {
      _error = e.toString();
    }

    notifyListeners();
  }

  // =========================
  // PUBLIC PRODUCTS (DELETE)
  // =========================
  Future<void> deleteProduct(String id) async {
    _error = null;

    try {
      await _service.deleteProduct(id);
    } catch (e) {
      _error = e.toString();
    }

    notifyListeners();
  }

  // =========================
  // PUBLIC PRODUCTS (UPDATE)
  // =========================
  Future<void> updateProduct(
      String id, {
        String? title,
        String? description,
        double? minPrice,
        double? maxPrice,
      }) async {
    _error = null;

    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (minPrice != null) data['minPrice'] = minPrice;
    if (maxPrice != null) data['maxPrice'] = maxPrice;

    if (data.isEmpty) return;

    try {
      await _service.updateProduct(id, data);
    } catch (e) {
      _error = e.toString();
    }

    notifyListeners();
  }

  // =========================================================
  // FAVORITES (USER-SPECIFIC): users/{uid}/favorites/{productId}
  // =========================================================

  /// Favoriler listesi (realtime)
  Stream<List<Product>> streamMyFavorites() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _service.streamFavoriteProducts(uid);
  }

  /// Bir ürün favori mi? (realtime bool)
  Stream<bool> isFavorite(String productId) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return Stream.value(false);
    return _service.isFavorite(uid, productId);
  }

  /// Favoriye ekle/çıkar (toggle)
  Future<void> toggleFavorite(Product p, bool currentlyFav) async {
    _error = null;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      _error = "User not logged in.";
      notifyListeners();
      return;
    }

    try {
      if (currentlyFav) {
        await _service.removeFromFavorites(uid, p.id);
      } else {
        await _service.addToFavorites(uid, p);
      }
    } catch (e) {
      _error = e.toString();
    }

    notifyListeners();
  }

  // =========================
  // DISLIKES (USER-SPECIFIC)
  // =========================

  /// Dislike listesi (realtime)
  Stream<List<Product>> streamMyDislikes() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _service.streamDislikedProducts(uid);
  }

  /// Dislike ekle
  Future<void> addDislike(Product p) async {
    _error = null;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      _error = "User not logged in.";
      notifyListeners();
      return;
    }

    try {
      await _service.addToDislikes(uid, p);
    } catch (e) {
      _error = e.toString();
    }

    notifyListeners();
  }
}
