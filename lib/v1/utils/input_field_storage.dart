import 'package:shared_preferences/shared_preferences.dart';

class InputFieldStorage {
  static const String _key = 'ebbot_input_field_visibility';

  // Singleton instance
  static final InputFieldStorage _instance = InputFieldStorage._internal();

  factory InputFieldStorage() {
    return _instance;
  }

  InputFieldStorage._internal();

  Future<void> save(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, value);
  }

  Future<String?> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  bool isVisible(String? value) {
    if (value == null) return true; // Default to visible
    return value == 'visible' || value == 'disabled';
  }
}

final inputFieldStorage = InputFieldStorage();
