import 'package:ebbot_dart_client/entity/button_data/button_data.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:flutter/material.dart';

class UrlButtonWidget extends StatefulWidget {
  final EbbotConfiguration configuration;
  final dynamic url;
  final void Function(String, {ButtonData? buttonData}) onURlPressed;
  final void Function(String, {ButtonData? buttonData}) onScenarioPressed;
  final void Function(String, String, {ButtonData? buttonData})
      onVariablePressed;
  //final void Function(String, String, {ButtonData? buttonData})
  //    onButtonClickPressed;

  const UrlButtonWidget({
    Key? key,
    required this.url,
    required this.configuration,
    required this.onURlPressed,
    required this.onScenarioPressed,
    required this.onVariablePressed,
    // required this.onButtonClickPressed,
  }) : super(key: key);

  @override
  _UrlButtonWidgetState createState() => _UrlButtonWidgetState();
}

class _UrlButtonWidgetState extends State<UrlButtonWidget> {
  bool _hasBeenPressed = false;

  @override
  Widget build(BuildContext context) {
    return _urlMessageBuilder(widget.url);
  }

  Widget _urlMessageBuilder(dynamic url) {
    final style = ButtonStyle(
      foregroundColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey; // Disabled color
        }
        return widget.configuration.theme.primaryColor; // Enabled color
      }),
    );

    Widget button;
    if (url['type'] == 'url') {
      button = ElevatedButton(
        style: style,
        onPressed: _hasBeenPressed
            ? null
            : () {
                setState(() {
                  _hasBeenPressed = true;
                });
                final buttonData =
                    ButtonData(buttonId: url['buttonId'], label: url['label']);
                widget.onURlPressed(url['value'], buttonData: buttonData);
              },
        child: Text(url['label']),
      );
    } else if (url['type'] == 'scenario') {
      button = ElevatedButton(
        style: style,
        onPressed: _hasBeenPressed
            ? null
            : () {
                setState(() {
                  _hasBeenPressed = true;
                });
                final buttonData =
                    ButtonData(buttonId: url['buttonId'], label: url['label']);
                widget.onScenarioPressed(url['next']['scenario'],
                    buttonData: buttonData);
              },
        child: Text(url['label']),
      );
    } else if (url['type'] == 'variable') {
      button = ElevatedButton(
        style: style,
        onPressed: _hasBeenPressed
            ? null
            : () {
                setState(() {
                  _hasBeenPressed = true;
                });
                final buttonData =
                    ButtonData(buttonId: url['buttonId'], label: url['label']);
                widget.onVariablePressed(url['name'], url['value'],
                    buttonData: buttonData);
              },
        child: Text(url['label']),
      );
    } else {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: button,
    );
  }
}
