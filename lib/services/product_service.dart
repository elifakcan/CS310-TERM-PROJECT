import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ---------------------------
  // PUBLIC PRODUCTS (READ)
  // ---------------------------
  /// Kullanıcının sadece **kendi** ürünlerini döndürür (Home screen için)
  Stream<List<Product>> streamProductsForUser(String uid) {
    return _db
        .collection('products')
        .where('createdBy', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => Product.fromFirestore(d)).toList(),
        );
  }

  /// Tüm kullanıcılar için ortak ürün havuzu (Swipe screen için)
  Stream<List<Product>> streamAllProducts() {
    return _db
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => Product.fromFirestore(d)).toList(),
        );
  }

  // ---------------------------
  // PUBLIC PRODUCTS (CREATE)
  // ---------------------------
  Future<void> addProduct(Product p) async {
    await _db.collection('products').add(p.toMap());
  }

  // ---------------------------
  // PUBLIC PRODUCTS (UPDATE)
  // ---------------------------
  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    await _db.collection('products').doc(id).update(data);
  }

  // ---------------------------
  // PUBLIC PRODUCTS (DELETE)
  // ---------------------------
  Future<void> deleteProduct(String id) async {
    await _db.collection('products').doc(id).delete();
  }

  // =========================================================
  // FAVORITES (USER-SPECIFIC): users/{uid}/favorites/{productId}
  // =========================================================

  /// Favorileri realtime stream olarak döndürür
  Stream<List<Product>> streamFavoriteProducts(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snap) {
          return snap.docs.map((d) {
            final data = d.data();
            final num? minVal = data['minPrice'] ?? data['price'];
            final num? maxVal = data['maxPrice'] ?? data['price'];
            return Product(
              id: d.id,
              title: (data['title'] ?? '').toString(),
              description: (data['description'] ?? '').toString(),
              minPrice: minVal != null ? minVal.toDouble() : null,
              maxPrice: maxVal != null ? maxVal.toDouble() : null,
              imageUrl: data['imageUrl'] as String?,
              createdBy: (data['createdBy'] ?? '').toString(),
              createdAt: (data['createdAt'] is Timestamp)
                  ? data['createdAt'] as Timestamp
                  : Timestamp.now(),
            );
          }).toList();
        });
  }

  /// Bir ürün favori mi? (realtime)
  Stream<bool> isFavorite(String uid, String productId) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(productId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  /// Favoriye ekle (doc id = productId)
  Future<void> addToFavorites(String uid, Product p) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(p.id)
        .set({
      'title': p.title,
      'description': p.description,
      'minPrice': p.minPrice,
      'maxPrice': p.maxPrice,
      'imageUrl': p.imageUrl,
      'createdBy': p.createdBy,
      'createdAt': p.createdAt,
      'addedAt': Timestamp.now(),
    });
  }

  /// Favoriden çıkar
  Future<void> removeFromFavorites(String uid, String productId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(productId)
        .delete();
  }

  // =========================================================
  // DISLIKES (USER-SPECIFIC): users/{uid}/dislikes/{productId}
  // =========================================================

  /// Dislike edilen ürünleri realtime stream olarak döndürür
  Stream<List<Product>> streamDislikedProducts(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('dislikes')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snap) {
          return snap.docs.map((d) {
            final data = d.data();
            final num? minVal = data['minPrice'] ?? data['price'];
            final num? maxVal = data['maxPrice'] ?? data['price'];
            return Product(
              id: d.id,
              title: data['title']?.toString() ?? '',
              description: data['description']?.toString() ?? '',
              minPrice: minVal != null ? (minVal as num).toDouble() : null,
              maxPrice: maxVal != null ? (maxVal as num).toDouble() : null,
              imageUrl: data['imageUrl'] as String?,
              createdBy: data['createdBy']?.toString() ?? '',
              createdAt: data['createdAt'] is Timestamp
                  ? data['createdAt'] as Timestamp
                  : Timestamp.now(),
            );
          }).toList();
        });
  }

  /// Dislike listesine ekle (doc id = productId)
  Future<void> addToDislikes(String uid, Product p) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('dislikes')
        .doc(p.id)
        .set({
      'title': p.title,
      'description': p.description,
      'minPrice': p.minPrice,
      'maxPrice': p.maxPrice,
      'imageUrl': p.imageUrl,
      'createdBy': p.createdBy,
      'createdAt': p.createdAt,
      'addedAt': Timestamp.now(),
    });
  }

  /// Dislike listesinden çıkar
  Future<void> removeFromDislikes(String uid, String productId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('dislikes')
        .doc(productId)
        .delete();
  }
}
