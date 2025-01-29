import 'package:ebbot_dart_client/entity/message/message.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';
import 'package:flutter/material.dart';

class RatingWidget extends StatefulWidget {
  final MessageContent content;
  final EbbotConfiguration configuration;
  final int initialRating;
  final void Function(int) onRatingChanged;
  final _serviceLocator = ServiceLocator();

  get _logger => _serviceLocator.getService<LogService>().logger;

  RatingWidget(
      {super.key,
      this.initialRating = 0,
      required this.onRatingChanged,
      required this.content,
      required this.configuration});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
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

    Widget rating = Icon(
      Icons.star_border,
      color: widget.configuration.theme.primaryColor,
      size: 30,
    );

    Widget ratingSelected = Icon(
      Icons.star,
      color: widget.configuration.theme.primaryColor,
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

    final theme = widget.configuration.theme;
    final question = widget.content.value['question'];
    final text = Text(question,
        textAlign: TextAlign.center, style: theme.receivedMessageBodyTextStyle);

    widget._logger.i("Building rating widget with rating: $_rating");

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
                    widget._logger.i("Rating changed to $_rating");
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
