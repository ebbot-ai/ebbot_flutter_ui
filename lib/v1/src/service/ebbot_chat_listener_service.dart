import 'package:ebbot_dart_client/entity/chat/chat.dart';
import 'package:ebbot_dart_client/entity/message/message.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
import 'package:get_it/get_it.dart';

class EbbotChatListenerService {
  EbbotDartClientService get _clientService =>
      GetIt.I.get<EbbotDartClientService>();

  Stream<Chat> get chatStream => _clientService.client.chatStream;

  Stream<Message> get messageStream => _clientService.client.messageStream;
}
