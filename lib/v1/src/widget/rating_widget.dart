import 'package:ebbot_dart_client/entity/message/message.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_support_service.dart';
import 'package:ebbot_flutter_ui/v1/src/util/extension.dart';
import 'package:flutter/material.dart';

class RatingWidget extends StatefulWidget {
  final MessageContent content;
  final EbbotConfiguration configuration;
  final int initialRating;
  final void Function(int) onRatingChanged;

  const RatingWidget(
      {super.key,
      this.initialRating = 0,
      required this.onRatingChanged,
      required this.content,
      required this.configuration});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  final ServiceLocator _serviceLocator = ServiceLocator();
  late int _rating;
  bool _hasRated = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    final chatBehaviour = widget.configuration.chat;

    final ebbotClientService =
        _serviceLocator.getService<EbbotDartClientService>();

    final ebbotSupportService =
        _serviceLocator.getService<EbbotSupportService>();

    final receivedMessageBodyTextStyle =
        ebbotSupportService.chatTheme().receivedMessageBodyTextStyle;

    final chatStyleConfig = ebbotClientService.client.chatStyleConfig;
    if (chatStyleConfig == null) {
      throw Exception(
          'Chat style configuration is not available. Please ensure it is set up correctly.');
    }

    final primaryColor =
        HexColor.fromHex(chatStyleConfig.regular_btn_background_color);

    Widget rating = Icon(
      Icons.star_border,
      color: primaryColor,
      size: 30,
    );

    Widget ratingSelected = Icon(
      Icons.star,
      color: primaryColor,
      size: 30,
    );

    if (chatBehaviour.rating != null && chatBehaviour.ratingSelected != null) {
      rating = SizedBox(
        width: 30,
        height: 30,
        child: chatBehaviour.rating!,
      );
      ratingSelected = SizedBox(
        width: 30,
        height: 30,
        child: chatBehaviour.ratingSelected!,
      );
    }

    final question = widget.content.value['question'];
    final text = Text(question,
        textAlign: TextAlign.center, style: receivedMessageBodyTextStyle);

    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            child: text,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    if (_hasRated == true) {
                      return;
                    }
                    _rating = index + 1;
                    _hasRated = true;
                    widget.onRatingChanged(_rating);
                  });
                },
                child: index < _rating ? ratingSelected : rating,
              );
            }),
          )
        ]));
  }
}
