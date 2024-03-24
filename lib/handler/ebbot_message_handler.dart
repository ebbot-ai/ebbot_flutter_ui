import 'package:ebbot_dart_client/entities/message.dart';
import 'package:ebbot_dart_client/valueobjects/message_type.dart';
import 'package:logger/logger.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class EbbotMessageHandler {

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  types.Message? handle(Message message, types.User user, String id) {
    var messageType = message.data.message.type;
    switch (messageType) {
      case MessageType.gpt:
        logger.i("handling gpt message");
        return handleGpt(message, user, id);
      case MessageType.image:
        logger.i("handling image message");
        return handleImage(message, user, id);
      case MessageType.text:
        logger.i("handling text message");
        return handleText(message, user, id);
        case MessageType.file:
        logger.i("handling file message");
        return handleFile(message, user, id);
      default:
        logger.w("Unsupported message type: $messageType");
        return null;
    }
  }

  types.Message? handleGpt(Message message, types.User author, String id) {
    // Add your message handling logic here
    var text = message.data.message.value is String
              ? message.data.message.value
              : message.data.message.value['text'];

          
    return types.TextMessage(
      author: author,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: id,
      text: text,
    );          
  }

  types.Message? handleImage(Message message, types.User author, String id) {
    // Add your message handling logic here
    logger.i("Handling image message");
    if (message.data.message.value is! Map<String, dynamic>) {
      logger.i("message is NOT a map, I don't know how to process this, so skipping.. type is ${message.data.message.value.runtimeType}");
      return null;
    } 

    Map<String, dynamic> image = message.data.message.value;
    return types.ImageMessage(
      id: image['key'],
      author: author, // No good placeholder for author, should probably figure out how to get the actual author
      name: image['filename'],
      uri: image['url'],
      size: image['size'],
    );
  }

  types.Message? handleText(Message message, types.User author, String id) {
    // Add your message handling logic here
    logger.i("Handling text message");

    if (message.data.message.sender == 'user') {
      logger.i("message is from user, so skipping..");
      return null;
    }

    var text = message.data.message.value is String
        ? message.data.message.value
        : message.data.message.value['text'];

    logger.i("message is correct type, so adding it: $text");

    return types.TextMessage(
      author: author,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: id,
      text: text,
    );
  }

  types.Message? handleFile(Message message, types.User author, String id) {
    // Add your message handling logic here
    logger.i("Handling file message");
    if (message.data.message.value is! Map<String, dynamic>) {
      logger.i("message is NOT a map, I don't know how to process this, so skipping.. type is ${message.data.message.value.runtimeType}");
      return null;
    } 

    Map<String, dynamic> file = message.data.message.value;

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