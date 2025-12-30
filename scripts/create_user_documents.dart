import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../lib/firebase_options.dart';

/// Mevcut kullanıcılar için users/{uid} dokümanlarını oluşturur
/// Bu script, halihazırda sign-up olmuş kullanıcılar için Firestore'da
/// users/{uid} dokümanlarını oluşturur.
/// 
/// Kullanım:
///   dart run scripts/create_user_documents.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  
  print('🔍 Creating user documents in Firestore...');
  print('');
  
  // ============================================================
  // ADIM 1: Firebase Console → Authentication → Users
  //         bölümünden UID'leri kopyalayıp aşağıdaki listeye ekleyin
  // ============================================================
  final userUids = <String>[
    // Firebase Console'dan UID'leri buraya ekleyin
    // Örnek:
    // 'xRVEsksBveVszeHu3XqxEHt1Y4w2',
    // 'abc123def456ghi789',
    // 'xyz789uvw456rst123',
  ];
  
  // ============================================================
  // ADIM 2: Eğer şu an giriş yapmış bir kullanıcı varsa, onu da ekle
  // ============================================================
  final currentUser = auth.currentUser;
  if (currentUser != null && !userUids.contains(currentUser.uid)) {
    userUids.add(currentUser.uid);
    print('📝 Found logged-in user: ${currentUser.email} (${currentUser.uid})');
  }
  
  try {
    if (userUids.isEmpty) {
      print('⚠️  No user UIDs found!');
      print('');
      print('💡 To use this script:');
      print('   1. Go to Firebase Console → Authentication → Users');
      print('   2. Copy all user UIDs');
      print('   3. Add them to the userUids list in this script');
      print('   4. Run the script again: dart run scripts/create_user_documents.dart');
      print('');
      exit(0);
    }
    
    print('📋 Processing ${userUids.length} user(s)...');
    print('');
    
    int successCount = 0;
    int errorCount = 0;
    
    for (final uid in userUids) {
      try {
        // User dokümanını oluştur (eğer yoksa merge ile güncelle)
        await db.collection('users').doc(uid).set({
          'uid': uid,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        
        // Eğer createdAt yoksa ekle
        final doc = await db.collection('users').doc(uid).get();
        if (!doc.exists || doc.data()?['createdAt'] == null) {
          await db.collection('users').doc(uid).update({
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
        
        successCount++;
        print('✅ Created/Updated user document: $uid');
      } catch (e) {
        errorCount++;
        print('❌ Error creating document for $uid: $e');
      }
    }
    
    print('');
    print('📊 Summary:');
    print('   ✅ Success: $successCount');
    if (errorCount > 0) {
      print('   ❌ Errors: $errorCount');
    }
    
    print('');
    print('✨ Migration completed!');
    print('📊 Check Firebase Console → Firestore → users collection');
    
  } catch (e) {
    print('❌ Error: $e');
  }
  
  // Script'i sonlandır
  exit(0);
}

