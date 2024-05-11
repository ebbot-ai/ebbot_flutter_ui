import 'package:ebbot_dart_client/entity/message/message.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/url_button_widget.dart';
import 'package:flutter/material.dart';

class UrlBoxWidget extends StatefulWidget {
  final MessageContent content;
  final EbbotConfiguration configuration;
  final void Function(String) onURlPressed;
  final void Function(String) onScenarioPressed;
  final void Function(String, String) onVariablePressed;

  const UrlBoxWidget({
    Key? key,
    required this.content,
    required this.configuration,
    required this.onURlPressed,
    required this.onScenarioPressed,
    required this.onVariablePressed,
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
            onURlPressed: (String url) {
              widget.onURlPressed(url);
            },
            onScenarioPressed: (String scenario) {
              widget.onScenarioPressed(scenario);
            },
            onVariablePressed: (String name, String value) {
              widget.onVariablePressed(name, value);
            },
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
