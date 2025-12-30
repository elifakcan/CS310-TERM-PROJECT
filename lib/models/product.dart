import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double? price;
  final String? imageUrl;
  final String? category; // e.g., 'DRESS', 'JACKETS', 'JEANS'
  final String? brand; // e.g., 'Zara', 'Massimo Dutti', 'Pull&Bear'
  final String? outfitType; // e.g., 'Business Casual', 'Casual', 'Formal', 'School Outfit', 'Party'
  final String? gender; // 'Woman', 'Man', 'Children'
  final bool? isAdminProduct; // Admin ürünleri için (swipe için)
  final String createdBy;
  final Timestamp createdAt;

  Product({
    required this.id,
    required this.title,
    required this.description,
    this.price,
    this.imageUrl,
    this.category,
    this.brand,
    this.outfitType,
    this.gender,
    this.isAdminProduct,
    required this.createdBy,
    required this.createdAt,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

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
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: priceValue,
      imageUrl: data['imageUrl'] as String?,
      category: data['category'] as String?,
      brand: data['brand'] as String?,
      outfitType: data['outfitType'] as String?,
      gender: data['gender'] as String?,
      isAdminProduct: data['isAdminProduct'] as bool? ?? false,
      createdBy: data['createdBy'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'description': description,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
    if (price != null) map['price'] = price;
    if (imageUrl != null) map['imageUrl'] = imageUrl;
    if (category != null) map['category'] = category;
    if (brand != null) map['brand'] = brand;
    if (outfitType != null) map['outfitType'] = outfitType;
    if (gender != null) map['gender'] = gender;
    if (isAdminProduct != null) map['isAdminProduct'] = isAdminProduct;
    return map;
  }

  // Helper method for CartProvider compatibility
  double get priceValue => price ?? 0.0;
  
  // Helper method for CartProvider compatibility
  String get name => title;
}
