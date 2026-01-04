import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  final FirebaseFirestore _db;

  ProductService({FirebaseFirestore? db}) 
      : _db = db ?? FirebaseFirestore.instance;

  
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

  /// Kategoriye göre filtreleme
  Stream<List<Product>> streamProductsByCategory(String? category, String? gender) {
    Query query = _db.collection('products');
    
    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }
    
    if (gender != null && gender.isNotEmpty) {
      query = query.where('gender', isEqualTo: gender);
    }
    
    return query
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => Product.fromFirestore(d)).toList(),
        );
  }

  /// Sadece admin ürünlerini getir (swipe için)
  Stream<List<Product>> streamAdminProducts() {
    return _db
        .collection('products')
        .where('isAdminProduct', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => Product.fromFirestore(d)).toList(),
        );
  }

  
  
  Future<void> addProduct(Product p) async {
    await _db.collection('products').add(p.toMap());
  }

  
  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    await _db.collection('products').doc(id).update(data);
  }

  
  Future<void> deleteProduct(String id) async {
    await _db.collection('products').doc(id).delete();
  }

  

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
            // Backward compatibility: Eski minPrice/maxPrice varsa price'a çevir
            double? priceValue;
            if (data['price'] != null) {
              priceValue = (data['price'] as num).toDouble();
            } else if (data['minPrice'] != null) {
              priceValue = (data['minPrice'] as num).toDouble();
            } else if (data['maxPrice'] != null) {
              priceValue = (data['maxPrice'] as num).toDouble();
            }
            return Product(
              id: d.id,
              title: (data['title'] ?? '').toString(),
              description: (data['description'] ?? '').toString(),
              price: priceValue,
              imageUrl: data['imageUrl'] as String?,
              category: data['category'] as String?,
              brand: data['brand'] as String?,
              outfitType: data['outfitType'] as String?,
              gender: data['gender'] as String?,
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
    // Ana dokümanı oluştur (eğer yoksa)
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    
    // Subcollection'a ekle
    await _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(p.id)
        .set({
      'title': p.title,
      'description': p.description,
      'price': p.price,
      'imageUrl': p.imageUrl,
      'category': p.category,
      'brand': p.brand,
      'outfitType': p.outfitType,
      'gender': p.gender,
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

  

  /// Dislike edilen ürünleri realtime stream olarak döndürür
  Stream<List<Product>> streamDislikedProducts(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('dislikes')
        // orderBy kaldırıldı - index sorunu olabilir
        .snapshots()
        .map((snap) {
          return snap.docs.map((d) {
            final data = d.data();
            // Backward compatibility: Eski minPrice/maxPrice varsa price'a çevir
            double? priceValue;
            if (data['price'] != null) {
              priceValue = (data['price'] as num).toDouble();
            } else if (data['minPrice'] != null) {
              priceValue = (data['minPrice'] as num).toDouble();
            } else if (data['maxPrice'] != null) {
              priceValue = (data['maxPrice'] as num).toDouble();
            }
            return Product(
              id: d.id,
              title: data['title']?.toString() ?? '',
              description: data['description']?.toString() ?? '',
              price: priceValue,
              imageUrl: data['imageUrl'] as String?,
              category: data['category'] as String?,
              brand: data['brand'] as String?,
              outfitType: data['outfitType'] as String?,
              gender: data['gender'] as String?,
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
    // Ana dokümanı oluştur (eğer yoksa)
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    
    // Subcollection'a ekle
    await _db
        .collection('users')
        .doc(uid)
        .collection('dislikes')
        .doc(p.id)
        .set({
      'title': p.title,
      'description': p.description,
      'price': p.price,
      'imageUrl': p.imageUrl,
      'category': p.category,
      'brand': p.brand,
      'outfitType': p.outfitType,
      'gender': p.gender,
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

  /// Swipe için filtreleme: Admin ürünleri - Likes - Dislikes
  Stream<List<Product>> streamSwipeableAdminProducts(String uid) {
    // Admin ürünleri stream'i
    final adminProductsStream = _db
        .collection('products')
        .where('isAdminProduct', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Product.fromFirestore(d)).toList());
    
    // Favoriler stream'i
    final favoritesStream = _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.id).toSet());
    
    // Dislikes stream'i
    final dislikesStream = _db
        .collection('users')
        .doc(uid)
        .collection('dislikes')
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.id).toSet());
    
    // Combine streams using StreamController
    final controller = StreamController<List<Product>>();
    Set<String> favoriteIds = {};
    Set<String> dislikeIds = {};
    List<Product> adminProducts = [];
    bool favoritesReady = false;
    bool dislikesReady = false;
    bool productsReady = false;
    
    void emitIfReady() {
      if (favoritesReady && dislikesReady && productsReady) {
        // Admin ürünlerinden likes ve dislikes'ta olanları çıkar
        final filtered = adminProducts
            .where((p) => !favoriteIds.contains(p.id) && !dislikeIds.contains(p.id))
            .toList();
        if (!controller.isClosed) {
          controller.add(filtered);
        }
      }
    }
    
    // Listen to favorites
    favoritesStream.listen((ids) {
      favoriteIds = ids;
      favoritesReady = true;
      emitIfReady();
    });
    
    // Listen to dislikes
    dislikesStream.listen((ids) {
      dislikeIds = ids;
      dislikesReady = true;
      emitIfReady();
    });
    
    // Listen to admin products
    adminProductsStream.listen((products) {
      adminProducts = products;
      productsReady = true;
      emitIfReady();
    });
    
    return controller.stream;
  }

  /// Kullanıcının beğendiği ürünleri kategori ve gender'a göre filtrele (Category Menu için)
  Stream<List<Product>> streamFavoriteProductsByCategory(String uid, String? category, String? gender) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .snapshots()
        .map((snap) {
          return snap.docs.map((d) {
            final data = d.data();
            // Backward compatibility: Eski minPrice/maxPrice varsa price'a çevir
            double? priceValue;
            if (data['price'] != null) {
              priceValue = (data['price'] as num).toDouble();
            } else if (data['minPrice'] != null) {
              priceValue = (data['minPrice'] as num).toDouble();
            } else if (data['maxPrice'] != null) {
              priceValue = (data['maxPrice'] as num).toDouble();
            }
            
            return Product(
              id: d.id,
              title: (data['title'] ?? '').toString(),
              description: (data['description'] ?? '').toString(),
              price: priceValue,
              imageUrl: data['imageUrl'] as String?,
              category: data['category'] as String?,
              brand: data['brand'] as String?,
              outfitType: data['outfitType'] as String?,
              gender: data['gender'] as String?,
              createdBy: (data['createdBy'] ?? '').toString(),
              createdAt: data['createdAt'] is Timestamp
                  ? data['createdAt'] as Timestamp
                  : Timestamp.now(),
            );
          }).where((product) {
            // Category filtresi
            if (category != null && category.isNotEmpty) {
              if (product.category != category) return false;
            }
            // Gender filtresi
            if (gender != null && gender.isNotEmpty) {
              if (product.gender != gender) return false;
            }
            return true;
          }).toList();
        });
  }



  /// Cart'taki ürünleri realtime stream olarak döndürür
  Stream<List<Product>> streamCartProducts(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('cart')
        .snapshots()
        .map((snap) {
          return snap.docs.map((d) {
            final data = d.data();
            // Backward compatibility: Eski minPrice/maxPrice varsa price'a çevir
            double? priceValue;
            if (data['price'] != null) {
              priceValue = (data['price'] as num).toDouble();
            } else if (data['minPrice'] != null) {
              priceValue = (data['minPrice'] as num).toDouble();
            } else if (data['maxPrice'] != null) {
              priceValue = (data['maxPrice'] as num).toDouble();
            }
            return Product(
              id: d.id,
              title: (data['title'] ?? '').toString(),
              description: (data['description'] ?? '').toString(),
              price: priceValue,
              imageUrl: data['imageUrl'] as String?,
              category: data['category'] as String?,
              brand: data['brand'] as String?,
              outfitType: data['outfitType'] as String?,
              gender: data['gender'] as String?,
              createdBy: (data['createdBy'] ?? '').toString(),
              createdAt: data['createdAt'] is Timestamp
                  ? data['createdAt'] as Timestamp
                  : Timestamp.now(),
            );
          }).toList();
        });
  }

  /// Cart'a ekle (doc id = productId)
  Future<void> addToCart(String uid, Product p) async {
    // Ana dokümanı oluştur (eğer yoksa)
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    
    // Subcollection'a ekle
    await _db
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(p.id)
        .set({
      'title': p.title,
      'description': p.description,
      'price': p.price,
      'imageUrl': p.imageUrl,
      'category': p.category,
      'brand': p.brand,
      'outfitType': p.outfitType,
      'gender': p.gender,
      'createdBy': p.createdBy,
      'createdAt': p.createdAt,
      'addedAt': Timestamp.now(),
    });
  }

  /// Cart'tan çıkar
  Future<void> removeFromCart(String uid, String productId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(productId)
        .delete();
  }
}
