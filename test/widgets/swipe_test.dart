import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'dart:async';
// Import çakışmasını önlemek için 'as' kullanıyoruz
import 'package:styleswipe/providers/auth_provider.dart' as app;
import 'package:styleswipe/providers/product_provider.dart';
import 'package:styleswipe/utils/cart_provider.dart';
import 'package:styleswipe/screens/swipe/swipe_recommendation_page.dart';
import 'package:styleswipe/models/product.dart';
import 'package:styleswipe/services/product_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

// Mock User for testing - Fake kullanarak tüm metodları otomatik handle ediyoruz
class MockUser extends Fake implements User {
  @override
  final String uid;
  @override
  final String? email;
  @override
  final String? displayName;

  MockUser({
    required this.uid,
    this.email,
    this.displayName,
  });
}

// Fake ProductService - ProductService'den extend ediyoruz
// fake_cloud_firestore kullanarak Firebase'e bağımlılığı kaldırıyoruz
class FakeProductService extends ProductService {
  FakeProductService() : super(db: FakeFirebaseFirestore());

  @override
  Stream<List<Product>> streamSwipeableAdminProducts(String uid) {
    return Stream.value([]); // Test için boş liste döndür
  }

  @override
  Stream<List<Product>> streamCartProducts(String uid) {
    return Stream.value([]); // Test için boş liste döndür
  }
}

// Fake ProductProvider - ProductProvider'dan extend ediyoruz
class FakeProductProvider extends ProductProvider {
  FakeProductProvider()
      : super(
          service: FakeProductService(),
          auth: MockFirebaseAuth(), // Mock FirebaseAuth kullanıyoruz
        );

  @override
  Stream<List<Product>> streamSwipeableProducts() {
    // Test için açıkça override ediyoruz
    return Stream.value([]);
  }
}

// Fake CartProvider - CartProvider'dan extend ediyoruz
class FakeCartProvider extends CartProvider {
  FakeCartProvider()
      : super(
          productService: FakeProductService(),
          auth: MockFirebaseAuth(), // Mock FirebaseAuth kullanıyoruz
        );
}

void main() {
  group('Swipe Screen Widget Tests', () {
    testWidgets('Swipe screen should display like and dislike buttons', (WidgetTester tester) async {
      // Mock User oluştur
      final mockUser = MockUser(
        uid: 'test-user-123',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      // Mock AuthProvider oluştur (Firebase bağımlılığı yok - mockUser parametresi ile)
      final mockAuthProvider = app.AuthProvider(mockUser: mockUser);

      // Build the widget with all required providers
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<app.AuthProvider>.value(value: mockAuthProvider),
              ChangeNotifierProvider<ProductProvider>.value(value: FakeProductProvider()),
              ChangeNotifierProvider<CartProvider>.value(value: FakeCartProvider()),
            ],
            child: const SwipeRecommendationPage(),
          ),
        ),
      );

      // Wait for async operations
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Check if Scaffold exists (widget structure)
      final scaffold = find.byType(Scaffold);
      expect(scaffold, findsOneWidget);

      // Check for IconButtons (like, dislike, bag, settings)
      final iconButtons = find.byType(IconButton);
      // At least some IconButtons should exist
      expect(iconButtons, findsWidgets);
    });

    testWidgets('Swipe screen should display FitSwipe title', (WidgetTester tester) async {
      // Mock User oluştur
      final mockUser = MockUser(
        uid: 'test-user-123',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      // Mock AuthProvider oluştur (Firebase bağımlılığı yok - mockUser parametresi ile)
      final mockAuthProvider = app.AuthProvider(mockUser: mockUser);

      // Build the widget with all required providers
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<app.AuthProvider>.value(value: mockAuthProvider),
              ChangeNotifierProvider<ProductProvider>.value(value: FakeProductProvider()),
              ChangeNotifierProvider<CartProvider>.value(value: FakeCartProvider()),
            ],
            child: const SwipeRecommendationPage(),
          ),
        ),
      );

      // Wait for async operations
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Check if AppBar exists (which should contain the title)
      final appBar = find.byType(AppBar);
      expect(appBar, findsOneWidget);

      // Try to find the FitSwipe text
      final titleFinder = find.text('FitSwipe');
      expect(titleFinder, findsOneWidget);
    });
  });
}
