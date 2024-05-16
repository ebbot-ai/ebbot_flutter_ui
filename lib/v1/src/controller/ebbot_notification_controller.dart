import 'package:ebbot_flutter_ui/v1/src/service/ebbot_notification_service.dart';
import 'package:get_it/get_it.dart';

class EbbotNotificationController {
  late EbbotNotificationService _notificationService;
  final Function(String title, String text) _handleNotification;
  EbbotNotificationController(this._handleNotification) {
    _notificationService = GetIt.I.get<EbbotNotificationService>();
    _processNotifications();
  }

  void _processNotifications() {
    for (var notification in _notificationService.getNotifications()) {
      _handleNotification(notification.title, notification.text);
    }
  }
}
