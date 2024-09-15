import 'package:ebbot_dart_client/entity/notification/notification.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';
import 'package:get_it/get_it.dart';

class EbbotNotificationService {
  final logger = GetIt.I.get<LogService>().logger;

  List<Notification> getNotifications() {
    logger?.d('Getting notifications');
    final client = GetIt.I.get<EbbotDartClientService>().client;
    return client.notifications;
  }
}
