import 'package:ebbot_dart_client/entity/message/message.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_support_service.dart';
import 'package:ebbot_flutter_ui/v1/src/theme/ebbot_text_styles.dart';
import 'package:flutter/material.dart';

class ListWidget extends StatefulWidget {
  final MessageContent content;
  final EbbotConfiguration configuration;

  const ListWidget({
    Key? key,
    required this.content,
    required this.configuration,
  }) : super(key: key);

  @override
  _ListWidget createState() => _ListWidget();
}

class _ListWidget extends State<ListWidget> {
  final ServiceLocator _serviceLocator = ServiceLocator();
  @override
  Widget build(BuildContext context) {
    final ebbotSupportService =
        _serviceLocator.getService<EbbotSupportService>();

    final receivedMessageBodyTextStyle = const TextStyle(
        fontSize: 14, 
        color: Colors.black87
      );

    final content = widget.content;

    final items = content.value['items'] as List;
    final text = content.value['text'] as String;

    final bulletItems = items.map((item) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• ', style: receivedMessageBodyTextStyle),
            Expanded(
              child: Text(
                item['text'],
                style: receivedMessageBodyTextStyle,
              ),
            ),
          ],
        ),
      );
    }).toList();

    List<Widget> children = [
      Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Text(text,
            textAlign: TextAlign.center,
            style: EbbotTextStyles.sectionTitle),
      ),
      ...bulletItems,
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
