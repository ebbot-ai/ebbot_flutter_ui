import 'package:ebbot_dart_client/entity/message/message.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';

typedef MessageParserResolver = String? Function(MessageContent);

class ChatTranscriptService {
  final _serviceLocator = ServiceLocator();
  get _logger => _serviceLocator.getService<LogService>().logger;

  final Map<double, String> _chatTranscript = {};

  String getChatTranscripts() {
    final sortedTranscripts = _chatTranscript.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final transcriptValues = sortedTranscripts.map((entry) => entry.value);
    return '${_getHeader()}\n\n${transcriptValues.join('\n')}';
  }

  void reset() {
    _chatTranscript.clear();
  }

  void save(Message message) {
    final messageType = message.data.message.type;

    String? parsedMessage;
    switch (messageType) {
      case 'gpt':
        _logger?.d("Parsing GPT message");
        parsedMessage = _composeMessage(message, _parseGpt);
        break;
      case 'image':
        _logger?.d("Parsing image message");
        parsedMessage = _composeMessage(message, _parseImage);
        break;
      case 'text':
        _logger?.d("Parsing text message");
        parsedMessage = _composeMessage(message, _parseText);
        break;
      case 'file':
        _logger?.d("Parsing file message");
        parsedMessage = _composeMessage(message, _parseFile);
        break;
      case 'text_info':
        _logger?.d("Parsing text info message");
        parsedMessage = _composeMessage(message, _parseTextInfo);
        break;
      case 'url':
        _logger?.d("Parsing URL message");
        parsedMessage = _composeMessage(message, _parseUrl);
        break;
      case 'rating_request':
        _logger?.d("Parsing rating request message");
        parsedMessage = _composeMessage(message, _parseRatingRequest);
        break;
      case 'carousel':
        _logger?.d("Parsing carousel message");
        parsedMessage = _composeMessage(message, _parseCarousel);
        break;
      // Feedback types
      case 'button_click':
        _logger?.d("Parsing button click message");
        parsedMessage = _composeMessage(message, _parseButtonClick);
        break;
      case 'rating':
        _logger?.d("Parsing rating message");
        parsedMessage = _composeMessage(message, _getRating);
        break;
      default:
        _logger?.w("Unsupported message type: $messageType");
        break;
    }

    if (parsedMessage != null) {
      final timestamp = message.data.message.timestamp;
      final key = parseTimestampToDouble(timestamp);
      _chatTranscript[key] = parsedMessage;
    }
  }

  String? _parseGpt(MessageContent content) {
    final text =
        content.value is String ? content.value : content.value['text'];
    return text;
  }

  String? _parseImage(MessageContent content) {
    if (content.value is! Map<String, dynamic>) {
      _logger?.w(
          "message is NOT a map, I don't know how to process this, so skipping.. type is ${content.value.runtimeType}");
      return null;
    }
    Map<String, dynamic> image = content.value;
    var imageUrl = image['url'];

    return '($imageUrl)';
  }

  String _parseText(MessageContent content) {
    final text =
        content.value is String ? content.value : content.value['text'];
    return text;
  }

  String _parseFile(MessageContent content) {
    if (content.value is! Map<String, dynamic>) {
      _logger?.w('value is not a map');
      return '';
    }
    Map<String, dynamic> file = content.value;
    return '(${file['url']})';
  }

  String _parseTextInfo(MessageContent content) {
    final text =
        content.value is String ? content.value : content.value['text'];
    return text;
  }

  String _parseUrl(MessageContent content) {
    if (content.value['urls'] is! List) {
      _logger?.w('URLs is not a list');
      return '';
    }

    final description = content.value['description'];

    final urlItems = _parseUrlItems(content.value['urls']);
    return '$description\n$urlItems';
  }

  String _parseUrlItems(List<dynamic> items) {
    final labels = items.map((url) => url["label"]).join(' | ');
    return '[ $labels ]';
  }

  String _parseRatingRequest(MessageContent content) {
    final question = content.value['question'];
    return question;
  }

  String _parseCarousel(MessageContent content) {
    if (content.value['slides'] is! List) {
      _logger?.w('Carousel slides is not a list');
      return '';
    }

    List slides = content.value['slides'];
    List<String> lines = [];
    for (int i = 0; i < slides.length; i++) {
      final slide = slides[i];

      lines.add("Slide $i");

      if (slide['urls'] is List) {
        lines.add(_parseUrlItems(slide['urls']));
      }

      final title = slide['title'];
      final description = slide['description'];
      final image = slide['url'];

      lines.add('($image)\n');
      lines.add('$title\n');
      lines.add('$description\n');
    }

    return lines.join('\n');
  }

  String _getRating(MessageContent content) {
    final rating = content.value['rating'];
    return rating.toString();
  }

  String _parseButtonClick(MessageContent content) {
    return content.value;
  }

  String _getHeader() {
    return '---- ${DateTime.now().toIso8601String()} ----';
  }

  int parseTimestampToMillis(String timestamp) {
    return (parseTimestampToDouble(timestamp) * 1000).toInt();
  }

  double parseTimestampToDouble(String timestamp) {
    return double.parse(timestamp);
  }

  String _getSubHeader(Message message) {
    try {
      final int timestamp =
          parseTimestampToMillis(message.data.message.timestamp);

      final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

      String formattedTime = "${dateTime.hour.toString().padLeft(2, '0')}:"
          "${dateTime.minute.toString().padLeft(2, '0')}:"
          "${dateTime.second.toString().padLeft(2, '0')}";
      var author = message.data.message.sender;

      // Configuration is a special author that is used for messages that are generated from configuration file
      if (author == 'configuration') {
        author = 'bot';
      }

      return '$formattedTime $author';
    } catch (e) {
      _logger?.e('Error parsing timestamp: $e');
      return "";
    }
  }

  String _composeMessage(
    Message message,
    MessageParserResolver messageParserResolver,
  ) {
    final subHeader = _getSubHeader(message);
    final parsedMessage = messageParserResolver(message.data.message);
    return '$subHeader:\n$parsedMessage\n';
  }
}
