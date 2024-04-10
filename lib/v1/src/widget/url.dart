import 'package:ebbot_dart_client/entities/message/message.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:flutter/material.dart';

class Url extends StatefulWidget {
  final EbbotConfiguration configuration;
  final dynamic url;
  final void Function(String) onURlPressed;
  final void Function(String) onScenarioPressed;
  final void Function(String, String) onVariablePressed;

  const Url({
    Key? key,
    required this.url,
    required this.configuration,
    required this.onURlPressed,
    required this.onScenarioPressed,
    required this.onVariablePressed,
  }) : super(key: key);

  @override
  _UrlState createState() => _UrlState();
}

class _UrlState extends State<Url> {
  bool _hasBeenPressed = false;

  @override
  Widget build(BuildContext context) {
    return _urlMessageBuilder(widget.url);
  }

  Widget _urlMessageBuilder(dynamic url) {
    Widget button;
    if (url['type'] == 'url') {
      button = ElevatedButton(
        onPressed: _hasBeenPressed
            ? null
            : () {
                setState(() {
                  _hasBeenPressed = true;
                });
                widget.onURlPressed(url['value']);
              },
        child: Text(url['label']),
      );
    } else if (url['type'] == 'scenario') {
      button = ElevatedButton(
        onPressed: _hasBeenPressed
            ? null
            : () {
                setState(() {
                  _hasBeenPressed = true;
                });
                widget.onScenarioPressed(url['next']['scenario']);
              },
        child: Text(url['label']),
      );
    } else if (url['type'] == 'variable') {
      button = ElevatedButton(
        onPressed: _hasBeenPressed
            ? null
            : () {
                setState(() {
                  _hasBeenPressed = true;
                });
                widget.onVariablePressed(url['name'], url['value']);
              },
        child: Text(url['label']),
      );
    } else {
      return Container();
    }

    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: button,
    );
  }
}
