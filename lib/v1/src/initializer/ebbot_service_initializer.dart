import 'package:ebbot_dart_client/configuration/configuration.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/chat_transcript_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_callback_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_chat_listener_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_notification_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';

class EbbotServiceInitializer {
  final String _botId;

  final EbbotConfiguration _ebbotConfiguration;
  final Configuration _dartClientConfiguration;
  final ServiceLocator _serviceLocator = ServiceLocator();

  EbbotServiceInitializer(
      this._botId, this._ebbotConfiguration, this._dartClientConfiguration);

  Future<void> _registerLogService() async {
    _serviceLocator
        .registerService<LogService>(LogService(_ebbotConfiguration));
  }

  Future<void> _registerEbbotCallBackService() async {
    _serviceLocator.registerService<EbbotCallbackService>(
        EbbotCallbackService(_ebbotConfiguration.callback));
  }

  Future<void> _registerEbbotClientService() async {
    EbbotDartClientService service = EbbotDartClientService(
        _botId,
        _dartClientConfiguration,
        _ebbotConfiguration.userConfiguration.userAttributes);
    _serviceLocator.registerService<EbbotDartClientService>(service);
    await service.initialize();
  }

  Future<void> _registerEbbotNotificationService() async {
    _serviceLocator
        .registerService<EbbotNotificationService>(EbbotNotificationService());
  }

  Future<void> _registerEbbotChatListenerService() async {
    _serviceLocator
        .registerService<EbbotChatListenerService>(EbbotChatListenerService());
  }

  Future<void> _registerChatTranscriptService() async {
    _serviceLocator
        .registerService<ChatTranscriptService>(ChatTranscriptService());
  }

  Future<void> registerServices() async {
    await _registerLogService();
    await _registerEbbotCallBackService();
    await _registerEbbotClientService();
    await _registerEbbotNotificationService();
    await _registerEbbotChatListenerService();
    await _registerChatTranscriptService();
  }
}
