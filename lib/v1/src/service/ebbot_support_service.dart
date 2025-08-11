import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
import 'package:ebbot_flutter_ui/v1/src/theme/ebbot_text_styles.dart';
import 'package:ebbot_flutter_ui/v1/src/util/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

// EbbotSupportService is a service that provides support functionalities for Ebbot, such as retrieving notifications and generating a user representation for Ebbot GPT.
// i've placed these here, to not clutter the repo with infinite amount of services.
class EbbotSupportService {
  final _serviceLocator = ServiceLocator();

  User? _cachedEbbotUser;

  User getEbbotUser() {
    if (_cachedEbbotUser != null) return _cachedEbbotUser!;

    final client = _serviceLocator.getService<EbbotDartClientService>().client;
    final config = client.chatStyleConfig;
    // This will default to use the GPT avatar, it will be overridden once an agent handover happens
    _cachedEbbotUser = _generateEbbotUser(imageUrl: config?.avatar.src);
    return _cachedEbbotUser!;
  }

  User _generateEbbotUser({String? imageUrl}) {
    return User(
      id: 'bot',
      name: 'Bot',
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
    
    final primaryColor = HexColor.fromHex(config.regular_btn_background_color);

    // For now, return a basic theme. In v2, theming might work differently
    return ChatTheme(
      primaryColor: primaryColor,
      // Add minimal required theme properties
    );
  }
}
