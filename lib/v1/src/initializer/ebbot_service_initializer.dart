import 'package:ebbot_dart_client/configuration/configuration.dart';
import 'package:ebbot_dart_client/ebbot_dart_client.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_callback_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_chat_listener_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_client_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_notification_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class EbbotServiceInitializer {
  final String _botId;
  final EbbotConfiguration _ebbotConfiguration;
  final Configuration _configuration;

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  EbbotServiceInitializer(
      this._botId, this._ebbotConfiguration, this._configuration);

  Future<void> registerEbbotCallBackService() async {
    logger.d("Registering EbbotCallbackService");
    GetIt.I.registerSingleton<EbbotCallbackService>(
        EbbotCallbackService(_ebbotConfiguration.callback));
  }

  Future<void> registerEbbotClientService() async {
    logger.d("Registering EbbotClientService");
    EbbotClientService service = EbbotClientService(_botId, _configuration);
    GetIt.I.registerSingleton<EbbotClientService>(service);
    await service.initialize();
  }

  Future<void> registerServices() async {
    logger.d("Registering services");
    final ebbotClient = GetIt.I.get<EbbotClientService>().client;
    GetIt.I.registerSingleton<EbbotNotificationService>(
        EbbotNotificationService(ebbotClient.notifications));
    GetIt.I.registerSingleton<EbbotChatListenerService>(
        EbbotChatListenerService(ebbotClient));
  }
}
