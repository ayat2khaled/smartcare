import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardsProvider extends ChangeNotifier {
  static const String _pointsKey = 'reward_points_new';
  int _points = 0;

  int get points => _points;

  RewardsProvider() {
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    _points = prefs.getInt(_pointsKey) ?? 0;
    notifyListeners();
  }

  Future<void> addPoints(int amount) async {
    _points += amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pointsKey, _points);
    notifyListeners();
  }

  Future<void> deductPoints(int amount) async {
    _points = (_points - amount).clamp(0, _points);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pointsKey, _points);
    notifyListeners();
  }
}
