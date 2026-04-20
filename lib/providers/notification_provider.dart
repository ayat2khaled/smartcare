import 'package:flutter/material.dart';
import 'package:first_project/models/notification_model.dart';
import 'package:first_project/utils/top_snackbar.dart';

class NotificationProvider with ChangeNotifier {
  final List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => [..._notifications];

  int get newCount => _notifications.length;

  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    showGlobalTopSnackBar(notification.title);
    notifyListeners();
  }
}
