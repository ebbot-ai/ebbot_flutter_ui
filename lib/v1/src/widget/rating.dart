import 'package:ebbot_dart_client/entities/message/message.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:flutter/material.dart';

class Rating extends StatefulWidget {
  final MessageContent content;
  final EbbotConfiguration configuration;
  final int initialRating;
  final void Function(int) onRatingChanged;

  const Rating(
      {super.key,
      this.initialRating = 0,
      required this.onRatingChanged,
      required this.content,
      required this.configuration});

  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
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
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            margin: const EdgeInsets.only(
                bottom: 10.0), // Adjust bottom margin as needed
            child: Text(widget.content.value['question'],
                textAlign: TextAlign.center,
                style: theme.receivedMessageBodyTextStyle),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    if (_hasRated == true) {
                      print("Has rated");
                      return;
                    }
                    print("Has not rated");
                    _rating = index + 1;
                    _hasRated = true;
                    widget.onRatingChanged(_rating);
                  });
                },
                child: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.yellow,
                  size: 30,
                ),
              );
            }),
          )
        ]));
  }
}
