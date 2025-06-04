import 'package:ebbot_dart_client/entity/button_data/button_data.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
import 'package:ebbot_flutter_ui/v1/src/util/extension.dart';
import 'package:flutter/material.dart';

class UrlButtonWidget extends StatefulWidget {
  final EbbotConfiguration configuration;
  final dynamic url;
  final void Function(String, {ButtonData? buttonData}) onURlPressed;
  final void Function(String, {String? state, ButtonData? buttonData})
      onScenarioPressed;
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

  final _serviceLocator = ServiceLocator();

  @override
  Widget build(BuildContext context) {
    return _urlMessageBuilder(widget.url);
  }

  Widget _urlMessageBuilder(dynamic url) {
    final ebbotClientService =
        _serviceLocator.getService<EbbotDartClientService>();
    final chatStyleConfig = ebbotClientService.client.chatStyleConfig;

    if (chatStyleConfig == null) {
      throw Exception(
          'Chat style configuration is not available. Please ensure it is set up correctly.');
    }

    final backgroundColor =
        HexColor.fromHex(chatStyleConfig.regular_btn_background_color);
    final textColor = HexColor.fromHex(chatStyleConfig.regular_btn_text_color);
    final disabledBackgroundColor =
        HexColor.fromHex(chatStyleConfig.btn_clicked_background_color);
    final disabledTextColor =
        HexColor.fromHex(chatStyleConfig.btn_clicked_text_color);

    final style = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledBackgroundColor;
        }
        return backgroundColor;
      }),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
      shape: WidgetStateProperty.resolveWith<OutlinedBorder>((states) {
        if (states.contains(WidgetState.disabled)) {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.grey),
          );
        }
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: backgroundColor),
        );
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledTextColor;
        }
        return textColor;
      }),
      textStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.disabled)) {
          return const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
          );
        }
        return const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        );
      }),
    );

    Widget button;
    final buttonId = url['buttonId'];
    final buttonLabel = url['label'];
    final buttonText = Text(buttonLabel);
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
                    ButtonData(buttonId: buttonId, label: buttonLabel);
                widget.onURlPressed(url['value'], buttonData: buttonData);
              },
        child: buttonText,
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
                    ButtonData(buttonId: buttonId, label: buttonLabel);
                String scenario = url['next']['scenario'];
                String? state = url['next'].containsKey('state')
                    ? url['next']['state']
                    : null;
                widget.onScenarioPressed(scenario,
                    state: state, buttonData: buttonData);
              },
        child: buttonText,
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
                    ButtonData(buttonId: buttonId, label: buttonLabel);
                widget.onVariablePressed(url['name'], url['value'],
                    buttonData: buttonData);
              },
        child: buttonText,
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
