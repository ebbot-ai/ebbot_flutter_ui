import 'package:ebbot_dart_client/ebbot_dart_client.dart';
import 'package:ebbot_dart_client/entity/message/message.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/ebbot_flutter_ui.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/carousel_widget.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/rating_widget.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/url_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:url_launcher/url_launcher.dart';

// A controller for handling custom flutter chat ui messages
class ChatUiCustomMessageController {
  final EbbotDartClient client;
  final EbbotFlutterUiState ebbotFlutterUiState;
  final EbbotConfiguration configuration;
  final void Function(bool) canType;

  ChatUiCustomMessageController({
    required this.client,
    required this.ebbotFlutterUiState,
    required this.configuration,
    required this.canType,
  });

  Widget processMessage(types.CustomMessage message,
      {required int messageWidth}) {
    if (message.metadata == null) {
      return Container();
    }

    MessageContent content = MessageContent.fromJson(message.metadata!);

    switch (content.type) {
      case 'url':
        return _processUrl(content);
      case 'rating_request':
        return _processRatingRequest(content);
      case 'carousel':
        return _processCarousel(content);
      default:
        return Container();
    }
  }

  Widget _processCarousel(MessageContent content) {
    return CarouselWidget(
      content: content,
      configuration: configuration,
      onURlPressed: (String url) async {
        _processUrlClick(url);
      },
      onScenarioPressed: (String scenario) {
        client.sendScenarioMessage(scenario);
      },
      onVariablePressed: (String name, String value) {
        client.sendVariableMessage(name, value);
      },
    );
  }

  Widget _processRatingRequest(MessageContent content) {
    return RatingWidget(
      content: content,
      configuration: configuration,
      onRatingChanged: (rating) {
        client.sendRatingMessage(rating);
      },
    );
  }

  Widget _processUrl(MessageContent content) {
    return UrlBoxWidget(
        content: content,
        configuration: configuration,
        onURlPressed: (url) async {
          _processUrlClick(url);
        },
        onScenarioPressed: (scenario) {
          client.sendScenarioMessage(scenario);
        },
        onVariablePressed: (name, value) {
          client.sendVariableMessage(name, value);
        });
  }

  void _processUrlClick(String url) async {
    var uri = Uri.parse(url);

    // If uri protocol is ebbot://reset, reset the conversation by letting the parent know
    if (uri.scheme == 'ebbot' && uri.host == 'reset') {
      ebbotFlutterUiState.isInitialized =
          false; // This should be moved out of this function to the parent, but i'll keep it here for now
      await client.restart();
      ebbotFlutterUiState.initialize();
      return;
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
