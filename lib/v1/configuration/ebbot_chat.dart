import 'package:flutter/material.dart';

class EbbotChat {
  Widget? rating;
  Widget? ratingSelected;
  final bool showContextMenu;

  EbbotChat._builder(EbbotChatBuilder builder)
      : rating = builder._rating,
        ratingSelected = builder._ratingSelected,
        showContextMenu = builder._showContextMenu;
}

class EbbotChatBuilder {
  Widget? _rating;
  Widget? _ratingSelected;
  bool _showContextMenu = true;

  EbbotChatBuilder rating(Widget rating) {
    _rating = rating;
    return this;
  }

  EbbotChatBuilder ratingSelected(Widget ratingSelected) {
    _ratingSelected = ratingSelected;
    return this;
  }

  EbbotChatBuilder showContextMenu(bool show) {
    _showContextMenu = show;
    return this;
  }

  EbbotChat build() {
    return EbbotChat._builder(this);
  }
}
