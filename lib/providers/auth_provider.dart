import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;
  bool get isLoggedIn => user != null;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  AuthProvider() {
    // Auth değişince tüm uygulama haberdar olsun
    _auth.authStateChanges().listen((_) {
      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Sign up failed";
      switch (e.code) {
        case 'weak-password':
          errorMessage = "Password too weak";
          break;
        case 'email-already-in-use':
          errorMessage = "Email already in use";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email";
          break;
        case 'operation-not-allowed':
          errorMessage = "Sign-up not enabled";
          break;
        default:
          errorMessage = "Sign up failed";
      }
      _setError(errorMessage);
    } catch (e) {
      _setError("Sign up failed");
    }
    _setLoading(false);
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      // Debug: Print error code and message
      debugPrint('Firebase Auth Error Code: ${e.code}');
      debugPrint('Firebase Auth Error Message: ${e.message}');
      
      // Önce hata mesajını kontrol et - eğer password ile ilgiliyse "Wrong password" göster
      final message = e.message?.toLowerCase() ?? '';
      if (message.contains('password') || message.contains('wrong') || 
          message.contains('invalid credential') || message.contains('invalid-credential')) {
        errorMessage = "Wrong password";
      } else {
        // Hata mesajı password ile ilgili değilse, error code'a göre belirle
        switch (e.code) {
          case 'user-not-found':
            errorMessage = "No user found with this email";
            break;
          case 'wrong-password':
          case 'invalid-credential':
            errorMessage = "Wrong password";
            break;
          case 'invalid-email':
            errorMessage = "Invalid email";
            break;
          case 'user-disabled':
            errorMessage = "Account disabled";
            break;
          case 'too-many-requests':
            errorMessage = "Too many attempts. Try again later";
            break;
          case 'operation-not-allowed':
            errorMessage = "Sign-in not enabled";
            break;
          default:
            errorMessage = e.message ?? "Login failed";
        }
      }
      _setError(errorMessage);
    } catch (e) {
      debugPrint('Login catch error: $e');
      _setError("Login failed");
    }
    _setLoading(false);
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        _setError("User not logged in");
        _setLoading(false);
        return;
      }

      // Re-authenticate with old password
      try {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );
        await user.reauthenticateWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        String errorMessage = "Re-authentication failed";
        switch (e.code) {
          case 'wrong-password':
            errorMessage = "Wrong password";
            break;
          case 'invalid-credential':
            errorMessage = "Invalid password";
            break;
          case 'user-mismatch':
            errorMessage = "User mismatch";
            break;
          case 'user-not-found':
            errorMessage = "User not found";
            break;
          default:
            errorMessage = e.message ?? "Re-authentication failed: ${e.code}";
        }
        _setError(errorMessage);
        _setLoading(false);
        return;
      } catch (e) {
        _setError("Re-authentication failed: ${e.toString()}");
        _setLoading(false);
        return;
      }

      // Update password
      try {
        await user.updatePassword(newPassword);
        
        // Verify password was updated by checking if operation completed without error
        // After password update, user needs to re-login
        // We'll logout the user automatically to force re-login with new password
        
        _setError(null); // Success - clear any previous error
        
        // Logout user after successful password change to force re-login
        await _auth.signOut();
        
      } on FirebaseAuthException catch (e) {
        String errorMessage = "Password update failed";
        switch (e.code) {
          case 'weak-password':
            errorMessage = "Password too weak";
            break;
          case 'requires-recent-login':
            errorMessage = "Please login again";
            break;
          default:
            errorMessage = e.message ?? "Password update failed: ${e.code}";
        }
        _setError(errorMessage);
      } catch (e) {
        _setError("Password update failed: ${e.toString()}");
      }
    } catch (e) {
      _setError("Unexpected error: ${e.toString()}");
    }
    
    _setLoading(false);
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  void _setError(String? msg) {
    _error = msg;
    notifyListeners();
  }
}
