import 'package:ebbot_dart_client/configuration/configuration.dart';
import 'package:ebbot_dart_client/ebbot_dart_client.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/src/service/chat_transcript_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_callback_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_chat_listener_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_notification_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';
import 'package:get_it/get_it.dart';

class EbbotServiceInitializer {
  final String _botId;
  final EbbotConfiguration _ebbotConfiguration;
  final Configuration _dartClientConfiguration;

  EbbotServiceInitializer(
      this._botId, this._ebbotConfiguration, this._dartClientConfiguration);

  Future<void> _registerLogService() async {
    GetIt.I.registerSingleton<LogService>(LogService(_ebbotConfiguration));
  }

  Future<void> _registerEbbotCallBackService() async {
    GetIt.I.registerSingleton<EbbotCallbackService>(
        EbbotCallbackService(_ebbotConfiguration.callback));
  }

  Future<void> _registerEbbotClientService() async {
    EbbotDartClientService service = EbbotDartClientService(
        _botId,
        _dartClientConfiguration,
        _ebbotConfiguration.userConfiguration.userAttributes);
    GetIt.I.registerSingleton<EbbotDartClientService>(service);
    await service.initialize();
  }

  Future<void> _registerEbbotNotificationService() async {
    GetIt.I.registerSingleton<EbbotNotificationService>(
        EbbotNotificationService());
  }

  Future<void> _registerEbbotChatListenerService() async {
    GetIt.I.registerSingleton<EbbotChatListenerService>(
        EbbotChatListenerService());
  }

  Future<void> _registerChatTranscriptService() async {
    GetIt.I.registerSingleton<ChatTranscriptService>(ChatTranscriptService());
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
