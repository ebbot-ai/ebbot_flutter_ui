import 'package:flutter/material.dart';

class EbbotChat {
  Widget? rating;
  Widget? ratingSelected;

  EbbotChat._builder(EbbotChatBuilder builder)
      : rating = builder._rating,
        ratingSelected = builder._ratingSelected;
}

class EbbotChatBuilder {
  Widget? _rating;
  Widget? _ratingSelected;

  EbbotChatBuilder rating(Widget rating) {
    _rating = rating;
    return this;
  }

  EbbotChatBuilder ratingSelected(Widget ratingSelected) {
    _ratingSelected = ratingSelected;
    return this;
  }

  EbbotChat build() {
    return EbbotChat._builder(this);
  }
}
