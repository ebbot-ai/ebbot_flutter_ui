import 'package:ebbot_dart_client/entity/chat/chat.dart';
import 'package:ebbot_dart_client/entity/message/message.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';

class EbbotChatListenerService {
  final _serviceLocator = ServiceLocator();

  Stream<Chat> get chatStream =>
      _serviceLocator.getService<EbbotDartClientService>().client.chatStream;

  Stream<Message> get messageStream =>
      _serviceLocator.getService<EbbotDartClientService>().client.messageStream;
}
