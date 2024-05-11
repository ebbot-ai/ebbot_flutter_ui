import 'package:ebbot_dart_client/entities/notifications/notification.dart'
    as EbbotDartClientNotification;
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NotificationController {
  late EbbotNotificationService _notificationService;
  final Function(String title, String text) _handleNotification;
  NotificationController(this._handleNotification) {
    _notificationService = GetIt.I.get<EbbotNotificationService>();
    _processNotifications();
  }

  void _processNotifications() {
    for (var notification in _notificationService.getNotifications()) {
      _handleNotification(notification.title, notification.text);
    }
  }
}
