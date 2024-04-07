import 'package:ebbot_dart_client/entities/message/message.dart';
import 'package:flutter/material.dart';

class Url extends StatefulWidget {
  final MessageContent content;
  final void Function(String) onURlPressed;
  final void Function(String) onScenarioPressed;
  final void Function(String, String) onVariablePressed;

  const Url({
    Key? key,
    required this.content,
    required this.onURlPressed,
    required this.onScenarioPressed,
    required this.onVariablePressed,
  }) : super(key: key);

  @override
  _UrlState createState() => _UrlState();
}

class _UrlState extends State<Url> {
  final Map<String, bool> _hasBeenPressed = {};

  @override
  Widget build(BuildContext context) {
    final content = widget.content;

    if (content.value['urls'] is! List) {
      return Container();
    }

    var description = content.value['description'];

    List<Widget> children = [
      Container(
        margin: EdgeInsets.only(bottom: 10.0),
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
      var pattern = url['type'] + url['value'];
      var exists = _hasBeenPressed[pattern];
      return ElevatedButton(
        onPressed: exists != null && exists
            ? null
            : () {
                setState(() {
                  _hasBeenPressed[pattern] = true;
                });
                widget.onURlPressed(url['value']);
              },
        child: Text(url['label']),
      );
    } else if (url['type'] == 'scenario') {
      var pattern = url['type'] + url['next']['scenario'];
      var exists = _hasBeenPressed[pattern];
      return ElevatedButton(
        onPressed: exists != null && exists
            ? null
            : () {
                setState(() {
                  _hasBeenPressed[pattern] = true;
                });
                widget.onScenarioPressed(url['next']['scenario']);
              },
        child: Text(url['label']),
      );
    } else if (url['type'] == 'variable') {
      var pattern = url['type'] + url["name"] + url['value'];
      var exists = _hasBeenPressed[pattern];
      return ElevatedButton(
        onPressed: exists != null && exists
            ? null
            : () {
                setState(() {
                  _hasBeenPressed[pattern] = true;
                });
                widget.onVariablePressed(url['name'], url['value']);
              },
        child: Text(url['label']),
      );
    } else {
      return Container();
    }
  }
}
