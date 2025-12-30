import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../lib/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final db = FirebaseFirestore.instance;
  
  // ⚠️ IMPORTANT: Add your Admin UID here
  // Firebase Console → Authentication → Users → Copy any user's UID (or create a new user)
  final adminUid = 'xRVEsksBveVszeHu3XqxEHt1Y4w2';
  
  final sampleProducts = [
    {
      'title': 'Classic White Shirt',
      'description': 'Ideal classic white shirt for work and daily use. 100% cotton, easy to iron.',
      'price': 299.0,
      'imageUrl': 'https://images.unsplash.com/photo-1594938291221-94f18a24494c?w=800',
      'category': 'TOP | BODY',
      'brand': 'Zara',
      'outfitType': 'Business Casual',
      'gender': 'Woman',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
    {
      'title': 'Black Leather Jacket',
      'description': 'Stylish and modern black leather jacket. Suitable for all seasons, durable material.',
      'price': 1299.0,
      'imageUrl': 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800',
      'category': 'JACKETS',
      'brand': 'Massimo Dutti',
      'outfitType': 'Casual',
      'gender': 'Woman',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
    {
      'title': 'Blue Denim Jeans',
      'description': 'Classic blue denim jeans. Comfortable fit, flexible fabric. Ideal for daily wear.',
      'price': 499.0,
      'imageUrl': 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800',
      'category': 'JEANS',
      'brand': 'Pull&Bear',
      'outfitType': 'Casual',
      'gender': 'Woman',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
    {
      'title': 'Black Dress',
      'description': 'Elegant black dress. Perfect for parties and special occasions. Accentuates body lines.',
      'price': 599.0,
      'imageUrl': 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800',
      'category': 'DRESS',
      'brand': 'Zara',
      'outfitType': 'Party',
      'gender': 'Woman',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
    {
      'title': 'Gray Blazer',
      'description': 'Professional gray blazer. Perfect for business meetings and formal events.',
      'price': 799.0,
      'imageUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
      'category': 'BLAZERS',
      'brand': 'Massimo Dutti',
      'outfitType': 'Formal',
      'gender': 'Woman',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
    {
      'title': 'White T-Shirt',
      'description': 'Essential white t-shirt. A classic piece that should be in every wardrobe. 100% cotton.',
      'price': 149.0,
      'imageUrl': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800',
      'category': 'T-SHIRTS',
      'brand': 'Pull&Bear',
      'outfitType': 'Casual',
      'gender': 'Woman',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
    {
      'title': 'Brown Trench Coat',
      'description': 'Classic brown trench coat. Ideal for rainy days, stylish and functional.',
      'price': 1499.0,
      'imageUrl': 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800',
      'category': 'COATS | TRENCH COATS',
      'brand': 'Massimo Dutti',
      'outfitType': 'Business Casual',
      'gender': 'Woman',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
    {
      'title': 'Black Trousers',
      'description': 'Classic black trousers. Versatile for work and daily use. Comfortable fit.',
      'price': 399.0,
      'imageUrl': 'https://images.unsplash.com/photo-1503341504253-dff4815485f1?w=800',
      'category': 'TROUSERS',
      'brand': 'Zara',
      'outfitType': 'Business Casual',
      'gender': 'Woman',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
    {
      'title': 'Knit Sweater',
      'description': 'Warm and soft knit sweater. Ideal for winter months. Comfortable and stylish.',
      'price': 349.0,
      'imageUrl': 'https://images.unsplash.com/photo-1552374196-c4e7ffc6e126?w=800',
      'category': 'KNITWEAR',
      'brand': 'Bershka',
      'outfitType': 'Casual',
      'gender': 'Woman',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
    {
      'title': 'School Backpack',
      'description': 'Practical and stylish school backpack. Spacious compartments, durable material.',
      'price': 199.0,
      'imageUrl': 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800',
      'category': 'BAGS',
      'brand': 'Stradivarius',
      'outfitType': 'School Outfit',
      'gender': 'Woman',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
    {
      'title': 'Men\'s Dress Shirt',
      'description': 'Classic men\'s dress shirt. Ideal for work and daily use. Easy to iron.',
      'price': 349.0,
      'imageUrl': 'https://images.unsplash.com/photo-1603252109303-2751441dd157?w=800',
      'category': 'TOP | BODY',
      'brand': 'Zara',
      'outfitType': 'Business Casual',
      'gender': 'Man',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
    {
      'title': 'Men\'s Leather Jacket',
      'description': 'Stylish men\'s leather jacket. Classic design, durable material.',
      'price': 1499.0,
      'imageUrl': 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800',
      'category': 'JACKETS',
      'brand': 'Massimo Dutti',
      'outfitType': 'Casual',
      'gender': 'Man',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
    {
      'title': 'Men\'s Jeans',
      'description': 'Classic men\'s jeans. Comfortable fit, flexible fabric. Ideal for daily wear.',
      'price': 449.0,
      'imageUrl': 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800',
      'category': 'JEANS',
      'brand': 'Pull&Bear',
      'outfitType': 'Casual',
      'gender': 'Man',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
    {
      'title': 'Men\'s Suit',
      'description': 'Professional men\'s suit. Perfect for business meetings and formal events.',
      'price': 1999.0,
      'imageUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
      'category': 'BLAZERS',
      'brand': 'Massimo Dutti',
      'outfitType': 'Formal',
      'gender': 'Man',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
    {
      'title': 'Men\'s T-Shirt',
      'description': 'Essential men\'s t-shirt. A classic piece that should be in every wardrobe.',
      'price': 129.0,
      'imageUrl': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800',
      'category': 'T-SHIRTS',
      'brand': 'Pull&Bear',
      'outfitType': 'Casual',
      'gender': 'Man',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
    {
      'title': 'Men\'s Trousers',
      'description': 'Classic men\'s trousers. Versatile for work and daily use.',
      'price': 399.0,
      'imageUrl': 'https://images.unsplash.com/photo-1503341504253-dff4815485f1?w=800',
      'category': 'TROUSERS',
      'brand': 'Zara',
      'outfitType': 'Business Casual',
      'gender': 'Man',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
    {
      'title': 'Children\'s Dress',
      'description': 'Cute children\'s dress. Colorful and fun design. Comfortable fabric.',
      'price': 199.0,
      'imageUrl': 'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=800',
      'category': 'DRESS',
      'brand': 'Stradivarius',
      'outfitType': 'Casual',
      'gender': 'Children',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
    {
      'title': 'Children\'s T-Shirt',
      'description': 'Colorful children\'s t-shirt. Soft fabric, comfortable fit.',
      'price': 99.0,
      'imageUrl': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800',
      'category': 'T-SHIRTS',
      'brand': 'Pull&Bear',
      'outfitType': 'Casual',
      'gender': 'Children',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
    {
      'title': 'Children\'s Jeans',
      'description': 'Durable children\'s jeans. Ideal for playing, flexible fabric.',
      'price': 249.0,
      'imageUrl': 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800',
      'category': 'JEANS',
      'brand': 'Bershka',
      'outfitType': 'Casual',
      'gender': 'Children',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
    {
      'title': 'Children\'s Sweatshirt',
      'description': 'Warm children\'s sweatshirt. Ideal for winter months, soft and comfortable.',
      'price': 199.0,
      'imageUrl': 'https://images.unsplash.com/photo-1552374196-c4e7ffc6e126?w=800',
      'category': 'SWEATSHIRTS',
      'brand': 'Stradivarius',
      'outfitType': 'Casual',
      'gender': 'Children',
      'isAdminProduct': true,
      'createdBy': adminUid,
      'createdAt': Timestamp.now(),
    },
  ];
  
  print('📦 Adding ${sampleProducts.length} products...');
  print('⚠️  Admin UID: $adminUid');
  print('');
  
  if (adminUid == 'YOUR_ADMIN_UID_HERE') {
    print('❌ ERROR: Please update adminUid in the script!');
    print('   Firebase Console → Authentication → Users → Copy any user UID');
    return;
  }
  
  int successCount = 0;
  int failCount = 0;
  
  for (var i = 0; i < sampleProducts.length; i++) {
    try {
      await db.collection('products').add(sampleProducts[i]);
      successCount++;
      print('✅ [${i+1}/${sampleProducts.length}] ${sampleProducts[i]['title']} added');
    } catch (e) {
      failCount++;
      print('❌ [${i+1}/${sampleProducts.length}] ${sampleProducts[i]['title']} failed: $e');
    }
  }
  
  print('');
  print('🎉 Process completed!');
  print('✅ Successful: $successCount');
  print('❌ Failed: $failCount');
  
  if (failCount > 0) {
    print('');
    print('⚠️  Note: If you see index errors, create a composite index in Firestore:');
    print('   Collection: products');
    print('   Fields: isAdminProduct (Ascending), createdAt (Descending)');
  }
}

