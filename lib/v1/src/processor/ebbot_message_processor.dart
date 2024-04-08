import 'package:ebbot_dart_client/entities/message/message.dart';
import 'package:logger/logger.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

/// A class responsible for processing incoming messages and generating corresponding types of messages.
///
/// This class provides methods for processing various types of messages such as text, images, files, etc.
class EbbotMessageProcessor {
  final logger = Logger(
    printer: PrettyPrinter(),
  );

  /// Processes the incoming message and returns the corresponding message type.
  ///
  /// The method examines the type of the incoming message and delegates the processing to specific handlers.
  /// Returns `null` if the message type is unsupported.
  types.Message? process(Message message, types.User user, String id) {
    var messageType = message.data.message.type;
    switch (messageType) {
      case 'gpt':
        logger.i("processing gpt message");
        return processGpt(message.data.message, user, id);
      case 'image':
        logger.i("processing image message");
        return processImage(message.data.message, user, id);
      case 'text':
        logger.i("processing text message");
        return processText(message.data.message, user, id);
      case 'file':
        logger.i("processing file message");
        return processFile(message.data.message, user, id);
      case 'text_info':
        logger.i("processing text info message");
        return processTextInfo(message.data.message, user, id);
      case 'url':
        logger.i("processing url message");
        return processCustom(message.data.message, user, id);
      case 'rating_request':
        logger.i("processing rating request");
        return processCustom(message.data.message, user, id);

      default:
        logger.w("Unsupported message type: $messageType");
        return null;
    }
  }

  types.Message? processCustom(
      MessageContent message, types.User user, String id) {
    return types.CustomMessage(
        id: id, author: user, metadata: message.toJson());
  }

  types.Message? processTextInfo(
      MessageContent message, types.User author, String id) {
    // Add your message handling logic here
    var text = message.value is String ? message.value : message.value['text'];

    return types.SystemMessage(
        id: id,
        author: author,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        text: text);
  }

  types.Message? processGpt(
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

  types.Message? processImage(
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

  types.Message? processText(
      MessageContent message, types.User author, String id) {
    // Add your message handling logic here
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

  types.Message? processFile(
      MessageContent message, types.User author, String id) {
    // Add your message handling logic here
    logger.i("Handling file message");
    if (message.value is! Map<String, dynamic>) {
      logger.i(
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
