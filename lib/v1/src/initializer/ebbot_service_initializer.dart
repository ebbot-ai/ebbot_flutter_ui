import 'package:ebbot_dart_client/configuration/configuration.dart';
import 'package:ebbot_dart_client/ebbot_dart_client.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_callback_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_chat_listener_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
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

  Future<void> _registerEbbotCallBackService() async {
    logger.d("Registering EbbotCallbackService");
    GetIt.I.registerSingleton<EbbotCallbackService>(
        EbbotCallbackService(_ebbotConfiguration.callback));
  }

  Future<void> _registerEbbotClientService() async {
    logger.d("Registering EbbotClientService");
    EbbotDartClientService service = EbbotDartClientService(_botId,
        _configuration, _ebbotConfiguration.userConfiguration.userAttributes);
    GetIt.I.registerSingleton<EbbotDartClientService>(service);
    await service.initialize();
  }

  Future<void> _registerEbbotNotificationService() async {
    logger.d("Registering EbbotNotificationService");
    GetIt.I.registerSingleton<EbbotNotificationService>(
        EbbotNotificationService());
  }

  Future<void> _registerEbbotChatListenerService() async {
    logger.d("Registering EbbotChatListenerService");

    GetIt.I.registerSingleton<EbbotChatListenerService>(
        EbbotChatListenerService());
  }

  Future<void> registerServices() async {
    logger.d("Registering services");
    await _registerEbbotCallBackService();
    await _registerEbbotClientService();
    await _registerEbbotNotificationService();
    await _registerEbbotChatListenerService();
  }
}
