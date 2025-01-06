import 'package:ebbot_dart_client/entity/message/message.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
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
  RatingWidgetState createState() => RatingWidgetState();
}

class RatingWidgetState extends State<RatingWidget> {
  late int _rating;
  bool _hasRated = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.configuration.theme;
    final question = widget.content.value['question'];
    final text = Text(question,
        textAlign: TextAlign.center, style: theme.receivedMessageBodyTextStyle);
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
                child: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: widget.configuration.theme.primaryColor,
                  size: 30,
                ),
              );
            }),
          )
        ]));
  }
}
