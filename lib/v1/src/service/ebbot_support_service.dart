import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
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
      imageSource: imageUrl,
      // Note: avatarUrl parameter might not be supported in current flutter_chat_core version
      // TODO: Re-add avatar support when compatible with v2
    );
  }

  void setEbbotAgentUser(String? imageUrl) {
    _cachedEbbotUser = _generateEbbotUser(imageUrl: imageUrl);
  }

  void resetEbbotUser() {
    _cachedEbbotUser = null;
  }

  ChatTheme chatTheme() {
    // Create a minimal valid ChatTheme with proper shape parameter
    return ChatTheme(
      colors: ChatColors(
        primary: Colors.blue.shade600,
        onPrimary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black87,
        surfaceContainer: Colors.grey.shade100,
        surfaceContainerHigh: Colors.grey.shade200,
        surfaceContainerLow: Colors.grey.shade50,
      ),
      shape: BorderRadius.circular(12.0), // BorderRadiusGeometry
      typography: ChatTypography(
        bodyLarge: const TextStyle(fontSize: 16, color: Colors.black87),
        bodyMedium: const TextStyle(fontSize: 14, color: Colors.black87),
        bodySmall: const TextStyle(fontSize: 12, color: Colors.black54),
        labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }
}
