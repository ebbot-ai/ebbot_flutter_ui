import 'package:ebbot_dart_client/entity/message/message.dart';
import 'package:logger/logger.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

/// A parser for processing incoming ebbot chat messages and generating corresponding types of flutter chat ui messages.
///
/// This class provides methods for processing various types of messages such as text, images, files, etc.
class EbbotMessageParser {
  final logger = Logger(
    printer: PrettyPrinter(),
  );

  /// Parses the incoming message and returns the corresponding message type.
  ///
  /// The method examines the type of the incoming message and delegates the processing to specific handlers.
  /// Returns `null` if the message type is unsupported.
  types.Message? parse(Message message, types.User user, String id) {
    var messageType = message.data.message.type;
    switch (messageType) {
      case 'gpt':
        logger.i("parsing gpt message");
        return _parseGpt(message.data.message, user, id);
      case 'image':
        logger.i("parsing image message");
        return _parseImage(message.data.message, user, id);
      case 'text':
        logger.i("parsing text message");
        return _parseText(message.data.message, user, id);
      case 'file':
        logger.i("parsing file message");
        return _parseFile(message.data.message, user, id);
      case 'text_info':
        logger.i("parsing text info message");
        return _parseTextInfo(message.data.message, user, id);
      case 'url':
        logger.i("parsing url message");
        return _parseCustom(message.data.message, user, id);
      case 'rating_request':
        logger.i("parsing rating request");
        return _parseCustom(message.data.message, user, id);
      case 'carousel':
        logger.i("parsing carousel message");
        return _parseCustom(message.data.message, user, id);
      default:
        logger.w("Unsupported message type: $messageType");
        return null;
    }
  }

  types.Message? _parseCustom(
      MessageContent message, types.User user, String id) {
    return types.CustomMessage(
        id: id, author: user, metadata: message.toJson());
  }

  types.Message? _parseTextInfo(
      MessageContent message, types.User author, String id) {
    // Add your message parsing logic here
    var text = message.value is String ? message.value : message.value['text'];

    return types.SystemMessage(
        id: id,
        author: author,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        text: text,
        metadata: message.toJson());
  }

  types.Message? _parseGpt(
      MessageContent message, types.User author, String id) {
    // Add your message parsing logic here
    var text = message.value is String ? message.value : message.value['text'];

    return types.TextMessage(
      author: author,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: id,
      text: text,
      metadata: message.toJson(),
    );
  }

  types.Message? _parseImage(
      MessageContent message, types.User author, String id) {
    // Add your message parsing logic here
    logger.i("parsing image message");
    if (message.value is! Map<String, dynamic>) {
      logger.i(
          "message is NOT a map, I don't know how to process this, so skipping.. type is ${message.value.runtimeType}");
      return null;
    }

    Map<String, dynamic> image = message.value;
    return types.ImageMessage(
      id: image['key'],
      author:
          author, // No good placeholder for author, should probably figure out how to get the actual author
      name: image['filename'],
      uri: image['url'],
      size: image['size'],
      metadata: message.toJson(),
    );
  }

  types.Message? _parseText(
      MessageContent message, types.User user, String id) {
    logger.i("parsing text message of type");

    if (message.sender == 'user') {
      logger.i("message is from user, so skipping..");
      return null;
    }

    var text = message.value is String ? message.value : message.value['text'];

    logger.i("message is correct type, so adding it: $text");

    return types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: id,
      text: text,
      metadata: message.toJson(),
    );
  }

  types.Message? _parseFile(
      MessageContent message, types.User author, String id) {
    logger.i("parsing file message");
    if (message.value is! Map<String, dynamic>) {
      logger.w(
          "message is NOT a map, I don't know how to process this, so skipping.. type is ${message.value.runtimeType}");
      return null;
    }

    Map<String, dynamic> file = message.value;

    return types.FileMessage(
      id: file['key'],
      author: author,
      name: file['filename'],
      size: file['size'],
      uri: file['url'],
      type: types.MessageType.file,
      metadata: message.toJson(),
    );
  }
}
