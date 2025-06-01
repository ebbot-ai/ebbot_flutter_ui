import 'dart:ui';

import 'package:ebbot_dart_client/entity/chat_config/chat_style_v2_config.dart';

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension TimeWindowDateExtension on TimeWindow? {
  bool get shouldShow {
    final now = DateTime.now();
    final startTime = this?.start;
    final endTime = this?.end;

    // TODO: No time window defined, default to showing the widget
    // maybe should be the other way around?
    if (startTime == null ||
        endTime == null ||
        startTime.isEmpty ||
        endTime.isEmpty) {
      return true;
    }

    final startTimeDateTime = DateTime.parse(startTime);
    final endTimeDateTime = DateTime.parse(endTime);
    return now.isAfter(startTimeDateTime) && now.isBefore(endTimeDateTime);
  }
}
