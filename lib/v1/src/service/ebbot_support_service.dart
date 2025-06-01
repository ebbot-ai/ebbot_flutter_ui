import 'package:ebbot_dart_client/entity/notification/notification.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

// EbbotSupportService is a service that provides support functionalities for Ebbot, such as retrieving notifications and generating a user representation for Ebbot GPT.
// i've placed these here, to not clutter the repo with infinite amount of services.
class EbbotSupportService {
  final _serviceLocator = ServiceLocator();

  types.User? _cachedEbbotGPTUser;

  List<Notification> getNotifications() {
    final client = _serviceLocator.getService<EbbotDartClientService>().client;
    return client.notifications;
  }

  types.User getEbbotGPTUser() {
    if (_cachedEbbotGPTUser != null) return _cachedEbbotGPTUser!;

    final client = _serviceLocator.getService<EbbotDartClientService>().client;
    final config = client.chatStyleConfig;
    _cachedEbbotGPTUser = _generateEbbotGPTUser(imageUrl: config?.avatar.src);
    return _cachedEbbotGPTUser!;
  }

  types.User _generateEbbotGPTUser({String? imageUrl}) {
    return types.User(
      id: 'bot',
      firstName: 'Bot',
      lastName: 'Bot',
      imageUrl: imageUrl,
    );
  }
}
