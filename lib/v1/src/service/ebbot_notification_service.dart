import 'package:ebbot_dart_client/entity/notification/notification.dart';

class EbbotNotificationService {
  final List<Notification> _notifications;

  EbbotNotificationService(this._notifications);

  List<Notification> getNotifications() {
    return _notifications;
  }
}
