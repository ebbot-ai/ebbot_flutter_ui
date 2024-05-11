import 'dart:convert';
import 'dart:math';

class StringUtil {
  static String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }
}
