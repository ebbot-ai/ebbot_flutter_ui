import 'package:ebbot_dart_client/entity/message/message.dart' as ebbot_message;
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';

/// A parser for processing incoming ebbot chat messages and generating corresponding types of flutter chat ui messages.
///
/// This class provides methods for processing various types of messages such as text, images, files, etc.
class EbbotMessageParser {
  final _serviceLocator = ServiceLocator();
  get _logger => _serviceLocator.getService<LogService>().logger;

  /// Parses the incoming message and returns the corresponding message type.
  ///
  /// The method examines the type of the incoming message and delegates the processing to specific handlers.
  /// Returns `null` if the message type is unsupported.
  Message? parse(ebbot_message.Message message, User user, String id) {
    final messageType = message.data.message.type;

    switch (messageType) {
      case 'gpt':
        _logger?.d("parsing gpt message");
        return _parseGpt(message.data.message, user, id);
      case 'image':
        _logger?.d("parsing image message");
        return _parseImage(message.data.message, user, id);
      case 'text':
        _logger?.d("parsing text message");
        return _parseText(message.data.message, user, id);
      case 'file':
        _logger?.d("parsing file message");
        return _parseFile(message.data.message, user, id);
      case 'text_info':
        _logger?.d("parsing text info message");
        return _parseTextInfo(message.data.message, user, id);
      case 'url':
        _logger?.d("parsing url message");
        return _parseCustom(message.data.message, user, id);
      case 'rating_request':
        _logger?.d("parsing rating request");
        return _parseCustom(message.data.message, user, id);
      case 'carousel':
        _logger?.d("parsing carousel message");
        return _parseCustom(message.data.message, user, id);
      case 'button_click':
        _logger?.d("parsing button click message");
        return _parseButtonClick(message.data.message, user, id);
      case 'list':
        _logger?.d("parsing list message");
        return _parseCustom(message.data.message, user, id);
      default:
        _logger?.w(
            "Unsupported message type: $messageType data: ${message.data.message.toJson().toString()}");

        return null;
    }
  }

  Message? _parseButtonClick(
      ebbot_message.MessageContent message, User user, String id) {
    var text = message.value is String ? message.value : message.value['text'];
    return TextMessage(
      id: id,
      authorId: user.id,
      createdAt: DateTime.now().toUtc(),
      text: text,
      metadata: message.toJson(),
    );
  }

  Message? _parseCustom(
      ebbot_message.MessageContent message, User user, String id) {
    return CustomMessage(
        id: id,
        authorId: user.id,
        createdAt: DateTime.now().toUtc(),
        metadata: message.toJson());
  }

  Message? _parseTextInfo(
      ebbot_message.MessageContent message, User user, String id) {
    var text = message.value is String ? message.value : message.value['text'];

    return SystemMessage(
        id: id,
        authorId: user.id,
        createdAt: DateTime.now().toUtc(),
        text: text,
        metadata: message.toJson());
  }

  Message? _parseGpt(ebbot_message.MessageContent message, User user, String id) {
    var text = message.value is String ? message.value : message.value['text'];

    return TextMessage(
      authorId: user.id,
      createdAt: DateTime.now().toUtc(),
      id: id,
      text: text,
      metadata: message.toJson(),
    );
  }

  Message? _parseImage(
      ebbot_message.MessageContent message, User user, String id) {
    if (message.value is! Map<String, dynamic>) {
      _logger?.d(
          "message is NOT a map, I don't know how to process this, so skipping.. type is ${message.value.runtimeType}");
      return null;
    }

    Map<String, dynamic> image = message.value;
    return ImageMessage(
      id: image['key'],
      authorId: user.id,
      createdAt: DateTime.now().toUtc(),
      source: image['url'],
      size: image['size'],
      metadata: message.toJson(),
    );
  }

  Message? _parseText(
      ebbot_message.MessageContent message, User user, String id) {
    if (message.sender == 'user') {
      _logger?.w("message is from user, so skipping..");
      return null;
    }

    var text = message.value is String ? message.value : message.value['text'];

    return TextMessage(
      authorId: user.id,
      createdAt: DateTime.now().toUtc(),
      id: id,
      text: text,
      metadata: message.toJson(),
    );
  }

  Message? _parseFile(
      ebbot_message.MessageContent message, User user, String id) {
    if (message.value is! Map<String, dynamic>) {
      _logger?.w(
          "message is NOT a map, I don't know how to process this, so skipping.. type is ${message.value.runtimeType}");
      return null;
    }

    Map<String, dynamic> file = message.value;

    return FileMessage(
      id: file['key'],
      authorId: user.id,
      createdAt: DateTime.now().toUtc(),
      name: file['filename'],
      size: file['size'],
      source: file['url'],
      metadata: message.toJson(),
    );
  }
}
