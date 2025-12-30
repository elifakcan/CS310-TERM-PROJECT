import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:styleswipe/models/product.dart';

void main() {
  group('Product Model Tests', () {
    test('Product.fromFirestore should parse JSON correctly', () {
      // Mock Firestore document data
      final mockData = {
        'title': 'Test Product',
        'description': 'Test Description',
        'price': 99.99,
        'imageUrl': 'https://example.com/image.jpg',
        'category': 'DRESS',
        'gender': 'Woman',
        'isAdminProduct': true,
        'createdBy': 'testUserId',
        'createdAt': Timestamp.now(),
      };

      // Create a mock DocumentSnapshot
      final mockDoc = MockDocumentSnapshot(mockData, 'product123');

      // Test parsing
      final product = Product.fromFirestore(mockDoc);

      expect(product.id, 'product123');
      expect(product.title, 'Test Product');
      expect(product.description, 'Test Description');
      expect(product.price, 99.99);
      expect(product.imageUrl, 'https://example.com/image.jpg');
      expect(product.category, 'DRESS');
      expect(product.gender, 'Woman');
      expect(product.isAdminProduct, true);
      expect(product.createdBy, 'testUserId');
    });

    test('Product.toMap should convert to map correctly', () {
      final product = Product(
        id: 'test123',
        title: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        imageUrl: 'https://example.com/image.jpg',
        category: 'DRESS',
        gender: 'Woman',
        isAdminProduct: true,
        createdBy: 'testUserId',
        createdAt: Timestamp.now(),
      );

      final map = product.toMap();

      expect(map['title'], 'Test Product');
      expect(map['description'], 'Test Description');
      expect(map['price'], 99.99);
      expect(map['imageUrl'], 'https://example.com/image.jpg');
      expect(map['category'], 'DRESS');
      expect(map['gender'], 'Woman');
      expect(map['isAdminProduct'], true);
      expect(map['createdBy'], 'testUserId');
    });

    test('Product should handle backward compatibility for price', () {
      final mockData = {
        'title': 'Old Product',
        'description': 'Old Description',
        'minPrice': 50.0, // Eski format
        'createdBy': 'testUserId',
        'createdAt': Timestamp.now(),
      };

      final mockDoc = MockDocumentSnapshot(mockData, 'old123');
      final product = Product.fromFirestore(mockDoc);

      // minPrice kullanılmalı (backward compatibility)
      expect(product.price, 50.0);
    });
  });
}

// Mock DocumentSnapshot helper class
class MockDocumentSnapshot implements DocumentSnapshot {
  final Map<String, dynamic> _data;
  final String _id;

  MockDocumentSnapshot(this._data, this._id);

  @override
  String get id => _id;

  @override
  Map<String, dynamic>? data() => _data;

  @override
  dynamic get(Object field) => _data[field.toString()];

  @override
  dynamic operator [](Object field) => _data[field.toString()];

  @override
  bool get exists => true;

  @override
  DocumentReference get reference => throw UnimplementedError();

  @override
  SnapshotMetadata get metadata => throw UnimplementedError();
}

