import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  static const String _userNameKey = 'user_display_name';

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool _isLoggedIn = false;
  bool _isInitialized = false;
  String _userName = '';
  String _userEmail = '';

  bool get isLoggedIn => _isLoggedIn;
  bool get isInitialized => _isInitialized;
  String get userName => _userName;
  String get userEmail => _userEmail;

  /// Check if any user has ever registered on this device
  bool _hasRegisteredUsers = false;
  bool get hasRegisteredUsers => _hasRegisteredUsers;

  /// The current Firebase user
  User? get firebaseUser => _firebaseAuth.currentUser;

  /// Initialize — call once at app startup
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUser = _firebaseAuth.currentUser;

    if (currentUser != null) {
      // User is signed in via Firebase
      _isLoggedIn = true;
      _userEmail = currentUser.email ?? '';
      // Try to get display name from Firebase, fall back to SharedPreferences
      _userName = currentUser.displayName ?? 
                  prefs.getString('${_userNameKey}_$_userEmail') ?? '';
      _hasRegisteredUsers = true;
    } else {
      _isLoggedIn = false;
      // Check if anyone has ever logged in on this device
      _hasRegisteredUsers = prefs.getBool('has_registered_users') ?? false;
    }

    _isInitialized = true;
    notifyListeners();
  }

  /// Register a new user, returns error message or null on success
  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Local validation
    if (name.trim().isEmpty) return 'Please enter your full name';
    if (email.trim().isEmpty) return 'Please enter your email';
    if (!_isValidEmail(email)) return 'Please enter a valid email';
    if (password.isEmpty) return 'Please enter a password';
    if (password.length < 6) return 'Password must be at least 6 characters';
    if (password != confirmPassword) return 'Passwords do not match';

    try {
      // Create user in Firebase
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );

      // Set display name
      await credential.user?.updateDisplayName(name.trim());

      // Store name locally as backup
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          '${_userNameKey}_${email.trim().toLowerCase()}', name.trim());
      await prefs.setBool('has_registered_users', true);

      // Update state
      _userName = name.trim();
      _userEmail = email.trim().toLowerCase();
      _isLoggedIn = true;
      _hasRegisteredUsers = true;
      notifyListeners();

      return null; // success
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseError(e.code);
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Sign in with email & password, returns error message or null on success
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty) return 'Please enter your email';
    if (password.isEmpty) return 'Please enter your password';

    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );

      final user = credential.user;
      final prefs = await SharedPreferences.getInstance();

      // Get name from Firebase or local storage
      _userName = user?.displayName ??
                  prefs.getString('${_userNameKey}_${email.trim().toLowerCase()}') ??
                  '';
      _userEmail = user?.email ?? email.trim().toLowerCase();
      _isLoggedIn = true;
      notifyListeners();

      return null; // success
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseError(e.code);
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Log out — signs out from Firebase
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';
    notifyListeners();
  }

  // ── Helpers ──

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$')
        .hasMatch(email.trim());
  }

  /// Map Firebase error codes to user-friendly messages
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'An account with this email already exists';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Invalid password';
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
