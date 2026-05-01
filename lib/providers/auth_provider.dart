import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  static const String _usersKey = 'registered_users';
  static const String _loggedInKey = 'is_logged_in';
  static const String _currentUserKey = 'current_user_email';

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

  /// Initialize — call once at app startup
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_loggedInKey) ?? false;
    _hasRegisteredUsers = (prefs.getStringList(_usersKey) ?? []).isNotEmpty;

    if (_isLoggedIn) {
      final email = prefs.getString(_currentUserKey) ?? '';
      final userData = _getUserByEmail(await _getAllUsers(prefs), email);
      if (userData != null) {
        _userName = userData['name'] ?? '';
        _userEmail = userData['email'] ?? '';
      } else {
        // Stored session is stale, reset
        _isLoggedIn = false;
        await prefs.setBool(_loggedInKey, false);
      }
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
    // Validation
    if (name.trim().isEmpty) return 'Please enter your full name';
    if (email.trim().isEmpty) return 'Please enter your email';
    if (!_isValidEmail(email)) return 'Please enter a valid email';
    if (password.isEmpty) return 'Please enter a password';
    if (password.length < 6) return 'Password must be at least 6 characters';
    if (password != confirmPassword) return 'Passwords do not match';

    final prefs = await SharedPreferences.getInstance();
    final users = await _getAllUsers(prefs);

    // Check if email already exists
    if (_getUserByEmail(users, email.trim()) != null) {
      return 'An account with this email already exists';
    }

    // Save new user
    final newUser = jsonEncode({
      'name': name.trim(),
      'email': email.trim().toLowerCase(),
      'password': password,
    });
    users.add(newUser);
    await prefs.setStringList(_usersKey, users);

    // Auto-login after sign up
    _userName = name.trim();
    _userEmail = email.trim().toLowerCase();
    _isLoggedIn = true;
    _hasRegisteredUsers = true;
    await prefs.setBool(_loggedInKey, true);
    await prefs.setString(_currentUserKey, _userEmail);
    notifyListeners();

    return null; // success
  }

  /// Sign in with email & password, returns error message or null on success
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty) return 'Please enter your email';
    if (password.isEmpty) return 'Please enter your password';

    final prefs = await SharedPreferences.getInstance();
    final users = await _getAllUsers(prefs);
    final userData = _getUserByEmail(users, email.trim());

    if (userData == null) {
      return 'No account found with this email';
    }
    if (userData['password'] != password) {
      return 'Invalid password';
    }

    // Success
    _userName = userData['name'] ?? '';
    _userEmail = userData['email'] ?? '';
    _isLoggedIn = true;
    await prefs.setBool(_loggedInKey, true);
    await prefs.setString(_currentUserKey, _userEmail);
    notifyListeners();

    return null; // success
  }

  /// Log out — clears session but keeps registered users
  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';
    await prefs.setBool(_loggedInKey, false);
    await prefs.remove(_currentUserKey);
    notifyListeners();
  }

  // ── Helpers ──

  Future<List<String>> _getAllUsers(SharedPreferences prefs) async {
    return prefs.getStringList(_usersKey) ?? [];
  }

  Map<String, dynamic>? _getUserByEmail(List<String> users, String email) {
    for (final userJson in users) {
      final user = jsonDecode(userJson) as Map<String, dynamic>;
      if ((user['email'] as String).toLowerCase() == email.toLowerCase()) {
        return user;
      }
    }
    return null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$')
        .hasMatch(email.trim());
  }
}
