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

  types.User? _cachedEbbotUser;

  types.User getEbbotUser() {
    if (_cachedEbbotUser != null) return _cachedEbbotUser!;

    final client = _serviceLocator.getService<EbbotDartClientService>().client;
    final config = client.chatStyleConfig;
    // This will default to use the GPT avatar, it will be overridden once an agent handover happens
    _cachedEbbotUser = _generateEbbotUser(imageUrl: config?.avatar.src);
    return _cachedEbbotUser!;
  }

  types.User _generateEbbotUser({String? imageUrl}) {
    return types.User(
      id: 'bot',
      firstName: 'Bot',
      lastName: 'Bot',
      imageUrl: imageUrl,
    );
  }

  void setEbbotAgentUser(String? imageUrl) {
    _cachedEbbotUser = _generateEbbotUser(imageUrl: imageUrl);
  }

  void resetEbbotUser() {
    _cachedEbbotUser = null;
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
        typingIndicatorTheme: typingIndicatorTheme,
        receivedMessageBodyTextStyle: const TextStyle(
          color: neutral0,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
        sentMessageBodyTextStyle: const TextStyle(
          color: neutral7,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ));
  }
}
