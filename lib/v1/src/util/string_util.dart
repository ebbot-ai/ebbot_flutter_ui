import 'package:uuid/uuid.dart';

class StringUtil {
  static String randomString() {
    return const Uuid().v4();
  }
}
