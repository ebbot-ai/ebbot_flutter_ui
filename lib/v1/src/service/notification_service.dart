import 'package:ebbot_dart_client/entities/notifications/notification.dart';

class NotificationService {
  final List<Notification> _notifications;

  NotificationService(this._notifications);

  List<Notification> getNotifications() {
    return _notifications;
  }
}
