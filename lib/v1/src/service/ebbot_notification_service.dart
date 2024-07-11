import 'package:ebbot_dart_client/entity/notification/notification.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class EbbotNotificationService {
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  List<Notification> getNotifications() {
    logger.d('Getting notifications');
    final client = GetIt.I.get<EbbotDartClientService>().client;
    return client.notifications;
  }
}
