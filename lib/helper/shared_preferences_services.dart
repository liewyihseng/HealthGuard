import 'package:shared_preferences/shared_preferences.dart';

/// shared preference plugin services model class
class SharedPrefService {
  static String firstname = "FIRSTNAME";

  /// read any value
  Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.get(key);
    return value;
  }

  /// write int
  void saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  ///get data
  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString(firstname);
    return prefs.getString(firstname);
  }
}