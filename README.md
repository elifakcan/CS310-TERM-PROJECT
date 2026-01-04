# FitSwipe - Outfit Recommendation App

**FitSwipe** is a mobile fashion discovery app where users swipe through individual clothing items from different brands.
Users can **swipe right** to like items, swipe **left** to skip them, or add selected pieces to a **shopping bag**, where they can view the total price of the selected items. 
The app offers categories like **Dress**, **Jackets**, **Coats| Trench Coats**, **Blazers**, and **T-Shirts** etc. for men, women and children.


---

## Project Overview & Motivation

FitSwipe was developed as a CS310 Mobile Application Development course project. The app aims to provide users with an intuitive, swaping interface for discovering outfit combinations from popular fashion brands. The motivation behind this project was to create a seamless shopping experience where users can quickly browse and save their favorite outfit combinations.

**Target Audience**: Fashion-conscious individuals looking for outfit inspiration from several brands.

---

## Features

- **User Authentication**: Secure email/password authentication via Firebase Auth with automatic user document creation
- **Swipe-based Discovery**: Swipe through admin-curated outfit recommendations
- **Favorites & Dislikes**: Save liked outfits and track disliked ones with undo functionality
- **Shopping Bag (Add/Remove)**: Products are added to or removed from the shopping bag using a presence-based cart structure without quantity controls.
- **Category Filtering**: Browse favorites by category (DRESS, JACKETS, COATS, SKIRTS, etc.) and gender
- **Real-time Sync**: All data synced with Firebase Firestore in real-time with proper subcollection structure
- **Dark Mode**: Toggle between light and dark themes (persisted with SharedPreferences)
- **Profile Statistics**: View your favorites, dislikes, and bag count in settings
- **Product Details**: View detailed information about each product
- **Scroll Support**: Smooth scrolling on Likes and Dislikes pages for large lists

---

## Tech Stack

- **Flutter**: 3.22+ (SDK: ^3.9.2)
- **Dart**: 3.9.2+
- **Firebase**:
  - Firebase Authentication (Email/Password)
  - Cloud Firestore (Real-time database with subcollections)
- **State Management**: Provider pattern with Dependency Injection support
- **Local Storage**: SharedPreferences (Theme persistence)
- **Testing**: Unit tests and Widget tests with mocking support

---

## Setup & Run Instructions

### Prerequisites

* Flutter SDK **3.22 or higher**
* Android Studio or VS Code (with Flutter extensions)
* Firebase account
* Android emulator or physical device

### Step 1: Clone the Repository

```bash
git clone https://github.com/zeynepbilici/CS310-TERM-PROJECT.git
cd CS310-TERM-PROJECT-main
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Firebase Configuration

* Create a Firebase project from the Firebase Console
* Enable **Email/Password Authentication**
* Enable **Cloud Firestore**
* Download Firebase configuration files:

  * `google-services.json` → `android/app/`
  * `GoogleService-Info.plist` → `ios/Runner/`

### Step 4: Run the Application

```bash
flutter run
```

---

## Testing

### Running Tests
```bash
flutter test
```

### Test Coverage

The project includes the following tests:

1. **Unit Test - Product Model** (`test/models/product_test.dart`):
   - Tests Product model's `fromFirestore` method for correct JSON parsing
   - Tests Product model's `toMap` method for correct map conversion
   - Tests backward compatibility for price fields (minPrice/maxPrice → price)
   - Uses `FakeFirebaseFirestore` and `MockDocumentSnapshot` for isolated testing

2. **Widget Test - Swipe Screen** (`test/widgets/swipe_test.dart`):
   - Verifies that swipe screen displays all required UI elements
   - Tests presence of like button (heart icon)
   - Tests presence of dislike button (close icon)
   - Tests presence of bag button (shopping bag icon)
   - Tests presence of "FitSwipe" title
   - Uses Dependency Injection with `FakeProductService`, `FakeProductProvider`, and `FakeCartProvider` to avoid Firebase initialization

All tests must pass successfully. If any test fails, check:
- All dependencies are installed (`flutter pub get`)
- Test files are properly configured with mocks
- No actual Firebase calls are made during testing

---

## Known Limitations & Bugs

- **None currently**: All features are stable and tested. The app works end-to-end without crashes.

---

## App Structure

```
lib/
├── models/          # Data models (Product)
├── services/        # Firebase services (ProductService)
├── providers/       # State management
│   ├── auth_provider.dart
│   ├── product_provider.dart
│   └── prefs_provider.dart
├── screens/         # UI screens
│   ├── auth_gate.dart
│   ├── welcome/
│   ├── login/
│   ├── signup/
│   ├── swipe/       # Main swipe interface
│   ├── favorites/
│   ├── dislikes/
│   ├── shoppingbag/
│   ├── category_menu/
│   ├── settings/
│   └── productdetail/
├── utils/           # Utilities
│   ├── cart_provider.dart
│   ├── app_colors.dart
│   └── app_text_styles.dart
└── routes/          # Navigation routes

scripts/
├── add_sample_products.dart      # Script to add sample products
└── create_user_documents.dart    # Migration script for user documents

test/
├── models/
│   └── product_test.dart         # Unit test for Product model
└── widgets/
    └── swipe_test.dart           # Widget test for Swipe screen
```

---

## Firebase Security Rules

The app uses Firestore security rules to ensure user data privacy:
- Users can only access their own favorites, dislikes, and cart
- Products are readable by all authenticated users
- Only product creators can modify their products
- Admin products are marked with `isAdminProduct: true` for swipe functionality

See `firestore.rules` for complete rules.

---
tamam 👍 aşağıya **README’ye birebir koyabileceğin, son ve temiz hâlini** atıyorum.
Bu versiyon **Firestore’daki gerçek yapı ile %100 uyumlu**, quantity karmaşası yok, hocaya da net mesaj veriyor.

---

## Firestore Data Structure

```text
users/
  {uid}/
    - uid: string
    - email: string
    - createdAt: timestamp
    - updatedAt: timestamp

    favorites/ (subcollection)
      {productId}/
        - product snapshot data
        - addedAt: timestamp

    dislikes/ (subcollection)
      {productId}/
        - product snapshot data
        - addedAt: timestamp

    cart/ (subcollection)   // shopping bag
      {productId}/
        - product snapshot data
        - addedAt: timestamp
        // Document existence represents cart state 
```

```text
products/
  {productId}/
    - title: string
    - price: number
    - imageUrl: string
    - category: string
    - gender: string
    - description: string
    - createdAt: timestamp
    - createdBy: uid
    - isAdminProduct: boolean
```

---

## Architecture & Design Decisions

* **Provider Pattern** was chosen for scalable and testable state management
* **Firestore subcollections** are used to isolate user-specific data and simplify security rules
* **Cart (Bag) Design** is implemented as a *presence-based structure*:
  a product is considered in the cart if its document exists under
  `users/{uid}/cart/{productId}`.
* **Product snapshot data** is stored in user subcollections (favorites, dislikes, cart)
  to reduce additional reads and improve UI performance.
* **Dark mode persistence** is implemented using SharedPreferences instead of Firestore
  to reduce database read costs.

---

## User Flow

1. User signs up / logs in
2. Lands on Swipe Screen
3. Swipes right/left or adds item to bag
4. Views product details if interested
5. Manages favorites, dislikes and shopping bag
6. Checks profile statistics in settings

---

## Ethical & Privacy Considerations

- No personal data other than email is stored
- All user data is protected with Firestore security rules
- Users can only access their own favorites, dislikes and cart
- No third-party tracking or analytics is used

---

## Team Members

- **Ece Gülkanat (31983)** — Testing & QA Lead
- **Zeynep Bilici (32333)** — Learning & Research Lead
- **Zehra Kanberoğlu (32169)** — Integration & Repository Lead
- **Burhan Berke Çakmak (32197)** — Presentation & Communication Lead
- **Elif Ceren Akcan (32401)** — Documentation & Submission Lead
- **Alper Dilek (32071)** — Project Coordinator

---
