import 'package:shared_preferences/shared_preferences.dart';

/// shared preference plugin services model class
class SharedPrefService {
  /// read any value
  static dynamic read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.get(key);
    return value;
  }

  /// write int
  static void saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }
}
