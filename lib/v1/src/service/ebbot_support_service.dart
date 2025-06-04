import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
import 'package:ebbot_flutter_ui/v1/src/util/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

// EbbotSupportService is a service that provides support functionalities for Ebbot, such as retrieving notifications and generating a user representation for Ebbot GPT.
// i've placed these here, to not clutter the repo with infinite amount of services.
class EbbotSupportService {
  final _serviceLocator = ServiceLocator();

  types.User? _cachedEbbotGPTUser;

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

  ChatTheme chatTheme() {
    final client = _serviceLocator.getService<EbbotDartClientService>().client;
    final config = client.chatStyleConfig;

    if (config == null) {
      throw Exception(
          "ChatStyleConfig is not initialized. Please check your EbbotDartClientService initialization.");
    }
    final typingIndicatorCirclesColor =
        HexColor.fromHex(config.message_dots_color);
    final primaryColor = HexColor.fromHex(config.regular_btn_background_color);

    var typingIndicatorTheme = TypingIndicatorTheme(
      animatedCirclesColor: typingIndicatorCirclesColor,
      animatedCircleSize: 5.0,
      bubbleBorder: const BorderRadius.all(Radius.circular(27.0)),
      bubbleColor: neutral7,
      countAvatarColor: primaryColor,
      countTextColor: primaryColor,
      multipleUserTextStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: neutral2,
      ),
    );

    return DefaultChatTheme(
        primaryColor: primaryColor,
        userAvatarImageBackgroundColor: primaryColor,
        userAvatarNameColors: [primaryColor],
        typingIndicatorTheme: typingIndicatorTheme);
  }
}
