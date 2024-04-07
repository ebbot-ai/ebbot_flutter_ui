import 'package:ebbot_dart_client/entities/message/message.dart';
import 'package:flutter/material.dart';

class Rating extends StatefulWidget {
  final int initialRating;
  final void Function(int) onRatingChanged;
  final MessageContent content;

  Rating(
      {this.initialRating = 0,
      required this.onRatingChanged,
      required this.content});

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
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            margin:
                EdgeInsets.only(bottom: 10.0), // Adjust bottom margin as needed
            child: Text(widget.content.value['question'],
                textAlign: TextAlign.center),
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
