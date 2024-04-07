import 'package:ebbot_dart_client/ebbot_dart_client.dart';
import 'package:ebbot_dart_client/entities/message/message.dart';
import 'package:ebbot_flutter_ui/v1/ebbot_flutter_ui.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/rating.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:url_launcher/url_launcher.dart';

class CustomMessage {
  final EbbotDartClient client;
  final EbbotFlutterUiState ebbotFlutterUiState;
  final void Function(bool) canType;

  CustomMessage({
    required this.client,
    required this.ebbotFlutterUiState,
    required this.canType,
  });

  Widget handle(types.CustomMessage message, {required int messageWidth}) {
    if (message.metadata == null) {
      return Container();
    }

    MessageContent content = MessageContent.fromJson(message.metadata!);

    switch (content.type) {
      case 'url':
        return handleUrl(content);
      case 'rating_request':
        return handleRatingRequest(content);
      default:
        return Container();
    }
  }

  Widget handleRatingRequest(MessageContent content) {
    return Rating(
      onRatingChanged: (rating) {
        client.sendRatingMessage(rating);
      },
      content: content,
    );
  }

  Widget handleUrl(MessageContent content) {
    return Url(
        content: content,
        onURlPressed: (url) async {
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
        },
        onScenarioPressed: (scenario) {
          client.sendScenarioMessage(scenario);
        },
        onVariablePressed: (name, value) {
          client.sendVariableMessage(name, value);
        });
  }
}
