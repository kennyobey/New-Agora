import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String userLoggedInkey = "";
  static String userNamekey = "";
  static String userEmailkey = "";

  static Future<bool?> getUserLoggedInKey() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInkey);
  }
}
