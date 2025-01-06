import 'package:ebbot_dart_client/entity/notification/notification.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';

class EbbotNotificationService {
  final _serviceLocator = ServiceLocator();
  get _logger => _serviceLocator.getService<LogService>().logger;

  List<Notification> getNotifications() {
    final client = _serviceLocator.getService<EbbotDartClientService>().client;
    _logger?.d('Getting notifications');
    return client.notifications;
  }
}
