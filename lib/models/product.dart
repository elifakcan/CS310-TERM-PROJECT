import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double? minPrice;
  final double? maxPrice;
  final String? imageUrl;
  final String createdBy;
  final Timestamp createdAt;

  Product({
    required this.id,
    required this.title,
    required this.description,
    this.minPrice,
    this.maxPrice,
    this.imageUrl,
    required this.createdBy,
    required this.createdAt,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Product(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      minPrice: data['minPrice'] != null
          ? (data['minPrice'] as num).toDouble()
          : null,
      maxPrice: data['maxPrice'] != null
          ? (data['maxPrice'] as num).toDouble()
          : null,
      imageUrl: data['imageUrl'] as String?,
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
    if (minPrice != null) map['minPrice'] = minPrice;
    if (maxPrice != null) map['maxPrice'] = maxPrice;
    if (imageUrl != null) map['imageUrl'] = imageUrl;
    return map;
  }
}
