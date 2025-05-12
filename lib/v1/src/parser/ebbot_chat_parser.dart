import 'package:ebbot_dart_client/entity/chat/chat.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class EbbotChatParser {
  final _serviceLocator = ServiceLocator();
  get _logger => _serviceLocator.getService<LogService>().logger;

  types.Message? parse(ChatMessage message, types.User user, String id) {
    final messageType = message.type;

    final expectedVisibility = ['chat', 'user'];
    // Lets assume that message.visibility = 'user' means we should show it
    if (expectedVisibility.contains(message.visibility)) {
      _logger?.d("message visibility is ${message.visibility}");
    } else {
      _logger?.d(
          "message visibility is ${message.visibility}, expecting ${expectedVisibility.join(", ")}, so skipping..");
      return null;
    }

    switch (messageType) {
      case 'gpt':
        _logger?.d("parsing gpt message");
        return _parseGpt(message, user, id);
      case 'image':
        _logger?.d("parsing image message");
        return _parseImage(message, user, id);
      case 'text':
        _logger?.d("parsing text message");
        return _parseText(message, user, id);
      case 'file':
        _logger?.d("parsing file message");
        return _parseFile(message, user, id);
      case 'text_info':
        _logger?.d("parsing text info message");
        return _parseTextInfo(message, user, id);
      case 'url':
        _logger?.d("parsing url message");
        return _parseCustom(message, user, id);
      case 'rating_request':
        _logger?.d("parsing rating request");
        return _parseCustom(message, user, id);
      case 'carousel':
        _logger?.d("parsing carousel message");
        return _parseCustom(message, user, id);
      case 'button_click':
        _logger?.d("parsing button click message");
        return _parseButtonClick(message, user, id);
      case 'list':
        _logger?.d("parsing list message");
        return _parseCustom(message, user, id);
      default:
        _logger?.w("Unsupported message type: $messageType");
        return null;
    }
  }

  types.Message? _parseButtonClick(
      ChatMessage message, types.User user, String id) {
    var text = message.value is String ? message.value : message.value['text'];
    return types.TextMessage(
      id: id,
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      text: text,
      metadata: message.toJson(),
    );
  }

  types.Message? _parseCustom(ChatMessage message, types.User user, String id) {
    return types.CustomMessage(
        id: id,
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        metadata: message.toJson());
  }

  types.Message? _parseTextInfo(
      ChatMessage message, types.User user, String id) {
    var text = message.value is String ? message.value : message.value['text'];
    return types.TextMessage(
      id: id,
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      text: text,
      metadata: message.toJson(),
    );
  }

  types.Message? _parseGpt(ChatMessage message, types.User user, String id) {
    var text = message.value is String ? message.value : message.value['text'];
    return types.TextMessage(
      id: id,
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      text: text,
      metadata: message.toJson(),
    );
  }

  types.Message? _parseImage(ChatMessage message, types.User user, String id) {
    if (message.value is! Map<String, dynamic>) {
      _logger?.w(
          "message is NOT a map, I don't know how to process this, so skipping.. type is ${message.value.runtimeType}");
      return null;
    }

    Map<String, dynamic> image = message.value;
    return types.ImageMessage(
      id: image['key'],
      author: user,
      name: image['filename'],
      uri: image['url'],
      size: image['size'],
      metadata: message.toJson(),
    );
  }

  types.Message? _parseText(ChatMessage message, types.User user, String id) {
    var text = message.value is String ? message.value : message.value['text'];

    return types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: id,
      text: text,
      metadata: message.toJson(),
    );
  }

  types.Message? _parseFile(ChatMessage message, types.User user, String id) {
    if (message.value is! Map<String, dynamic>) {
      _logger?.w(
          "message is NOT a map, I don't know how to process this, so skipping.. type is ${message.value.runtimeType}");
      return null;
    }

    Map<String, dynamic> file = message.value;
    return types.FileMessage(
      id: file['key'],
      author: user,
      name: file['filename'],
      size: file['size'],
      uri: file['url'],
      type: types.MessageType.file,
      metadata: message.toJson(),
    );
  }
}
