import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String userLoggedInkey = "";
  static String userNamekey = "";
  static String userEmailkey = "";

  static Future<bool?> getUserLogggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInkey);
  }
}
