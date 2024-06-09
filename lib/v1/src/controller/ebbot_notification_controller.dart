import 'package:ebbot_flutter_ui/v1/src/service/ebbot_notification_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class EbbotNotificationController {
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  late EbbotNotificationService _notificationService;
  final Function(String title, String text) _handleNotification;
  EbbotNotificationController(this._handleNotification) {
    _notificationService = GetIt.I.get<EbbotNotificationService>();
    _processNotifications();
  }

  void _processNotifications() {
    logger.d(
        'Processing notifications: ${_notificationService.getNotifications().length}');
    for (var notification in _notificationService.getNotifications()) {
      logger.d('Processing notification: ${notification.title}');
      _handleNotification(notification.title, notification.text);
    }
  }
}
