import 'package:shared_preferences/shared_preferences.dart';

/// shared preference plugin services model class
class SharedPrefService {
  static String userIdKey = "USERKEY";
  static String firstname = "FIRSTNAME";
  static String displayNameKey = "USERDISPLAYNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userProfileKey = "USERPROFILEKEY";

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

  //save data from google

  Future<bool> saveUserEmail(String getUseremail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUseremail);
  }

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveDisplayName(String getDisplayName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(displayNameKey, getDisplayName);
  }

  Future<bool> saveUserProfileUrl(String getUserProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userProfileKey, getUserProfile);
  }

  ///get data
  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString(firstname);
    return prefs.getString(firstname);
  }

  Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString(firstname);
    return prefs.getString(userEmailKey);
  }

  Future<String> getUserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString(firstname);
    return prefs.getString(displayNameKey);
  }

  Future<String> getUserprofile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString(firstname);
    return prefs.getString(userProfileKey);
  }

  Future<String> getdisplayname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString(firstname);
    return prefs.getString(displayNameKey);
  }
}
