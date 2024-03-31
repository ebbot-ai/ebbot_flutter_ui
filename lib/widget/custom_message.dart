import 'package:ebbot_dart_client/ebbot_dart_client.dart';
import 'package:ebbot_dart_client/entities/message/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:url_launcher/url_launcher.dart';

class CustomMessage {
  final EbbotDartClient client;

  CustomMessage({
    required this.client,
  });

  Widget handle(types.CustomMessage message, {required int messageWidth}) {
    if (message.metadata == null) {
      return Container();
    }

    MessageContent content = MessageContent.fromJson(message.metadata!);

    if (content.type != 'url') {
      return Container();
    }

    // Check if content has a property called urls, that should be a list
    if (content.value['urls'] is! List) {
      return Container();
    }

    var description = content.value['description'];

    List<Widget> children = [
      Text(description),
      ...(content.value['urls'] as List).map((url) => _urlMessageBuilder(url)),
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _urlMessageBuilder(dynamic url) {
    if (url['type'] == 'url') {
      return ElevatedButton(
        onPressed: () async {
          var uri = Uri.parse(url['value']);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            throw 'Could not launch $uri';
          }
        },
        child: Text(url['label']),
      );
    } else if (url['type'] == 'scenario') {
      return ElevatedButton(
        onPressed: () {
          // Perform scenario action
          client.sendScenarioMessage(url['next']['scenario']);
        },
        child: Text(url['label']),
      );
    } else if (url['type'] == 'variable') {
      return ElevatedButton(
        onPressed: () {
          // Perform variable action
          client.sendVariableMessage(url['name'], url['value']);
        },
        child: Text(url['label']),
      );
    } else {
      return Container();
    }
  }
}
