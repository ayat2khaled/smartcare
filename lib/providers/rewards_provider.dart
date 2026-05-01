import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardsProvider extends ChangeNotifier {
  static const String _pointsPrefix = 'reward_points_';
  int _points = 0;
  String _userEmail = '';

  int get points => _points;

  /// Load points for a specific user — called on login/signup
  Future<void> loadForUser(String email) async {
    _userEmail = email.toLowerCase();
    final prefs = await SharedPreferences.getInstance();
    _points = prefs.getInt('$_pointsPrefix$_userEmail') ?? 0;
    notifyListeners();
  }

  /// Clear in-memory data on logout (points stay saved on disk)
  void clearUserData() {
    _points = 0;
    _userEmail = '';
    notifyListeners();
  }

  Future<void> addPoints(int amount) async {
    _points += amount;
    await _save();
    notifyListeners();
  }

  Future<void> deductPoints(int amount) async {
    _points = (_points - amount).clamp(0, _points);
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    if (_userEmail.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_pointsPrefix$_userEmail', _points);
  }
}
