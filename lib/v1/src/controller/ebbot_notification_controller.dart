import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_support_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';

class EbbotNotificationController {
  final _serviceLocator = ServiceLocator();
  get _logger => _serviceLocator.getService<LogService>().logger;

  late EbbotSupportService _notificationService;
  final Function(String title, String text) _handleNotification;
  EbbotNotificationController(this._handleNotification) {
    _notificationService = _serviceLocator.getService<EbbotSupportService>();
    _processNotifications();
  }

  void _processNotifications() {
    _logger?.d(
        'Processing notifications: ${_notificationService.getNotifications().length}');
    for (var notification in _notificationService.getNotifications()) {
      _logger?.d('Processing notification: ${notification.title}');
      _handleNotification(notification.title, notification.text);
    }
  }
}
