import 'package:ebbot_dart_client/entity/button_data/button_data.dart';
import 'package:ebbot_dart_client/entity/message/message.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/url_button_widget.dart';
import 'package:flutter/material.dart';

class UrlBoxWidget extends StatefulWidget {
  final MessageContent content;
  final EbbotConfiguration configuration;
  final void Function(String, {ButtonData? buttonData}) onURlPressed;
  final void Function(String, {ButtonData? buttonData}) onScenarioPressed;
  final void Function(String, String, {ButtonData? buttonData})
      onVariablePressed;
  //final void Function(String, String,{ButtonData? buttonData}) onButtonClickPressed;

  const UrlBoxWidget({
    Key? key,
    required this.content,
    required this.configuration,
    required this.onURlPressed,
    required this.onScenarioPressed,
    required this.onVariablePressed,
    //required this.onButtonClickPressed,
  }) : super(key: key);

  @override
  _UrlBoxWidgetState createState() => _UrlBoxWidgetState();
}

class _UrlBoxWidgetState extends State<UrlBoxWidget> {
  @override
  Widget build(BuildContext context) {
    final content = widget.content;
    final theme = widget.configuration.theme;

    if (content.value['urls'] is! List) {
      return Container();
    }

    var description = content.value['description'];

    List<Widget> children = [
      Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Text(description,
            textAlign: TextAlign.center,
            style: theme.receivedMessageBodyTextStyle),
      ),
      ...(content.value['urls'] as List).map((url) => UrlButtonWidget(
          url: url,
          configuration: widget.configuration,
          onURlPressed: (String url, {ButtonData? buttonData}) {
            widget.onURlPressed(url, buttonData: buttonData);
          },
          onScenarioPressed: (String scenario, {ButtonData? buttonData}) {
            widget.onScenarioPressed(scenario, buttonData: buttonData);
          },
          onVariablePressed: (String name, String value,
              {ButtonData? buttonData}) {
            widget.onVariablePressed(name, value, buttonData: buttonData);
          } /*,
            onButtonClickPressed: (String buttonId, String label) {
              widget.onButtonClickPressed(buttonId, label);
            },*/
          )),
    ];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
