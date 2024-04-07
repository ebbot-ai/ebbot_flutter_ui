import 'package:ebbot_dart_client/entities/message/message.dart';
import 'package:flutter/material.dart';

class Url extends StatefulWidget {
  final MessageContent content;
  final void Function(String) onURlPressed;
  final void Function(String) onScenarioPressed;
  final void Function(String, String) onVariablePressed;

  const Url(
      {super.key,
      required this.content,
      required this.onURlPressed,
      required this.onScenarioPressed,
      required this.onVariablePressed});

  @override
  _UrlState createState() => _UrlState();
}

class _UrlState extends State<Url> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.content;
    // Check if content has a property called urls, that should be a list
    if (content.value['urls'] is! List) {
      return Container();
    }

    var description = content.value['description'];

    List<Widget> children = [
      Container(
        margin: EdgeInsets.only(bottom: 10.0), // Adjust bottom margin as needed
        child: Text(description, textAlign: TextAlign.center),
      ),
      ...(content.value['urls'] as List).map((url) => _urlMessageBuilder(url)),
    ];

    return Padding(
      padding: const EdgeInsets.all(20.0),
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
          // Perform URL action
          widget.onURlPressed(url['value']);
        },
        child: Text(url['label']),
      );
    } else if (url['type'] == 'scenario') {
      return ElevatedButton(
        onPressed: () {
          // Perform scenario action
          widget.onScenarioPressed(url['next']['scenario']);
        },
        child: Text(url['label']),
      );
    } else if (url['type'] == 'variable') {
      return ElevatedButton(
        onPressed: () {
          // Perform variable action
          widget.onVariablePressed(url['name'], url['value']);
        },
        child: Text(url['label']),
      );
    } else {
      return Container();
    }
  }
}
