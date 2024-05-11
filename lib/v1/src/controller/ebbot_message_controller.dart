import 'package:ebbot_dart_client/entities/message/message.dart';
import 'package:logger/logger.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

/// A controller for processing incoming ebbot chat messages and generating corresponding types of messages.
///
/// This class provides methods for processing various types of messages such as text, images, files, etc.
class EbbotMessageController {
  final logger = Logger(
    printer: PrettyPrinter(),
  );

  /// Handles the incoming message and returns the corresponding message type.
  ///
  /// The method examines the type of the incoming message and delegates the processing to specific handlers.
  /// Returns `null` if the message type is unsupported.
  types.Message? handle(Message message, types.User user, String id) {
    var messageType = message.data.message.type;
    switch (messageType) {
      case 'gpt':
        logger.i("handling gpt message");
        return handleGpt(message.data.message, user, id);
      case 'image':
        logger.i("handling image message");
        return handleImage(message.data.message, user, id);
      case 'text':
        logger.i("handling text message");
        return handleText(message.data.message, user, id);
      case 'file':
        logger.i("handling file message");
        return handleFile(message.data.message, user, id);
      case 'text_info':
        logger.i("handling text info message");
        return handleTextInfo(message.data.message, user, id);
      case 'url':
        logger.i("handling url message");
        return handleCustom(message.data.message, user, id);
      case 'rating_request':
        logger.i("handling rating request");
        return handleCustom(message.data.message, user, id);
      case 'carousel':
        logger.i("handling carousel message");
        return handleCustom(message.data.message, user, id);
      default:
        logger.w("Unsupported message type: $messageType");
        return null;
    }
  }

  types.Message? handleCustom(
      MessageContent message, types.User user, String id) {
    return types.CustomMessage(
        id: id, author: user, metadata: message.toJson());
  }

  types.Message? handleTextInfo(
      MessageContent message, types.User author, String id) {
    // Add your message handling logic here
    var text = message.value is String ? message.value : message.value['text'];

    return types.SystemMessage(
        id: id,
        author: author,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        text: text);
  }

  types.Message? handleGpt(
      MessageContent message, types.User author, String id) {
    // Add your message handling logic here
    var text = message.value is String ? message.value : message.value['text'];

    return types.TextMessage(
      author: author,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: id,
      text: text,
    );
  }

  types.Message? handleImage(
      MessageContent message, types.User author, String id) {
    // Add your message handling logic here
    logger.i("Handling image message");
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
    );
  }

  types.Message? handleText(
      MessageContent message, types.User author, String id) {
    logger.i("Handling text message");

    if (message.sender == 'user') {
      logger.i("message is from user, so skipping..");
      return null;
    }

    var text = message.value is String ? message.value : message.value['text'];

    logger.i("message is correct type, so adding it: $text");

    return types.TextMessage(
      author: author,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: id,
      text: text,
    );
  }

  types.Message? handleFile(
      MessageContent message, types.User author, String id) {
    logger.i("Handling file message");
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
    );
  }
}
