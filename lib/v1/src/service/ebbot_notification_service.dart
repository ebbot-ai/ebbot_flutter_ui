import 'package:ebbot_dart_client/entity/notification/notification.dart';
import 'package:logger/logger.dart';

class EbbotNotificationService {
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  final List<Notification> _notifications;

  EbbotNotificationService(this._notifications);

  List<Notification> getNotifications() {
    logger.d('Getting notifications');
    return _notifications;
  }
}
