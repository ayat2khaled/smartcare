import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_project/models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  String? _currentUserEmail;

  List<NotificationModel> get notifications => [..._notifications];

  int get newCount => _notifications.length;

  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    _saveToPrefs();
    notifyListeners();
  }

  Future<void> loadForUser(String email) async {
    _currentUserEmail = email;
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('notifications_$email');
    if (jsonString != null && jsonString.isNotEmpty) {
      final List<dynamic> decodedList = json.decode(jsonString);
      _notifications = decodedList
          .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      _notifications = [];
    }
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    if (_currentUserEmail == null) return;
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList =
        _notifications.map((n) => n.toJson()).toList();
    await prefs.setString('notifications_$_currentUserEmail', json.encode(jsonList));
  }

  void clearUserData() {
    _notifications.clear();
    _currentUserEmail = null;
    notifyListeners();
  }
}
