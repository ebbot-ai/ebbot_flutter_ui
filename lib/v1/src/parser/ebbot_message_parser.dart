import 'package:ebbot_dart_client/entity/message/message.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

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
  types.Message? parse(Message message, types.User user, String id) {
    final messageType = message.data.message.type;

    switch (messageType) {
      case 'gpt':
        _logger?.i("parsing gpt message");
        return _parseGpt(message.data.message, user, id);
      case 'image':
        _logger?.i("parsing image message");
        return _parseImage(message.data.message, user, id);
      case 'text':
        _logger?.i("parsing text message");
        return _parseText(message.data.message, user, id);
      case 'file':
        _logger?.i("parsing file message");
        return _parseFile(message.data.message, user, id);
      case 'text_info':
        _logger?.i("parsing text info message");
        return _parseTextInfo(message.data.message, user, id);
      case 'url':
        _logger?.i("parsing url message");
        return _parseCustom(message.data.message, user, id);
      case 'rating_request':
        _logger?.i("parsing rating request");
        return _parseCustom(message.data.message, user, id);
      case 'carousel':
        _logger?.i("parsing carousel message");
        return _parseCustom(message.data.message, user, id);
      default:
        _logger?.w("Unsupported message type: $messageType");
        return null;
    }
  }

  types.Message? _parseCustom(
      MessageContent message, types.User user, String id) {
    return types.CustomMessage(
        id: id, author: user, metadata: message.toJson());
  }

  types.Message? _parseTextInfo(
      MessageContent message, types.User user, String id) {
    // Add your message parsing logic here
    var text = message.value is String ? message.value : message.value['text'];

    return types.SystemMessage(
        id: id,
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        text: text,
        metadata: message.toJson());
  }

  types.Message? _parseGpt(MessageContent message, types.User user, String id) {
    // Add your message parsing logic here
    var text = message.value is String ? message.value : message.value['text'];

    return types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: id,
      text: text,
      metadata: message.toJson(),
    );
  }

  types.Message? _parseImage(
      MessageContent message, types.User user, String id) {
    if (message.value is! Map<String, dynamic>) {
      _logger?.d(
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

  types.Message? _parseText(
      MessageContent message, types.User user, String id) {
    _logger?.i("parsing text message of type");

    if (message.sender == 'user') {
      _logger?.i("message is from user, so skipping..");
      return null;
    }

    var text = message.value is String ? message.value : message.value['text'];

    _logger?.i("message is correct type, so adding it: $text");

    return types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: id,
      text: text,
      metadata: message.toJson(),
    );
  }

  types.Message? _parseFile(
      MessageContent message, types.User user, String id) {
    _logger?.i("parsing file message");
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
