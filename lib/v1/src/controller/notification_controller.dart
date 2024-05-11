import 'package:ebbot_dart_client/entities/notifications/notification.dart'
    as EbbotDartClientNotification;
import 'package:ebbot_flutter_ui/v1/src/service/notification_service.dart';
import 'package:flutter/material.dart';

class NotificationController {
  final NotificationService _notificationService;
  final Function(String title, String text) _handleNotification;
  NotificationController(this._notificationService, this._handleNotification) {
    _processNotifications();
  }

  void _processNotifications() {
    for (var notification in _notificationService.getNotifications()) {
      _handleNotification(notification.title, notification.text);
    }
  }
}
